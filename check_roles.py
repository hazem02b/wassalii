#!/usr/bin/env python3
import sqlite3
import os

db_path = os.path.join('web_src', 'backend', 'wassali_test.db')
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

print("\n" + "="*60)
print("ROLES DANS LA BASE DE DONNÉES")
print("="*60 + "\n")

cursor.execute("SELECT id, email, name, role FROM users ORDER BY id")
users = cursor.fetchall()

for user in users:
    print(f"ID: {user[0]:2d} | Email: {user[1]:30s} | Role: '{user[3]}'")

print("\n" + "="*60)
conn.close()
