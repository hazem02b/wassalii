import sys
sys.path.insert(0, 'C:\\Wassaliparceldeliveryapp\\backend')

from app.db.database import engine
from sqlalchemy import inspect, text

# Vérifier les contraintes sur la table users
inspector = inspect(engine)

print("\n=== Contraintes sur la table 'users' ===")
constraints = inspector.get_unique_constraints('users')
for constraint in constraints:
    print(f"\nContrainte UNIQUE: {constraint['name']}")
    print(f"  Colonnes: {constraint['column_names']}")

# Vérifier les index
print("\n=== Index sur la table 'users' ===")
indexes = inspector.get_indexes('users')
for index in indexes:
    print(f"\nIndex: {index['name']}")
    print(f"  Colonnes: {index['column_names']}")
    print(f"  Unique: {index['unique']}")
