"""
Test de création de trajet
"""
import requests
import random
from datetime import datetime, timedelta

BASE_URL = "http://localhost:8000/api/v1"

# 1. Créer un compte transporteur
random_id = random.randint(100000000, 999999999)
transporter_data = {
    "name": "Test Transporteur Trip",
    "email": f"transporteur.trip.{random_id}@example.com",
    "phone": "+212600123456",
    "password": "test123456"
}

print("\n=== 1. Inscription transporteur ===")
response = requests.post(f"{BASE_URL}/auth/register/transporter", json=transporter_data)
print(f"Status: {response.status_code}")

if response.status_code != 201:
    print(f"Erreur inscription: {response.text}")
    exit(1)

result = response.json()
token = result["access_token"]
user_id = result["user"]["id"]
print(f"✅ Transporteur créé (ID: {user_id})")
print(f"Token: {token[:50]}...")

# 2. Créer un trajet
print("\n=== 2. Création du trajet ===")

# Date de départ dans 7 jours
departure = datetime.now() + timedelta(days=7)

trip_data = {
    "origin_city": "Tunis",
    "origin_country": "Tunisie",
    "destination_city": "Paris",
    "destination_country": "France",
    "departure_date": departure.isoformat(),
    "max_weight": 50.0,
    "price_per_kg": 15.5,
    "description": "Trajet Tunis-Paris, livraison rapide",
    "accepted_items": ["Electronics", "Documents", "Books"],
    "vehicle_info": "Van Mercedes"
}

print(f"Données du trajet:")
print(f"  De: {trip_data['origin_city']} ({trip_data['origin_country']})")
print(f"  Vers: {trip_data['destination_city']} ({trip_data['destination_country']})")
print(f"  Date: {trip_data['departure_date']}")
print(f"  Capacité: {trip_data['max_weight']} kg")
print(f"  Prix: {trip_data['price_per_kg']} €/kg")

headers = {
    "Authorization": f"Bearer {token}",
    "Content-Type": "application/json"
}

response = requests.post(f"{BASE_URL}/trips/", json=trip_data, headers=headers)
print(f"\nStatus: {response.status_code}")

if response.status_code == 201:
    trip = response.json()
    print(f"✅ Trajet créé avec succès!")
    print(f"   ID: {trip['id']}")
    print(f"   Transporteur: {trip['transporter_id']}")
    print(f"   Capacité disponible: {trip['available_weight']} kg")
    print(f"   Actif: {trip['is_active']}")
    
    # 3. Vérifier que le trajet est visible
    print("\n=== 3. Vérification - Liste des trajets ===")
    response = requests.get(f"{BASE_URL}/trips/")
    if response.status_code == 200:
        trips = response.json()
        print(f"✅ {len(trips)} trajets trouvés")
        
        # Chercher notre trajet
        our_trip = next((t for t in trips if t['id'] == trip['id']), None)
        if our_trip:
            print(f"✅ Notre trajet est visible dans la liste!")
        else:
            print(f"❌ Notre trajet n'est PAS dans la liste")
    else:
        print(f"❌ Erreur liste: {response.text}")
    
    # 4. Rechercher le trajet
    print("\n=== 4. Recherche du trajet ===")
    search_params = {
        "origin": "Tunis",
        "destination": "Paris"
    }
    response = requests.get(f"{BASE_URL}/trips/search", params=search_params)
    if response.status_code == 200:
        results = response.json()
        print(f"✅ {len(results)} trajets trouvés pour Tunis -> Paris")
        if any(t['id'] == trip['id'] for t in results):
            print(f"✅ Notre trajet apparaît dans les résultats de recherche!")
        else:
            print(f"❌ Notre trajet n'apparaît PAS dans la recherche")
    else:
        print(f"❌ Erreur recherche: {response.text}")
    
else:
    print(f"❌ Erreur création trajet:")
    print(response.text)
    
    # Afficher les détails de l'erreur
    try:
        error = response.json()
        print(f"Détail: {error}")
    except:
        pass

print("\n" + "="*60)
print("Test terminé!")
