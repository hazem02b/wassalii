"""
Test de l'endpoint change password
"""
import requests
import json

BASE_URL = "http://localhost:8000/api/v1"

# 1. Login pour obtenir un token
print("🔐 Login...")
login_response = requests.post(
    f"{BASE_URL}/auth/login",
    data={
        "username": "hazem@example.com",
        "password": "hazem123!"
    }
)

if login_response.status_code == 200:
    token = login_response.json()["access_token"]
    print(f"✅ Login réussi! Token: {token[:20]}...")
    
    # 2. Test change password
    print("\n🔄 Test changement de mot de passe...")
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    change_pwd_response = requests.put(
        f"{BASE_URL}/auth/change-password",
        headers=headers,
        json={
            "current_password": "hazem123!",
            "new_password": "hazem1234!"
        }
    )
    
    print(f"Status: {change_pwd_response.status_code}")
    print(f"Response: {change_pwd_response.text}")
    
    if change_pwd_response.status_code == 200:
        print("✅ Changement de mot de passe réussi!")
        
        # 3. Reset le mot de passe
        print("\n🔙 Reset mot de passe...")
        reset_response = requests.put(
            f"{BASE_URL}/auth/change-password",
            headers=headers,
            json={
                "current_password": "hazem1234!",
                "new_password": "hazem123!"
            }
        )
        print(f"Reset status: {reset_response.status_code}")
    else:
        print(f"❌ Erreur: {change_pwd_response.text}")
else:
    print(f"❌ Login échoué: {login_response.status_code}")
    print(login_response.text)
