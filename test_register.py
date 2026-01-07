import requests
import json

# Test d'inscription
print("Test d'inscription...")
url = "http://localhost:8000/api/v1/auth/register"
data = {
    "email": "moncompte@wassali.com",
    "password": "MonMotDePasse123",
    "name": "Mon Nom",
    "phone": "0612345678",
    "role": "client"
}

try:
    response = requests.post(url, json=data)
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}")
    
    if response.status_code == 201:
        print("\n✅ Inscription réussie!")
        print(f"Email: {data['email']}")
        print(f"Password: {data['password']}")
    else:
        print("\n❌ Erreur lors de l'inscription")
except Exception as e:
    print(f"❌ Erreur: {e}")
