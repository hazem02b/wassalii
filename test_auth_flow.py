"""
Test automatique de l'authentification Client et Transporteur
Teste: inscription + connexion pour les deux types d'utilisateurs
"""
import requests
import json
from datetime import datetime

BASE_URL = "http://127.0.0.1:8000/api/v1"

def print_section(title):
    print(f"\n{'='*60}")
    print(f"  {title}")
    print(f"{'='*60}\n")

def test_client_signup():
    """Test inscription client"""
    print_section("TEST 1: INSCRIPTION CLIENT")
    
    timestamp = datetime.now().strftime("%H%M%S")
    data = {
        "email": f"client_test_{timestamp}@example.com",
        "password": "Test1234!",
        "name": "Test Client",
        "phone": "+33612345678",
        "user_type": "client",
        "role": "client"
    }
    
    print(f"📤 POST {BASE_URL}/auth/register")
    print(f"   Data: {json.dumps(data, indent=2)}")
    
    try:
        response = requests.post(f"{BASE_URL}/auth/register", json=data, timeout=10)
        print(f"\n📥 Status: {response.status_code}")
        print(f"   Response: {json.dumps(response.json(), indent=2)}")
        
        if response.status_code == 201:
            print("✅ Inscription client réussie!")
            return data["email"], data["password"]
        else:
            print(f"❌ Échec inscription: {response.status_code}")
            return None, None
    except Exception as e:
        print(f"❌ Erreur: {str(e)}")
        return None, None

def test_client_login(email, password):
    """Test connexion client"""
    print_section("TEST 2: CONNEXION CLIENT")
    
    data = {
        "username": email,
        "password": password
    }
    
    print(f"📤 POST {BASE_URL}/auth/login")
    print(f"   Data: {json.dumps(data, indent=2)}")
    
    try:
        response = requests.post(f"{BASE_URL}/auth/login", json=data, timeout=10)
        print(f"\n📥 Status: {response.status_code}")
        print(f"   Response: {json.dumps(response.json(), indent=2)}")
        
        if response.status_code == 200:
            token = response.json().get("access_token")
            print(f"✅ Connexion client réussie!")
            print(f"   Token: {token[:50]}..." if token else "   No token")
            return token
        else:
            print(f"❌ Échec connexion: {response.status_code}")
            return None
    except Exception as e:
        print(f"❌ Erreur: {str(e)}")
        return None

def test_transporter_signup():
    """Test inscription transporteur"""
    print_section("TEST 3: INSCRIPTION TRANSPORTEUR")
    
    timestamp = datetime.now().strftime("%H%M%S")
    data = {
        "email": f"transporter_test_{timestamp}@example.com",
        "password": "Test1234!",
        "name": "Test Transporteur",
        "phone": "+33612345679",
        "user_type": "transporter",
        "role": "transporter",
        "vehicle_type": "Van",
        "vehicle_plate": "AB-123-CD"
    }
    
    print(f"📤 POST {BASE_URL}/auth/register")
    print(f"   Data: {json.dumps(data, indent=2)}")
    
    try:
        response = requests.post(f"{BASE_URL}/auth/register", json=data, timeout=10)
        print(f"\n📥 Status: {response.status_code}")
        print(f"   Response: {json.dumps(response.json(), indent=2)}")
        
        if response.status_code == 201:
            print("✅ Inscription transporteur réussie!")
            return data["email"], data["password"]
        else:
            print(f"❌ Échec inscription: {response.status_code}")
            return None, None
    except Exception as e:
        print(f"❌ Erreur: {str(e)}")
        return None, None

def test_transporter_login(email, password):
    """Test connexion transporteur"""
    print_section("TEST 4: CONNEXION TRANSPORTEUR")
    
    data = {
        "username": email,
        "password": password
    }
    
    print(f"📤 POST {BASE_URL}/auth/login")
    print(f"   Data: {json.dumps(data, indent=2)}")
    
    try:
        response = requests.post(f"{BASE_URL}/auth/login", json=data, timeout=10)
        print(f"\n📥 Status: {response.status_code}")
        print(f"   Response: {json.dumps(response.json(), indent=2)}")
        
        if response.status_code == 200:
            token = response.json().get("access_token")
            print(f"✅ Connexion transporteur réussie!")
            print(f"   Token: {token[:50]}..." if token else "   No token")
            return token
        else:
            print(f"❌ Échec connexion: {response.status_code}")
            return None
    except Exception as e:
        print(f"❌ Erreur: {str(e)}")
        return None

def main():
    print("\n🚀 DÉMARRAGE DES TESTS D'AUTHENTIFICATION")
    print(f"Backend: {BASE_URL}")
    
    # Test health check
    try:
        health = requests.get("http://127.0.0.1:8000/health", timeout=5)
        print(f"✅ Backend accessible: {health.json()}")
    except:
        print("❌ Backend non accessible!")
        return
    
    results = {
        "client_signup": False,
        "client_login": False,
        "transporter_signup": False,
        "transporter_login": False
    }
    
    # Tests Client
    client_email, client_password = test_client_signup()
    if client_email:
        results["client_signup"] = True
        client_token = test_client_login(client_email, client_password)
        if client_token:
            results["client_login"] = True
    
    # Tests Transporteur
    transporter_email, transporter_password = test_transporter_signup()
    if transporter_email:
        results["transporter_signup"] = True
        transporter_token = test_transporter_login(transporter_email, transporter_password)
        if transporter_token:
            results["transporter_login"] = True
    
    # Résumé
    print_section("RÉSUMÉ DES TESTS")
    for test, passed in results.items():
        status = "✅ PASS" if passed else "❌ FAIL"
        print(f"{status}  {test}")
    
    total = sum(results.values())
    print(f"\n📊 Score: {total}/4 tests réussis")
    
    if total == 4:
        print("\n🎉 Tous les tests ont réussi!")
    else:
        print(f"\n⚠️  {4-total} test(s) ont échoué")

if __name__ == "__main__":
    main()
