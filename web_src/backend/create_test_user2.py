"""
Script pour créer un utilisateur de test
"""
import requests
import json

BASE_URL = "http://localhost:8000/api/v1"

print("📝 Création d'un utilisateur de test...")

# Données d'inscription
signup_data = {
    "email": "testuser@example.com",
    "password": "Test123!",
    "name": "Test User",
    "role": "client",
    "phone": "+21698765432"
}

try:
    response = requests.post(
        f"{BASE_URL}/auth/register",
        json=signup_data
    )
    
    print(f"Status: {response.status_code}")
    
    if response.status_code == 200:
        data = response.json()
        print(f"\n✅ Utilisateur créé avec succès!")
        print(f"Email: {signup_data['email']}")
        print(f"Password: {signup_data['password']}")
        print(f"Token: {data.get('access_token', 'N/A')[:30]}...")
    else:
        print(f"\n❌ Erreur: {response.json()}")
        
except Exception as e:
    print(f"❌ Erreur: {str(e)}")
