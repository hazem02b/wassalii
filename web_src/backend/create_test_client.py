"""
Créer un utilisateur de test pour les bookings
"""
import requests

BASE_URL = "http://127.0.0.1:8888/api/v1"

print("Création d'un client de test...")

register_data = {
    "email": "testclient@wassali.com",
    "password": "Test@123",
    "name": "Client Test",
    "phone": "+216 12 345 678",
    "role": "client"
}

response = requests.post(
    f"{BASE_URL}/auth/register/client",
    json=register_data
)

if response.status_code == 201:
    print("✅ Client créé avec succès!")
    print(f"Email: {register_data['email']}")
    print(f"Password: {register_data['password']}")
    print(f"Name: {register_data['name']}")
else:
    print(f"❌ Erreur: {response.status_code}")
    print(response.text)
