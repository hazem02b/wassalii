import sys
import os
# Add the backend directory to sys.path
sys.path.append(os.path.join(os.getcwd(), 'web_src', 'backend'))

from app.core.security import get_password_hash, verify_password

password = "password123"
hashed = get_password_hash(password)
print(f"Password: {password}")
print(f"Hash: {hashed}")
print(f"Verify: {verify_password(password, hashed)}")
