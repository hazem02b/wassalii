import traceback
from app.db.database import SessionLocal
from app.models.models import User
from app.core.security import get_password_hash, create_access_token
from app.schemas.schemas import UserCreate

def test_register_direct():
    """Test direct de l'inscription"""
    print("=" * 60)
    print("TEST D'INSCRIPTION DIRECT")
    print("=" * 60)
    
    db = SessionLocal()
    
    try:
        # Données de test
        user_data = UserCreate(
            email="test@wassali.com",
            password="Test123!",
            first_name="Test",
            last_name="User",
            phone="+33612345678",
            role="client"
        )
        
        print(f"\n1. Vérification email existant...")
        existing = db.query(User).filter(User.email == user_data.email).first()
        if existing:
            print(f"   ❌ Email déjà enregistré (ID: {existing.id})")
            print(f"   Suppression de l'utilisateur...")
            db.delete(existing)
            db.commit()
            print(f"   ✅ Utilisateur supprimé")
        else:
            print(f"   ✅ Email disponible")
        
        print(f"\n2. Création de l'objet User...")
        user = User(
            email=user_data.email,
            phone=user_data.phone,
            first_name=user_data.first_name,
            last_name=user_data.last_name,
            role=user_data.role,
            password_hash=get_password_hash(user_data.password),
        )
        print(f"   ✅ Objet User créé")
        
        print(f"\n3. Ajout à la base de données...")
        db.add(user)
        print(f"   ✅ User ajouté à la session")
        
        print(f"\n4. Commit de la transaction...")
        db.commit()
        print(f"   ✅ Transaction committée")
        
        print(f"\n5. Refresh de l'objet...")
        db.refresh(user)
        print(f"   ✅ User refreshed (ID: {user.id})")
        
        print(f"\n6. Création du token...")
        access_token = create_access_token(data={"sub": user.id})
        print(f"   ✅ Token créé: {access_token[:50]}...")
        
        print(f"\n7. Création de la réponse...")
        response = {
            "access_token": access_token,
            "token_type": "bearer",
            "user": {
                "id": user.id,
                "email": user.email,
                "first_name": user.first_name,
                "last_name": user.last_name,
                "phone": user.phone,
                "role": user.role,
                "avatar_url": user.avatar_url,
                "is_verified": user.is_verified,
                "is_active": user.is_active,
                "rating": user.rating,
                "total_trips": user.total_trips,
                "total_bookings": user.total_bookings,
                "created_at": user.created_at,
            }
        }
        print(f"   ✅ Réponse créée")
        
        print(f"\n{'=' * 60}")
        print(f"✅ SUCCÈS! Utilisateur créé avec succès")
        print(f"{'=' * 60}")
        print(f"ID: {user.id}")
        print(f"Email: {user.email}")
        print(f"Nom: {user.first_name} {user.last_name}")
        print(f"Role: {user.role}")
        print(f"Token: {access_token[:50]}...")
        
        return True
        
    except Exception as e:
        print(f"\n{'=' * 60}")
        print(f"❌ ERREUR DÉTECTÉE")
        print(f"{'=' * 60}")
        print(f"\nType d'erreur: {type(e).__name__}")
        print(f"Message: {str(e)}")
        print(f"\nTraceback complet:")
        print("-" * 60)
        traceback.print_exc()
        print("-" * 60)
        db.rollback()
        return False
        
    finally:
        db.close()

if __name__ == "__main__":
    test_register_direct()
