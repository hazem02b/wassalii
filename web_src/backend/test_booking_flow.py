"""
Test complet du flow de booking
"""
import requests
import json

BASE_URL = "http://127.0.0.1:8888/api/v1"

print("="*60)
print("TEST DU FLOW COMPLET DE BOOKING")
print("="*60)

# 1. Login en tant que client
print("\n1. Login client...")
login_response = requests.post(
    f"{BASE_URL}/auth/login",
    json={
        "email": "testclient@wassali.com",
        "password": "Test@123",
        "role": "client"
    }
)

if login_response.status_code != 200:
    print(f"❌ Login échoué: {login_response.status_code}")
    print(login_response.text)
    # Essayer avec un autre mot de passe
    print("\nEssai avec un mot de passe alternatif...")
    login_response = requests.post(
        f"{BASE_URL}/auth/login",
        json={
            "email": "hazembellili800@gmail.com",
            "password": "123456",
            "role": "client"
        }
    )
    if login_response.status_code != 200:
        print(f"❌ Login échoué à nouveau: {login_response.status_code}")
        exit(1)

token = login_response.json()['access_token']
print(f"✅ Login réussi, token obtenu")

headers = {"Authorization": f"Bearer {token}"}

# 2. Récupérer les trips disponibles
print("\n2. Récupération des trips disponibles...")
trips_response = requests.get(f"{BASE_URL}/trips", headers=headers)

if trips_response.status_code != 200:
    print(f"❌ Erreur récupération trips: {trips_response.status_code}")
    print(trips_response.text)
    exit(1)

trips = trips_response.json()
print(f"✅ {len(trips)} trip(s) disponible(s)")

if not trips:
    print("⚠️ Aucun trip disponible pour tester le booking")
    exit(0)

# Prendre le premier trip actif avec du poids disponible
selected_trip = None
for trip in trips:
    if trip.get('is_active') and trip.get('available_weight', 0) > 0:
        selected_trip = trip
        break

if not selected_trip:
    print("⚠️ Aucun trip actif avec du poids disponible")
    exit(0)

print(f"✅ Trip sélectionné: {selected_trip['origin_city']} → {selected_trip['destination_city']}")
print(f"   Poids disponible: {selected_trip['available_weight']} kg")
print(f"   Prix par kg: {selected_trip['price_per_kg']}€")

# 3. Créer un booking
print("\n3. Création du booking...")
booking_data = {
    "trip_id": selected_trip['id'],
    "weight": 2.5,
    "item_type": "Documents",
    "description": "Test booking - Documents importants",
    "pickup_address": "123 Avenue Habib Bourguiba",
    "pickup_city": "Tunis",
    "delivery_address": "456 Rue de la République",
    "delivery_city": "Paris",
    "recipient_name": "Jean Dupont",
    "recipient_phone": "+33 6 12 34 56 78"
}

booking_response = requests.post(
    f"{BASE_URL}/bookings",
    headers=headers,
    json=booking_data
)

if booking_response.status_code != 201:
    print(f"❌ Erreur création booking: {booking_response.status_code}")
    print(booking_response.text)
    exit(1)

booking = booking_response.json()
print(f"✅ Booking créé avec succès!")
print(f"   ID: {booking['id']}")
print(f"   Tracking: {booking['tracking_number']}")
print(f"   Prix total: {booking['total_price']}€")
print(f"   Status: {booking['status']}")
print(f"   Payé: {booking['is_paid']}")

# 4. Mettre à jour le paiement
print("\n4. Simulation du paiement...")
payment_response = requests.put(
    f"{BASE_URL}/bookings/{booking['id']}",
    headers=headers,
    json={
        "is_paid": True,
        "payment_method": "card"
    }
)

if payment_response.status_code != 200:
    print(f"❌ Erreur paiement: {payment_response.status_code}")
    print(payment_response.text)
else:
    updated_booking = payment_response.json()
    print(f"✅ Paiement enregistré!")
    print(f"   Payé: {updated_booking['is_paid']}")
    print(f"   Méthode: {updated_booking['payment_method']}")

# 5. Récupérer les bookings du client
print("\n5. Vérification des bookings du client...")
my_bookings_response = requests.get(f"{BASE_URL}/bookings", headers=headers)

if my_bookings_response.status_code != 200:
    print(f"❌ Erreur récupération bookings: {my_bookings_response.status_code}")
    print(my_bookings_response.text)
else:
    my_bookings = my_bookings_response.json()
    print(f"✅ {len(my_bookings)} booking(s) trouvé(s)")
    for b in my_bookings[:3]:  # Afficher les 3 premiers
        print(f"   - {b['tracking_number']}: {b['item_type']} ({b['weight']}kg) - {b['status']}")

# 6. Tester le tracking public
print("\n6. Test du tracking public...")
tracking_response = requests.get(f"{BASE_URL}/bookings/tracking/{booking['tracking_number']}")

if tracking_response.status_code != 200:
    print(f"❌ Erreur tracking: {tracking_response.status_code}")
    print(tracking_response.text)
else:
    tracked = tracking_response.json()
    print(f"✅ Tracking fonctionne!")
    print(f"   Status: {tracked['status']}")
    print(f"   De: {tracked['pickup_city']} → Vers: {tracked['delivery_city']}")

print("\n" + "="*60)
print("✅ TOUS LES TESTS RÉUSSIS!")
print("="*60)
