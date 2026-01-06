"""
Test complet: Adresse + Upload Photo
"""
import requests

BASE_URL = "http://localhost:8000/api/v1"

print("=" * 70)
print("TEST: ADRESSE ET UPLOAD PHOTO")
print("=" * 70)

email = input("\nEmail: ").strip()
password = input("Password: ").strip()

# 1. Login
print("\n1. CONNEXION...")
response = requests.post(f"{BASE_URL}/auth/login", data={
    "username": email,
    "password": password
})

if response.status_code != 200:
    print(f"❌ Erreur de connexion: {response.text}")
    exit(1)

data = response.json()
token = data['access_token']
user = data['user']

print(f"✅ Connecté: {user['name']}")
print(f"   Adresse actuelle: {user.get('address', 'Non définie')}")

# 2. Mettre à jour l'adresse
print("\n2. MISE À JOUR DE L'ADRESSE...")
new_address = input("Nouvelle adresse: ").strip() or "123 Test Street, Tunis"

headers = {"Authorization": f"Bearer {token}"}
response = requests.put(f"{BASE_URL}/auth/me", 
    json={
        "name": user['name'],
        "phone": user.get('phone'),
        "address": new_address
    },
    headers=headers
)

if response.status_code == 200:
    updated = response.json()
    print(f"✅ Adresse mise à jour: {updated.get('address')}")
else:
    print(f"❌ Erreur: {response.text}")

# 3. Vérification
print("\n3. VÉRIFICATION...")
response = requests.get(f"{BASE_URL}/auth/me", headers=headers)

if response.status_code == 200:
    final = response.json()
    if final.get('address') == new_address:
        print("✅ ✅ ✅ L'ADRESSE EST BIEN ENREGISTRÉE!")
        print(f"   📍 {final['address']}")
    else:
        print("❌ Problème de persistence")
else:
    print(f"❌ Erreur: {response.text}")

print("\n" + "=" * 70)
print("INSTRUCTIONS POUR TESTER DANS L'APP:")
print("=" * 70)
print("1. Ouvrez http://localhost:5173")
print("2. Connectez-vous")
print("3. Allez dans Profile → Edit Profile")
print("4. TESTEZ:")
print("   ✓ Cliquez sur l'icône photo pour changer l'image")
print("   ✓ Modifiez l'adresse")
print("   ✓ Sauvegardez")
print("5. Retournez au profil → L'adresse doit s'afficher")
print("6. Allez dans Settings → Activez Dark Mode")
print("7. Vérifiez que le thème change et persiste")
print("=" * 70)
