import sys
import os
sys.path.insert(0, 'C:\\Wassaliparceldeliveryapp\\backend')
os.chdir('C:\\Wassaliparceldeliveryapp\\backend')

# Simuler l'environnement FastAPI
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

# Test de l'endpoint /auth/register
print("\n=== Test /auth/register ===")
response = client.post(
    "/api/v1/auth/register",
    json={
        "name": "Test User",
        "email": "test999@example.com",
        "phone": "+212600123456",
        "password": "test123456",
        "role": "client"
    }
)

print(f"Status Code: {response.status_code}")
if response.status_code != 201:
    print(f"Error: {response.text}")
else:
    print(f"Success: {response.json()}")

# Test de l'endpoint /auth/register/client
print("\n=== Test /auth/register/client ===")
response = client.post(
    "/api/v1/auth/register/client",
    json={
        "name": "Test Client",
        "email": "testclient999@example.com",
        "phone": "+212600123456",
        "password": "test123456"
    }
)

print(f"Status Code: {response.status_code}")
if response.status_code != 201:
    print(f"Error: {response.text}")
else:
    print(f"Success: {response.json()}")
