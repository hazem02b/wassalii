#!/usr/bin/env python3
"""
Script pour convertir tous les rôles en majuscules dans la base de données
"""
import sqlite3
import os

# Chemin vers la base de données
db_path = os.path.join('web_src', 'backend', 'wassali_test.db')

print(f"Connexion à la base de données: {db_path}")
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Convertir tous les rôles en majuscules
print("\nConversion des rôles en MAJUSCULES...")

# Update client -> CLIENT
cursor.execute("UPDATE users SET role = 'CLIENT' WHERE LOWER(role) = 'client'")
client_count = cursor.rowcount
print(f"✅ {client_count} utilisateurs CLIENT mis à jour")

# Update transporter -> TRANSPORTER
cursor.execute("UPDATE users SET role = 'TRANSPORTER' WHERE LOWER(role) = 'transporter'")
transporter_count = cursor.rowcount
print(f"✅ {transporter_count} utilisateurs TRANSPORTER mis à jour")

# Update admin -> ADMIN
cursor.execute("UPDATE users SET role = 'ADMIN' WHERE LOWER(role) = 'admin'")
admin_count = cursor.rowcount
print(f"✅ {admin_count} utilisateurs ADMIN mis à jour")

# Commit les changements
conn.commit()

# Vérifier les rôles mis à jour
print("\n📋 Vérification des rôles dans la base de données:")
cursor.execute("SELECT id, email, role FROM users ORDER BY role, email")
for row in cursor.fetchall():
    user_id, email, role = row
    print(f"  - {email}: {role}")

conn.close()
print("\n✅ Conversion terminée avec succès!")
