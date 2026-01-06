"""
Test de mise à jour d'adresse avec un utilisateur existant
"""
import requests

# Configuration
BASE_URL = "http://localhost:8000/api/v1"

# Demander les identifiants
print("=" * 60)
print("TEST DE MISE À JOUR D'ADRESSE - UTILISATEUR EXISTANT")
print("=" * 60)
print("\nEntrez vos identifiants:")
email = input("Email: ").strip()
password = input("Password: ").strip()

# 1. Connexion
print("\n" + "=" * 60)
print("1. CONNEXION")
print("=" * 60)

login_data = {
    "username": email,
    "password": password
}

response = requests.post(f"{BASE_URL}/auth/login", data=login_data)
print(f"Status: {response.status_code}")

if response.status_code == 200:
    login_response = response.json()
    token = login_response.get("access_token")
    user = login_response.get("user")
    print(f"✅ Connecté: {user['name']}")
    print(f"   Email: {user['email']}")
    print(f"   Phone: {user.get('phone', 'Non défini')}")
    print(f"   Adresse actuelle: {user.get('address', '❌ NON DÉFINIE')}")
else:
    print(f"❌ Erreur de connexion: {response.text}")
    exit(1)

# 2. Demander la nouvelle adresse
print("\n" + "=" * 60)
print("2. MISE À JOUR DE L'ADRESSE")
print("=" * 60)
new_address = input("\nEntrez la nouvelle adresse: ").strip()

update_data = {
    "name": user['name'],  # Garder le même nom
    "phone": user.get('phone'),  # Garder le même téléphone
    "address": new_address
}

headers = {"Authorization": f"Bearer {token}"}
response = requests.put(f"{BASE_URL}/auth/me", json=update_data, headers=headers)
print(f"\nStatus: {response.status_code}")

if response.status_code == 200:
    updated_user = response.json()
    print(f"✅ Profil mis à jour:")
    print(f"   Nom: {updated_user['name']}")
    print(f"   Phone: {updated_user.get('phone', 'Non défini')}")
    print(f"   Adresse: {updated_user.get('address', '❌ NON ENREGISTRÉE')}")
else:
    print(f"❌ Erreur: {response.text}")
    exit(1)

# 3. Vérification immédiate
print("\n" + "=" * 60)
print("3. VÉRIFICATION IMMÉDIATE")
print("=" * 60)

response = requests.get(f"{BASE_URL}/auth/me", headers=headers)
print(f"Status: {response.status_code}")

if response.status_code == 200:
    verified_user = response.json()
    print(f"✅ Profil récupéré:")
    print(f"   Adresse: {verified_user.get('address', '❌ NON TROUVÉE')}")
    
    if verified_user.get('address') == new_address:
        print("\n" + "=" * 60)
        print("✅ ✅ ✅ SUCCÈS!")
        print(f"L'adresse a été enregistrée: {verified_user['address']}")
        print("=" * 60)
    else:
        print("\n" + "=" * 60)
        print("❌ ❌ ❌ ÉCHEC!")
        print(f"Adresse attendue: {new_address}")
        print(f"Adresse reçue: {verified_user.get('address', 'None')}")
        print("=" * 60)
else:
    print(f"❌ Erreur: {response.text}")
