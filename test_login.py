#!/usr/bin/env python3
import requests
import json

base_url = "http://localhost:8000/api/v1"

print("\n" + "="*60)
print("TEST DE CONNEXION DES COMPTES")
print("="*60 + "\n")

# Test CLIENT
print("🧪 Test CLIENT...")
client_data = {
    "email": "client@wassali.com",
    "password": "client123",
    "role": "client"
}

try:
    response = requests.post(f"{base_url}/auth/login", json=client_data)
    print(f"   Status: {response.status_code}")
    if response.status_code == 200:
        print("   ✅ CLIENT - Connexion réussie!")
        data = response.json()
        print(f"   Token: {data.get('access_token', 'N/A')[:50]}...")
    else:
        print(f"   ❌ CLIENT - Échec: {response.text}")
except Exception as e:
    print(f"   ❌ Erreur: {e}")

print()

# Test TRANSPORTEUR
print("🧪 Test TRANSPORTEUR...")
transporter_data = {
    "email": "transporteur@wassali.com",
    "password": "transporteur123",
    "role": "transporter"
}

try:
    response = requests.post(f"{base_url}/auth/login", json=transporter_data)
    print(f"   Status: {response.status_code}")
    if response.status_code == 200:
        print("   ✅ TRANSPORTEUR - Connexion réussie!")
        data = response.json()
        print(f"   Token: {data.get('access_token', 'N/A')[:50]}...")
    else:
        print(f"   ❌ TRANSPORTEUR - Échec:")
        try:
            error_data = response.json()
            print(f"   Détails: {json.dumps(error_data, indent=2)}")
        except:
            print(f"   Réponse: {response.text}")
except Exception as e:
    print(f"   ❌ Erreur: {e}")

print("\n" + "="*60)
