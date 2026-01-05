import sys
import os
sys.path.append(os.path.join(os.getcwd(), 'web_src', 'backend'))

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models.models import User, UserRole
from app.core.security import get_password_hash

SQLALCHEMY_DATABASE_URL = "sqlite:///./web_src/backend/wassali_test.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

from app.db.database import Base
Base.metadata.create_all(bind=engine)

def reset_passwords():
    print("="*60)
    print("RÉINITIALISATION DES MOTS DE PASSE")
    print("="*60)
    
    # CLIENT
    client_email = "client@wassali.com"
    client_password = "client123"
    
    user = db.query(User).filter(User.email == client_email).first()
    if user:
        user.password_hash = get_password_hash(client_password)
        user.role = UserRole.CLIENT
        db.commit()
        print(f"\n✓ CLIENT mis à jour:")
        print(f"  Email: {client_email}")
        print(f"  Password: {client_password}")
    else:
        new_user = User(
            email=client_email,
            name="Client Test",
            phone="0600000001",
            role=UserRole.CLIENT,
            password_hash=get_password_hash(client_password),
            is_active=True
        )
        db.add(new_user)
        db.commit()
        print(f"\n✓ CLIENT créé:")
        print(f"  Email: {client_email}")
        print(f"  Password: {client_password}")
    
    # TRANSPORTEUR
    transporter_email = "transporteur@wassali.com"
    transporter_password = "transporteur123"
    
    user = db.query(User).filter(User.email == transporter_email).first()
    if user:
        user.password_hash = get_password_hash(transporter_password)
        user.role = UserRole.TRANSPORTER
        db.commit()
        print(f"\n✓ TRANSPORTEUR mis à jour:")
        print(f"  Email: {transporter_email}")
        print(f"  Password: {transporter_password}")
    else:
        new_user = User(
            email=transporter_email,
            name="Transporteur Test",
            phone="0600000002",
            role=UserRole.TRANSPORTER,
            password_hash=get_password_hash(transporter_password),
            is_active=True
        )
        db.add(new_user)
        db.commit()
        print(f"\n✓ TRANSPORTEUR créé:")
        print(f"  Email: {transporter_email}")
        print(f"  Password: {transporter_password}")
    
    print("\n" + "="*60)
    print("✅ COMPTES PRÊTS!")
    print("="*60)
    print("\n📱 CLIENT:")
    print(f"   Email:    client@wassali.com")
    print(f"   Password: client123")
    
    print("\n🚛 TRANSPORTEUR:")
    print(f"   Email:    transporteur@wassali.com")
    print(f"   Password: transporteur123")
    print("\n" + "="*60)

if __name__ == "__main__":
    try:
        reset_passwords()
    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()
