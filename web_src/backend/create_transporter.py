import sys
from app.db.database import SessionLocal
from app.models.models import User
from app.core.security import get_password_hash

def create_transporter():
    """Créer un compte transporteur de test"""
    db = SessionLocal()
    
    try:
        # Vérifier si l'email existe déjà
        email = "transporter@test.com"
        existing = db.query(User).filter(User.email == email).first()
        
        if existing:
            print(f"✅ Transporteur existe déjà (ID: {existing.id})")
            print(f"   Email: {existing.email}")
            print(f"   Nom: {existing.name}")
            print(f"   Rôle: {existing.role}")
            print(f"   Mot de passe: Test123!")
            return existing
        
        # Créer un nouveau transporteur
        print(f"\n🚛 Création d'un transporteur avec email: {email}")
        
        user = User(
            email=email,
            phone="+212612345678",
            name="Ahmed Transporteur",
            role="transporter",
            password_hash=get_password_hash("Test123!"),
            is_verified=True,
            address="Casablanca, Maroc"
        )
        
        db.add(user)
        db.commit()
        db.refresh(user)
        
        print(f"✅ Transporteur créé avec succès!")
        print(f"   ID: {user.id}")
        print(f"   Email: {user.email}")
        print(f"   Nom: {user.name}")
        print(f"   Rôle: {user.role}")
        print(f"   Mot de passe: Test123!")
        
        return user
        
    except Exception as e:
        print(f"❌ Erreur: {e}")
        import traceback
        traceback.print_exc()
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    create_transporter()
