import sys
import os
# Add the backend directory to sys.path
sys.path.append(os.path.join(os.getcwd(), 'web_src', 'backend'))

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models.models import User, UserRole
from app.core.security import verify_password

# Setup DB connection
SQLALCHEMY_DATABASE_URL = "sqlite:///./web_src/backend/wassali_test.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

def debug_user():
    email = "test@wassali.com"
    password = "password123"
    
    user = db.query(User).filter(User.email == email).first()
    if user:
        print(f"User found: {user.email}")
        print(f"Role in DB: {user.role}")
        print(f"Hash in DB: {user.password_hash}")
        print(f"Verify password: {verify_password(password, user.password_hash)}")
    else:
        print("User not found")

if __name__ == "__main__":
    debug_user()
