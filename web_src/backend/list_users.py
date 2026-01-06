# Script pour lister tous les utilisateurs
from app.db.database import SessionLocal
from app.models.models import User

def list_all_users():
    """Lister tous les utilisateurs"""
    db = SessionLocal()
    try:
        users = db.query(User).all()
        
        print("=" * 80)
        print(f"LISTE DES UTILISATEURS ({len(users)} total)")
        print("=" * 80)
        
        if not users:
            print("❌ Aucun utilisateur dans la base de données")
        else:
            for user in users:
                print(f"\nID: {user.id}")
                print(f"  📧 Email: {user.email}")
                print(f"  👤 Nom: {user.first_name} {user.last_name}")
                print(f"  📱 Téléphone: {user.phone}")
                print(f"  🎭 Rôle: {user.role}")
                print(f"  ⭐ Rating: {user.rating}")
                print(f"  ✅ Actif: {user.is_active}")
                print(f"  📅 Créé: {user.created_at}")
                print("-" * 80)
                
    except Exception as e:
        print(f"❌ Erreur: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    list_all_users()
