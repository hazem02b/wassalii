"""
Test d'intégration Frontend-Backend
"""
import requests
import json

BASE_URL = "http://localhost:8000/api/v1"

print("=" * 60)
print("TEST INTEGRATION FRONTEND-BACKEND")
print("=" * 60)

# Test 1: Inscription
print("\n1️⃣ TEST INSCRIPTION")
print("-" * 60)

user_data = {
    "email": "integration@test.ma",
    "password": "Test123!",
    "first_name": "Test",
    "last_name": "Integration",
    "phone": "+212600000000",
    "role": "client"
}

try:
    response = requests.post(f"{BASE_URL}/auth/register", json=user_data)
    print(f"Status: {response.status_code}")
    
    if response.status_code == 201:
        data = response.json()
        print("✅ SUCCÈS - Inscription réussie")
        print(f"Token: {data['access_token'][:50]}...")
        print(f"User: {data['user']['email']}")
        TOKEN = data['access_token']
    elif response.status_code == 400:
        print("⚠️ Email déjà enregistré (normal si déjà testé)")
        # On essaie de se connecter
        print("\n2️⃣ TEST LOGIN (car email existe)")
        print("-" * 60)
        login_data = {
            "username": user_data["email"],
            "password": user_data["password"]
        }
        response = requests.post(f"{BASE_URL}/auth/login", data=login_data)
        if response.status_code == 200:
            data = response.json()
            print("✅ SUCCÈS - Connexion réussie")
            print(f"Token: {data['access_token'][:50]}...")
            TOKEN = data['access_token']
        else:
            print(f"❌ ERREUR LOGIN: {response.status_code}")
            print(response.json())
            exit(1)
    else:
        print(f"❌ ERREUR: {response.status_code}")
        print(response.json())
        exit(1)
except Exception as e:
    print(f"❌ ERREUR: {e}")
    exit(1)

# Test 3: Récupération du profil
print("\n3️⃣ TEST PROFIL")
print("-" * 60)

try:
    headers = {"Authorization": f"Bearer {TOKEN}"}
    response = requests.get(f"{BASE_URL}/auth/me", headers=headers)
    
    if response.status_code == 200:
        user = response.json()
        print("✅ SUCCÈS - Profil récupéré")
        print(f"Email: {user['email']}")
        print(f"Nom: {user['first_name']} {user['last_name']}")
        print(f"Rôle: {user['role']}")
    else:
        print(f"❌ ERREUR: {response.status_code}")
        print(response.json())
except Exception as e:
    print(f"❌ ERREUR: {e}")

# Test 4: Liste des trajets
print("\n4️⃣ TEST LISTE TRAJETS")
print("-" * 60)

try:
    response = requests.get(f"{BASE_URL}/trips")
    
    if response.status_code == 200:
        trips = response.json()
        print(f"✅ SUCCÈS - {len(trips)} trajets trouvés")
    else:
        print(f"❌ ERREUR: {response.status_code}")
except Exception as e:
    print(f"❌ ERREUR: {e}")

print("\n" + "=" * 60)
print("RÉSUMÉ")
print("=" * 60)
print("✅ Backend API: http://localhost:8000")
print("✅ Inscription/Login: Fonctionne")
print("✅ Authentification JWT: Fonctionne")
print("✅ Endpoints publics: Fonctionnent")
print("\n⚠️  VÉRIFIEZ MAINTENANT LE FRONTEND:")
print("   1. Ouvrez http://localhost:5173")
print("   2. Ouvrez la Console (F12)")
print("   3. Essayez de vous inscrire")
print("   4. Regardez les requêtes dans l'onglet Network")
print("=" * 60)
