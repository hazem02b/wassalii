import sys
import os
# Add the backend directory to sys.path
sys.path.append(os.path.join(os.getcwd(), 'web_src', 'backend'))

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models.models import User, UserRole
from app.core.security import get_password_hash

# Setup DB connection
# Use the same DB path as the .env file (relative to backend dir)
SQLALCHEMY_DATABASE_URL = "sqlite:///./web_src/backend/wassali_test.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

# Ensure tables exist
from app.db.database import Base
Base.metadata.create_all(bind=engine)

def create_test_user():
    email = "test@wassali.com"
    password = "password123"
    
    # Check if user exists
    user = db.query(User).filter(User.email == email).first()
    if user:
        print(f"User already exists: {email}")
        # Update password just in case
        user.password_hash = get_password_hash(password)
        user.role = UserRole.CLIENT # Ensure role is correct
        db.commit()
        print(f"Password reset to: {password}")
    else:
        print(f"Creating new user: {email}")
        new_user = User(
            email=email,
            name="Test User",
            phone="12345678",
            role=UserRole.CLIENT,
            password_hash=get_password_hash(password),
            is_active=True
        )
        db.add(new_user)
        db.commit()
        print(f"User created successfully.")

    print(f"\n=== CREDENTIALS ===")
    print(f"Email: {email}")
    print(f"Password: {password}")
    print(f"Role: client")

if __name__ == "__main__":
    try:
        create_test_user()
    except Exception as e:
        print(f"Error: {e}")
