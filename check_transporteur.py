#!/usr/bin/env python3
import sqlite3
import os

# Chemin vers la base de données
db_path = os.path.join('web_src', 'backend', 'wassali_test.db')

if not os.path.exists(db_path):
    print(f"❌ Base de données introuvable: {db_path}")
    exit(1)

# Connexion
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

print("\n" + "="*60)
print("VÉRIFICATION DU COMPTE TRANSPORTEUR")
print("="*60 + "\n")

# Récupérer le transporteur
cursor.execute("""
    SELECT id, email, name, role, is_active, created_at, password_hash
    FROM users 
    WHERE email = 'transporteur@wassali.com'
""")

user = cursor.fetchone()

if user:
    print("✅ TRANSPORTEUR TROUVÉ:\n")
    print(f"  ID:           {user[0]}")
    print(f"  Email:        {user[1]}")
    print(f"  Nom:          {user[2]}")
    print(f"  Rôle:         {user[3]}")
    print(f"  Actif:        {user[4]}")
    print(f"  Créé le:      {user[5]}")
    print(f"  Hash (début): {user[6][:50]}...")
    print(f"\n  Mot de passe attendu: transporteur123")
else:
    print("❌ TRANSPORTEUR INTROUVABLE!")

print("\n" + "="*60)

# Vérifier aussi le client pour comparaison
cursor.execute("""
    SELECT id, email, name, role, is_active 
    FROM users 
    WHERE email = 'client@wassali.com'
""")

client = cursor.fetchone()
if client:
    print("\n✅ CLIENT (pour comparaison):")
    print(f"  ID:    {client[0]}")
    print(f"  Email: {client[1]}")
    print(f"  Nom:   {client[2]}")
    print(f"  Rôle:  {client[3]}")
    print(f"  Actif: {client[4]}")

print("\n" + "="*60)

conn.close()
