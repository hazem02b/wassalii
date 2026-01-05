#!/usr/bin/env python3
import sqlite3
import os

db_path = os.path.join('web_src', 'backend', 'wassali_test.db')
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

print("\n" + "="*60)
print("MISE À JOUR DES RÔLES EN MINUSCULES")
print("="*60 + "\n")

# Update all roles to lowercase
cursor.execute("UPDATE users SET role = 'client' WHERE role = 'CLIENT'")
updated_clients = cursor.rowcount
print(f"✓ {updated_clients} clients mis à jour")

cursor.execute("UPDATE users SET role = 'transporter' WHERE role = 'TRANSPORTER'")
updated_transporters = cursor.rowcount
print(f"✓ {updated_transporters} transporteurs mis à jour")

conn.commit()

print("\n" + "="*60)
print("VÉRIFICATION")
print("="*60 + "\n")

cursor.execute("SELECT id, email, name, role FROM users ORDER BY id")
users = cursor.fetchall()

for user in users:
    print(f"ID: {user[0]:2d} | Email: {user[1]:30s} | Role: '{user[3]}'")

print("\n" + "="*60)
print("✅ TERMINÉ!")
print("="*60)

conn.close()
