import sys
import traceback
from app.db.database import SessionLocal
from app.models.models import User
from app.core.security import get_password_hash

def test_register():
    """Test d'inscription directe"""
    db = SessionLocal()
    
    try:
        # Vérifier si l'email existe déjà
        email = "hazem@transport.ma"
        existing = db.query(User).filter(User.email == email).first()
        
        if existing:
            print(f"❌ Email {email} déjà enregistré (ID: {existing.id})")
            print("Suppression de l'utilisateur existant...")
            db.delete(existing)
            db.commit()
            print("✅ Utilisateur supprimé")
        
        # Créer un nouvel utilisateur
        print(f"\nCréation d'un utilisateur avec email: {email}")
        
        user = User(
            email=email,
            phone="+212612345678",
            first_name="Ahmed",
            last_name="Benali",
            role="transporter",
            password_hash=get_password_hash("Ahmed123!"),
        )
        
        print(f"✅ Objet User créé: {user.email}")
        
        db.add(user)
        print("✅ User ajouté à la session")
        
        db.commit()
        print("✅ Transaction committée")
        
        db.refresh(user)
        print(f"✅ User créé avec succès! ID: {user.id}")
        print(f"   Email: {user.email}")
        print(f"   Nom: {user.first_name} {user.last_name}")
        print(f"   Role: {user.role}")
        
        return user
        
    except Exception as e:
        print(f"\n❌ ERREUR: {str(e)}")
        print("\nTraceback complet:")
        traceback.print_exc()
        db.rollback()
        return None
        
    finally:
        db.close()

if __name__ == "__main__":
    test_register()
