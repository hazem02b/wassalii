import sys
import os
# Add the backend directory to sys.path
sys.path.append(os.path.join(os.getcwd(), 'web_src', 'backend'))

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models.models import User, UserRole
from app.core.security import get_password_hash

# Setup DB connection
SQLALCHEMY_DATABASE_URL = "sqlite:///./web_src/backend/wassali_test.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

# Ensure tables exist
from app.db.database import Base
Base.metadata.create_all(bind=engine)

def create_test_transporter():
    email = "transporteur@wassali.com"
    password = "Transport2026!"
    
    # Check if user exists
    user = db.query(User).filter(User.email == email).first()
    if user:
        print(f"L'utilisateur existe déjà: {email}")
        # Update password and ensure it's a transporter
        user.password_hash = get_password_hash(password)
        user.role = UserRole.TRANSPORTER
        db.commit()
        print(f"Mot de passe réinitialisé")
    else:
        print(f"Création d'un nouveau transporteur: {email}")
        new_user = User(
            email=email,
            name="Oussema Bellili",
            phone="+216 98 765 432",
            role=UserRole.TRANSPORTER,
            password_hash=get_password_hash(password),
            is_active=True
        )
        db.add(new_user)
        db.commit()
        print(f"Transporteur créé avec succès!")

    print(f"\n{'='*50}")
    print(f"IDENTIFIANTS TRANSPORTEUR")
    print(f"{'='*50}")
    print(f"Email:        {email}")
    print(f"Mot de passe: {password}")
    print(f"Rôle:         Transporteur")
    print(f"{'='*50}\n")

if __name__ == "__main__":
    try:
        create_test_transporter()
    except Exception as e:
        print(f"Erreur: {e}")
        import traceback
        traceback.print_exc()
