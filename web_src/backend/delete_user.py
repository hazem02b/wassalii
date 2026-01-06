# Script pour supprimer un utilisateur par email
from app.db.database import SessionLocal
from app.models.models import User

def delete_user_by_email(email: str):
    """Supprimer un utilisateur par email"""
    db = SessionLocal()
    try:
        user = db.query(User).filter(User.email == email).first()
        if user:
            print(f"✅ Utilisateur trouvé:")
            print(f"   ID: {user.id}")
            print(f"   Email: {user.email}")
            print(f"   Nom: {user.first_name} {user.last_name}")
            print(f"   Role: {user.role}")
            
            db.delete(user)
            db.commit()
            print(f"\n✅ Utilisateur supprimé avec succès!")
        else:
            print(f"❌ Aucun utilisateur trouvé avec l'email: {email}")
    except Exception as e:
        print(f"❌ Erreur: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    # Changez l'email ici
    email_a_supprimer = "karim@transport.tn"
    
    print("=" * 60)
    print(f"Suppression de l'utilisateur: {email_a_supprimer}")
    print("=" * 60)
    
    delete_user_by_email(email_a_supprimer)
