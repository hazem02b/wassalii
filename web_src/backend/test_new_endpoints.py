import requests
import random

# Test de l'endpoint client
random_id = random.randint(100000000, 999999999)
client_data = {
    "name": "Test Client",
    "email": f"client.{random_id}@example.com",
    "phone": "+212600123456",
    "password": "test123456"
}

print("\n=== Test endpoint /auth/register/client ===")
print(f"Data: {client_data}\n")

try:
    response = requests.post(
        "http://localhost:8000/api/v1/auth/register/client",
        json=client_data,
        headers={"Content-Type": "application/json"}
    )
    
    print(f"Status Code: {response.status_code}")
    
    if response.status_code == 201:
        result = response.json()
        print("✅ SUCCESS!")
        print(f"User ID: {result['user']['id']}")
        print(f"Email: {result['user']['email']}")
        print(f"Role: {result['user']['role']}")
    else:
        print(f"❌ ERROR: {response.status_code}")
        print(f"Response: {response.text}")
        
except Exception as e:
    print(f"❌ Exception: {e}")

# Test de l'endpoint transporter
random_id = random.randint(100000000, 999999999)
transporter_data = {
    "name": "Test Transporteur",
    "email": f"transporteur.{random_id}@example.com",
    "phone": "+212600123456",
    "password": "test123456"
}

print("\n=== Test endpoint /auth/register/transporter ===")
print(f"Data: {transporter_data}\n")

try:
    response = requests.post(
        "http://localhost:8000/api/v1/auth/register/transporter",
        json=transporter_data,
        headers={"Content-Type": "application/json"}
    )
    
    print(f"Status Code: {response.status_code}")
    
    if response.status_code == 201:
        result = response.json()
        print("✅ SUCCESS!")
        print(f"User ID: {result['user']['id']}")
        print(f"Email: {result['user']['email']}")
        print(f"Role: {result['user']['role']}")
    else:
        print(f"❌ ERROR: {response.status_code}")
        print(f"Response: {response.text}")
        
except Exception as e:
    print(f"❌ Exception: {e}")
