"""
Supprime la contrainte UNIQUE sur le téléphone
"""
import sys
sys.path.insert(0, 'C:\\Wassaliparceldeliveryapp\\backend')

from app.db.database import engine
from sqlalchemy import text

print("🔧 Suppression de la contrainte UNIQUE sur phone...")

with engine.begin() as conn:
    # Supprimer l'index unique sur phone
    conn.execute(text("DROP INDEX IF EXISTS ix_users_phone CASCADE"))
    print("✅ Index ix_users_phone supprimé")
    
    # Créer un nouvel index NON-unique
    conn.execute(text("CREATE INDEX IF NOT EXISTS ix_users_phone ON users(phone)"))
    print("✅ Nouvel index NON-unique créé sur phone")

print("\n✅ Migration terminée!")
print("Le numéro de téléphone peut maintenant être utilisé par plusieurs utilisateurs")
