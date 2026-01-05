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

def create_test_accounts():
    """Create both a client and transporter test account"""
    
    # CLIENT ACCOUNT
    client_email = "client@wassali.com"
    client_password = "ClientTest123!"
    
    user = db.query(User).filter(User.email == client_email).first()
    if user:
        print(f"✓ Client already exists: {client_email}")
        user.password_hash = get_password_hash(client_password)
        user.role = UserRole.CLIENT
        db.commit()
        print(f"  Password reset")
    else:
        print(f"→ Creating client: {client_email}")
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
        print(f"✓ Client created")

    # TRANSPORTER ACCOUNT
    transporter_email = "transporteur@wassali.com"
    transporter_password = "TransportTest123!"
    
    user = db.query(User).filter(User.email == transporter_email).first()
    if user:
        print(f"✓ Transporteur already exists: {transporter_email}")
        user.password_hash = get_password_hash(transporter_password)
        user.role = UserRole.TRANSPORTER
        db.commit()
        print(f"  Password reset")
    else:
        print(f"→ Creating transporteur: {transporter_email}")
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
        print(f"✓ Transporteur created")

    print("\n" + "="*50)
    print("🎉 COMPTES DE TEST CRÉÉS")
    print("="*50)
    print("\n📱 COMPTE CLIENT:")
    print(f"   Email: {client_email}")
    print(f"   Password: {client_password}")
    print(f"   Type: Client")
    
    print("\n🚛 COMPTE TRANSPORTEUR:")
    print(f"   Email: {transporter_email}")
    print(f"   Password: {transporter_password}")
    print(f"   Type: Transporteur")
    print("\n" + "="*50)

if __name__ == "__main__":
    try:
        create_test_accounts()
    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()
