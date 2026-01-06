"""
Script de test pour la mise à jour du profil
"""
import requests
import json

# Configuration
BASE_URL = "http://localhost:8000/api/v1"

# 1. Login first to get token
print("🔐 Connexion...")
login_data = {
    "username": "testuser@example.com",
    "password": "Test123!"
}

try:
    login_response = requests.post(
        f"{BASE_URL}/auth/login",
        data=login_data  # Form data, not JSON
    )
    
    if login_response.status_code == 200:
        token = login_response.json()["access_token"]
        print(f"✅ Connecté avec succès")
        print(f"Token: {token[:20]}...")
        
        # 2. Test update profile
        print("\n📝 Mise à jour du profil...")
        update_data = {
            "name": "Test Client Updated",
            "phone": "+21612345678"
        }
        
        headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }
        
        update_response = requests.put(
            f"{BASE_URL}/auth/me",
            headers=headers,
            json=update_data
        )
        
        print(f"\nStatus Code: {update_response.status_code}")
        print(f"Response: {json.dumps(update_response.json(), indent=2)}")
        
        if update_response.status_code == 200:
            print("\n✅ Mise à jour réussie!")
        else:
            print("\n❌ Erreur lors de la mise à jour")
            
    else:
        print(f"❌ Erreur de connexion: {login_response.status_code}")
        print(f"Response: {login_response.json()}")
        
except Exception as e:
    print(f"❌ Erreur: {str(e)}")
