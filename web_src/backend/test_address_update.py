"""
Test de mise à jour avec adresse
"""
import requests
import random

# Configuration
BASE_URL = "http://localhost:8000/api/v1"
timestamp = random.randint(100000, 999999)

# 1. Créer un utilisateur
print("=" * 50)
print("1. CRÉATION D'UN UTILISATEUR DE TEST")
print("=" * 50)

register_data = {
    "email": f"test_address_{timestamp}@test.com",
    "password": "test123456",
    "name": "Test Address User",
    "phone": f"+21629{timestamp}",
    "role": "client"
}

response = requests.post(f"{BASE_URL}/auth/register", json=register_data)
print(f"Status: {response.status_code}")

if response.status_code in [200, 201]:
    user_data = response.json()
    token = user_data.get("access_token")
    user = user_data.get("user")
    print(f"✅ Utilisateur créé: {user['name']} (ID: {user['id']})")
    print(f"   Email: {user['email']}")
    print(f"   Phone: {user['phone']}")
    print(f"   Address: {user.get('address', 'NON DÉFINIE')}")
else:
    print(f"❌ Erreur: {response.text}")
    exit(1)

# 2. Mettre à jour le profil AVEC adresse
print("\n" + "=" * 50)
print("2. MISE À JOUR DU PROFIL AVEC ADRESSE")
print("=" * 50)

update_data = {
    "name": f"UPDATED WITH ADDRESS {timestamp}",
    "phone": f"+21630{timestamp}",
    "address": "123 Avenue de Carthage, Tunis, Tunisie"
}

headers = {"Authorization": f"Bearer {token}"}
response = requests.put(f"{BASE_URL}/auth/me", json=update_data, headers=headers)
print(f"Status: {response.status_code}")

if response.status_code == 200:
    updated_user = response.json()
    print(f"✅ Profil mis à jour:")
    print(f"   Nom: {updated_user['name']}")
    print(f"   Phone: {updated_user['phone']}")
    print(f"   Address: {updated_user.get('address', '❌ NON ENREGISTRÉE')}")
else:
    print(f"❌ Erreur: {response.text}")
    exit(1)

# 3. Déconnexion (simulée)
print("\n" + "=" * 50)
print("3. SIMULATION DÉCONNEXION")
print("=" * 50)
print("🔓 Token effacé (simulation)")
token = None

# 4. Reconnexion
print("\n" + "=" * 50)
print("4. RECONNEXION")
print("=" * 50)

login_data = {
    "username": register_data["email"],  # OAuth2 utilise 'username'
    "password": register_data["password"]
}

response = requests.post(f"{BASE_URL}/auth/login", data=login_data)  # data au lieu de json pour OAuth2
print(f"Status: {response.status_code}")

if response.status_code == 200:
    login_response = response.json()
    token = login_response.get("access_token")
    print("✅ Reconnexion réussie")
else:
    print(f"❌ Erreur: {response.text}")
    exit(1)

# 5. Vérification finale
print("\n" + "=" * 50)
print("5. VÉRIFICATION - RÉCUPÉRATION DU PROFIL")
print("=" * 50)

headers = {"Authorization": f"Bearer {token}"}
response = requests.get(f"{BASE_URL}/auth/me", headers=headers)
print(f"Status: {response.status_code}")

if response.status_code == 200:
    final_user = response.json()
    print(f"✅ Profil récupéré:")
    print(f"   Nom: {final_user['name']}")
    print(f"   Phone: {final_user['phone']}")
    print(f"   Address: {final_user.get('address', '❌ NON TROUVÉE')}")
    
    # Vérification finale
    print("\n" + "=" * 50)
    if final_user.get('address') == update_data['address']:
        print("✅ ✅ ✅ SUCCÈS COMPLET!")
        print(f"L'adresse a été correctement enregistrée et persistée:")
        print(f"   📍 {final_user['address']}")
    else:
        print("❌ ❌ ❌ ÉCHEC!")
        print(f"Adresse attendue: {update_data['address']}")
        print(f"Adresse reçue: {final_user.get('address', 'None')}")
    print("=" * 50)
else:
    print(f"❌ Erreur: {response.text}")
