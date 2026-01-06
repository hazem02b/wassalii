import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import requests
import json

BASE_URL = "http://localhost:8000/api/v1"

# Test inscription transporteur
print("="*60)
print("TEST INSCRIPTION TRANSPORTEUR")
print("="*60)

data = {
    "name": "Test Transporteur Debug",
    "email": f"test.debug.{os.urandom(4).hex()}@example.com",
    "phone": "+212600999888",
    "password": "test1234!",
    "role": "transporter"
}

print(f"\nDonnées envoyées:")
print(json.dumps(data, indent=2))

try:
    response = requests.post(
        f"{BASE_URL}/auth/register",
        json=data,
        headers={"Content-Type": "application/json"}
    )
    
    print(f"\nStatus Code: {response.status_code}")
    print(f"Response:")
    
    if response.status_code == 201:
        result = response.json()
        print(json.dumps(result, indent=2, default=str))
        print("\n✅ Inscription réussie!")
    else:
        print(response.text)
        print("\n❌ Erreur d'inscription")
        
except Exception as e:
    print(f"\n❌ Exception: {str(e)}")
    import traceback
    traceback.print_exc()
