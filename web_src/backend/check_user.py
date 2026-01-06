import sys
sys.path.insert(0, 'C:\\Wassaliparceldeliveryapp\\backend')

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models.models import User

# Database connection
DATABASE_URL = "postgresql://wassali_user:wassali2024@localhost/wassali_db"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)
db = SessionLocal()

# Rechercher l'utilisateur
email = "hazembellili80@gmail.com"
users = db.query(User).filter(User.email == email).all()

print(f"\nUtilisateurs trouvés avec l'email '{email}':")
print("=" * 80)

if not users:
    print("Aucun utilisateur trouvé")
else:
    for user in users:
        print(f"ID: {user.id}")
        print(f"Nom: {user.name}")
        print(f"Email: {user.email}")
        print(f"Rôle: {user.role}")
        print(f"Téléphone: {user.phone}")
        print(f"Actif: {user.is_active}")
        print("-" * 80)

db.close()
