"""
Test si la mise à jour persiste en base de données
"""
import requests
import json
from datetime import datetime

BASE_URL = "http://localhost:8000/api/v1"

# Créer un utilisateur de test
timestamp = datetime.now().strftime("%H%M%S")
signup_data = {
    "email": f"dbtest{timestamp}@test.com",
    "password": "Test123!",
    "name": "Original Name",
    "role": "client",
    "phone": f"+216{timestamp[:8]}"
}

print("="*60)
print("TEST DE PERSISTANCE EN BASE DE DONNÉES")
print("="*60)

# 1. Créer l'utilisateur
print("\n1️⃣ Création de l'utilisateur...")
signup_response = requests.post(f"{BASE_URL}/auth/register", json=signup_data)

if signup_response.status_code == 201:
    result = signup_response.json()
    token = result["access_token"]
    user_id = result["user"]["id"]
    
    print(f"✅ Utilisateur créé - ID: {user_id}")
    print(f"   Nom original: {result['user']['name']}")
    print(f"   Téléphone original: {result['user']['phone']}")
    
    # 2. Mettre à jour le profil
    print("\n2️⃣ Mise à jour du profil...")
    new_name = f"Updated Name {timestamp}"
    new_phone = f"+216{int(timestamp[:8]) + 10000}"  # Téléphone unique
    
    update_response = requests.put(
        f"{BASE_URL}/auth/me",
        headers={"Authorization": f"Bearer {token}"},
        json={"name": new_name, "phone": new_phone}
    )
    
    if update_response.status_code == 200:
        updated = update_response.json()
        print(f"✅ Mise à jour effectuée")
        print(f"   Nouveau nom: {updated['name']}")
        print(f"   Nouveau tél: {updated['phone']}")
        
        # 3. Re-login et vérifier
        print("\n3️⃣ Vérification après re-login...")
        print("   (Pour s'assurer que c'est bien en DB, pas juste en cache)")
        
        login_response = requests.post(
            f"{BASE_URL}/auth/login",
            data={"username": signup_data["email"], "password": signup_data["password"]}
        )
        
        if login_response.status_code == 200:
            new_token = login_response.json()["access_token"]
            
            profile_response = requests.get(
                f"{BASE_URL}/auth/me",
                headers={"Authorization": f"Bearer {new_token}"}
            )
            
            if profile_response.status_code == 200:
                profile = profile_response.json()
                print(f"✅ Profil récupéré après re-login")
                print(f"   Nom en DB: {profile['name']}")
                print(f"   Tél en DB: {profile['phone']}")
                
                # Vérification
                if profile['name'] == new_name and profile['phone'] == new_phone:
                    print("\n✅ ✅ ✅ SUCCÈS - Les données sont bien persistées en DB!")
                else:
                    print("\n❌ ❌ ❌ ÉCHEC - Les données ne sont PAS persistées!")
                    print(f"   Attendu: {new_name} / {new_phone}")
                    print(f"   Obtenu: {profile['name']} / {profile['phone']}")
            else:
                print(f"❌ Erreur récupération profil: {profile_response.status_code}")
        else:
            print(f"❌ Erreur re-login: {login_response.status_code}")
    else:
        print(f"❌ Erreur mise à jour: {update_response.status_code}")
        print(f"   Response text: {update_response.text}")
        try:
            print(f"   Response JSON: {update_response.json()}")
        except:
            pass
else:
    print(f"❌ Erreur création: {signup_response.status_code}")

print("\n" + "="*60)
