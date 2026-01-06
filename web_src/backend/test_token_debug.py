"""
Vérifier le token
"""
import jwt
import requests
import json

BASE_URL = "http://localhost:8000/api/v1"

# Créer un utilisateur
timestamp = "debug01"
signup_data = {
    "email": f"user{timestamp}@test.com",
    "password": "Password123!",
    "name": "Debug User",
    "role": "client",
    "phone": f"+21699999{timestamp[:3]}"
}

signup_response = requests.post(
    f"{BASE_URL}/auth/register",
    json=signup_data
)

if signup_response.status_code == 201:
    result = signup_response.json()
    token = result.get("access_token")
    
    print(f"Token reçu: {token}\n")
    
    # Décoder le token sans vérification pour voir son contenu
    try:
        decoded = jwt.decode(token, options={"verify_signature": False})
        print(f"Token décodé:")
        print(json.dumps(decoded, indent=2))
        print(f"\nUser ID dans token: {decoded.get('sub')}")
        print(f"User ID créé: {result.get('user', {}).get('id')}")
        
    except Exception as e:
        print(f"Erreur décodage: {e}")
        
    # Tester avec le token
    print("\n" + "="*50)
    print("Test de mise à jour...")
    
    headers = {"Authorization": f"Bearer {token}"}
    update_response = requests.put(
        f"{BASE_URL}/auth/me",
        headers=headers,
        json={"name": "New Name", "phone": "+21611111111"}
    )
    
    print(f"Status: {update_response.status_code}")
    print(f"Response: {update_response.json()}")
    
else:
    print(f"Erreur création: {signup_response.json()}")
