"""
Script pour recréer les tables de la base de données avec la nouvelle structure
"""
from app.db.database import engine, Base
from app.models.models import User, Trip, Booking  # Import all models

print("🗑️  Suppression des anciennes tables...")
Base.metadata.drop_all(bind=engine)
print("✅ Tables supprimées")

print("📦 Création des nouvelles tables...")
Base.metadata.create_all(bind=engine)
print("✅ Tables créées avec succès!")
print("✨ Base de données prête!")
