"""
Test COMPLET: Déconnexion/Reconnexion pour vérifier la persistance
"""
import requests
import json
from datetime import datetime

BASE_URL = "http://localhost:8000/api/v1"

print("="*70)
print("TEST COMPLET: DÉCONNEXION/RECONNEXION")
print("="*70)

# 1. Créer un utilisateur de test
timestamp = datetime.now().strftime("%H%M%S")
email = f"logout{timestamp}@test.com"
password = "Test123!"

signup_data = {
    "email": email,
    "password": password,
    "name": f"User {timestamp}",
    "role": "client",
    "phone": f"+216{timestamp[:8]}"
}

print("\n1️⃣ INSCRIPTION")
signup_response = requests.post(f"{BASE_URL}/auth/register", json=signup_data)

if signup_response.status_code != 201:
    print(f"❌ Erreur inscription: {signup_response.status_code}")
    print(signup_response.json())
    exit(1)

result = signup_response.json()
first_token = result["access_token"]
print(f"✅ Utilisateur créé: {email}")
print(f"   Nom initial: {result['user']['name']}")
print(f"   Tél initial: {result['user']['phone']}")

# 2. Mettre à jour le profil
new_name = f"UPDATED {timestamp}"
new_phone = f"+216{int(timestamp[:8]) + 20000}"

print(f"\n2️⃣ MISE À JOUR DU PROFIL")
print(f"   Nouveau nom: {new_name}")
print(f"   Nouveau tél: {new_phone}")

update_response = requests.put(
    f"{BASE_URL}/auth/me",
    headers={"Authorization": f"Bearer {first_token}"},
    json={"name": new_name, "phone": new_phone}
)

if update_response.status_code != 200:
    print(f"❌ Erreur mise à jour: {update_response.status_code}")
    print(f"   Response: {update_response.text}")
    exit(1)

updated = update_response.json()
print(f"✅ Mise à jour effectuée")
print(f"   Nom retourné: {updated['name']}")
print(f"   Tél retourné: {updated['phone']}")

# 3. DÉCONNEXION (simulée - on oublie le token)
print(f"\n3️⃣ DÉCONNEXION")
print("   [Simulation: on supprime le token]")
first_token = None  # On "oublie" le token

# 4. RECONNEXION
print(f"\n4️⃣ RECONNEXION")
print(f"   Email: {email}")
print(f"   Password: {password}")

login_response = requests.post(
    f"{BASE_URL}/auth/login",
    data={"username": email, "password": password}
)

if login_response.status_code != 200:
    print(f"❌ Erreur login: {login_response.status_code}")
    print(login_response.json())
    exit(1)

new_token = login_response.json()["access_token"]
print(f"✅ Reconnecté avec succès")

# 5. Récupérer le profil
print(f"\n5️⃣ RÉCUPÉRATION DU PROFIL APRÈS RECONNEXION")

profile_response = requests.get(
    f"{BASE_URL}/auth/me",
    headers={"Authorization": f"Bearer {new_token}"}
)

if profile_response.status_code != 200:
    print(f"❌ Erreur récupération profil: {profile_response.status_code}")
    exit(1)

profile = profile_response.json()
print(f"   Nom en DB: {profile['name']}")
print(f"   Tél en DB: {profile['phone']}")

# 6. VÉRIFICATION FINALE
print(f"\n6️⃣ VÉRIFICATION")
print("="*70)

if profile['name'] == new_name and profile['phone'] == new_phone:
    print("✅ ✅ ✅ SUCCÈS COMPLET!")
    print(f"   Les modifications sont BIEN enregistrées en base de données")
    print(f"   Elles persistent après déconnexion/reconnexion")
else:
    print("❌ ❌ ❌ ÉCHEC!")
    print(f"   Les modifications NE SONT PAS enregistrées en DB")
    print(f"\n   Attendu:")
    print(f"   - Nom: {new_name}")
    print(f"   - Tél: {new_phone}")
    print(f"\n   Obtenu:")
    print(f"   - Nom: {profile['name']}")
    print(f"   - Tél: {profile['phone']}")

print("="*70)
