"""
Script de test pour l'API Wassali
"""
import requests
import json

BASE_URL = "http://localhost:8000/api/v1"

def test_health():
    """Test l'endpoint de santé"""
    print("\n🔍 Test de l'API...")
    response = requests.get("http://localhost:8000/health")
    print(f"✅ Santé de l'API: {response.json()}")
    return response.status_code == 200

def register_user(email, password, first_name, last_name, phone, role="client"):
    """Créer un nouvel utilisateur"""
    print(f"\n📝 Inscription de {email}...")
    data = {
        "email": email,
        "password": password,
        "first_name": first_name,
        "last_name": last_name,
        "phone": phone,
        "role": role
    }
    response = requests.post(f"{BASE_URL}/auth/register", json=data)
    if response.status_code == 200 or response.status_code == 201:
        result = response.json()
        print(f"✅ Utilisateur créé: {result['user']['email']}")
        print(f"🔑 Token: {result['access_token'][:50]}...")
        return result
    else:
        print(f"❌ Erreur {response.status_code}: {response.text[:200]}")
        return None

def login_user(email, password):
    """Se connecter"""
    print(f"\n🔐 Connexion de {email}...")
    data = {
        "username": email,
        "password": password
    }
    response = requests.post(f"{BASE_URL}/auth/login", data=data)
    if response.status_code == 200:
        result = response.json()
        print(f"✅ Connecté!")
        print(f"🔑 Token: {result['access_token'][:50]}...")
        return result
    else:
        print(f"❌ Erreur {response.status_code}: {response.text[:200]}")
        return None

def create_trip(token, from_city, to_city, departure_date, price_per_kg):
    """Créer un trajet"""
    print(f"\n🚗 Création d'un trajet {from_city} → {to_city}...")
    headers = {"Authorization": f"Bearer {token}"}
    data = {
        "origin_city": from_city,
        "origin_country": "Maroc",
        "destination_city": to_city,
        "destination_country": "France",
        "departure_date": departure_date,
        "arrival_date": departure_date,  # Même jour pour test
        "max_weight": 20.0,
        "available_weight": 20.0,
        "price_per_kg": price_per_kg,
        "description": "Trajet test",
        "vehicle_info": "Voiture"
    }
    response = requests.post(f"{BASE_URL}/trips", json=data, headers=headers)
    if response.status_code == 200 or response.status_code == 201:
        result = response.json()
        print(f"✅ Trajet créé: ID {result['id']}")
        return result
    else:
        print(f"❌ Erreur {response.status_code}: {response.text[:200]}")
        return None

def main():
    print("=" * 60)
    print("🧪 TEST DE L'API WASSALI")
    print("=" * 60)
    
    # 1. Test de santé
    if not test_health():
        print("❌ L'API ne répond pas!")
        return
    
    # 2. Créer un transporteur
    print("\n" + "=" * 60)
    print("👤 CRÉATION D'UN TRANSPORTEUR")
    print("=" * 60)
    transporter = register_user(
        email="transporteur@test.com",
        password="Test123!",
        first_name="Ahmed",
        last_name="Transport",
        phone="+212612345678",
        role="transporter"
    )
    
    if not transporter:
        print("⚠️ Le transporteur existe déjà, connexion...")
        transporter = login_user("transporteur@test.com", "Test123!")
    
    # 3. Créer un client
    print("\n" + "=" * 60)
    print("👤 CRÉATION D'UN CLIENT")
    print("=" * 60)
    client = register_user(
        email="client@test.com",
        password="Test123!",
        first_name="Fatima",
        last_name="Client",
        phone="+33612345678",
        role="client"
    )
    
    if not client:
        print("⚠️ Le client existe déjà, connexion...")
        client = login_user("client@test.com", "Test123!")
    
    # 4. Créer un trajet
    if transporter:
        print("\n" + "=" * 60)
        print("🚗 CRÉATION D'UN TRAJET")
        print("=" * 60)
        trip = create_trip(
            token=transporter['access_token'],
            from_city="Casablanca",
            to_city="Paris",
            departure_date="2025-01-15",
            price_per_kg=15.0
        )
    
    print("\n" + "=" * 60)
    print("✅ TESTS TERMINÉS!")
    print("=" * 60)
    print("\n📊 Vous pouvez maintenant:")
    print("   1. Voir la doc API: http://localhost:8000/api/v1/docs")
    print("   2. Tester manuellement dans Swagger UI")
    print("   3. Utiliser ces credentials:")
    print("      - Transporteur: transporteur@test.com / Test123!")
    print("      - Client: client@test.com / Test123!")

if __name__ == "__main__":
    main()
