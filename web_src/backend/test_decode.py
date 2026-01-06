"""
Test du décodage avec la vraie clé
"""
import sys
sys.path.insert(0, r"c:\Wassaliparceldeliveryapp\backend")

from app.core.security import decode_access_token, create_access_token

# Test 1: Créer un token
print("1️⃣ Création d'un token...")
token = create_access_token(data={"sub": 999})
print(f"Token créé: {token[:50]}...")

# Test 2: Décoder le token
print("\n2️⃣ Décodage du token...")
payload = decode_access_token(token)
print(f"Payload: {payload}")

if payload:
    print(f"✅ Token décodé avec succès!")
    print(f"User ID: {payload.get('sub')}")
else:
    print("❌ Échec du décodage")

# Test 3: Décoder un vrai token de production
print("\n3️⃣ Test avec un token réel...")
real_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjUsImV4cCI6MTc2NjYwMTY2M30.prnem3t4_mno2hyyXlcE7mFNxNo2L8ar2WJ5HE6Oxzg"
real_payload = decode_access_token(real_token)
print(f"Payload: {real_payload}")

if real_payload:
    print("✅ Token réel décodé!")
else:
    print("❌ Échec du décodage du token réel")
