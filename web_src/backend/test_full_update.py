"""
Test détaillé de l'authentification et mise à jour
"""
import requests
import json
from datetime import datetime

BASE_URL = "http://localhost:8000/api/v1"

print("="*60)
print(f"Test à: {datetime.now()}")
print("="*60)

# 1. Créer un nouvel utilisateur
print("\n1️⃣ Création d'un nouvel utilisateur...")
timestamp = datetime.now().strftime("%H%M%S")
signup_data = {
    "email": f"user{timestamp}@test.com",
    "password": "Password123!",
    "name": "Test User",
    "role": "client",
    "phone": f"+216{timestamp[:8]}"
}

try:
    signup_response = requests.post(
        f"{BASE_URL}/auth/register",
        json=signup_data
    )
    print(f"   Status: {signup_response.status_code}")
    
    if signup_response.status_code == 201:
        signup_result = signup_response.json()
        token = signup_result.get("access_token")
        user_id = signup_result.get("user", {}).get("id")
        print(f"   ✅ Utilisateur créé: {signup_data['email']}")
        print(f"   📧 Email: {signup_data['email']}")
        print(f"   🔑 ID: {user_id}")
        print(f"   🎫 Token: {token[:30]}...")
        
        # 2. Tester la mise à jour immédiatement
        print("\n2️⃣ Mise à jour du profil...")
        update_data = {
            "name": "Updated Test User",
            "phone": "+21698888888"
        }
        
        headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }
        
        print(f"   URL: {BASE_URL}/auth/me")
        print(f"   Headers: Authorization: Bearer {token[:20]}...")
        print(f"   Data: {json.dumps(update_data, indent=6)}")
        
        update_response = requests.put(
            f"{BASE_URL}/auth/me",
            headers=headers,
            json=update_data
        )
        
        print(f"\n   Status Code: {update_response.status_code}")
        
        if update_response.status_code == 200:
            updated_user = update_response.json()
            print(f"   ✅ Mise à jour réussie!")
            print(f"   📝 Nouveau nom: {updated_user.get('name')}")
            print(f"   📞 Nouveau tél: {updated_user.get('phone')}")
        else:
            print(f"   ❌ Erreur lors de la mise à jour")
            print(f"   Response: {json.dumps(update_response.json(), indent=6)}")
            
        # 3. Vérifier le profil
        print("\n3️⃣ Vérification du profil...")
        profile_response = requests.get(
            f"{BASE_URL}/auth/me",
            headers=headers
        )
        
        if profile_response.status_code == 200:
            profile = profile_response.json()
            print(f"   ✅ Profil récupéré")
            print(f"   📝 Nom: {profile.get('name')}")
            print(f"   📧 Email: {profile.get('email')}")
            print(f"   📞 Tél: {profile.get('phone')}")
        else:
            print(f"   ❌ Erreur: {profile_response.status_code}")
            
    else:
        print(f"   ❌ Erreur lors de l'inscription")
        print(f"   Response: {json.dumps(signup_response.json(), indent=2)}")
        
except Exception as e:
    print(f"\n❌ Exception: {str(e)}")
    import traceback
    traceback.print_exc()

print("\n" + "="*60)
