"""
Script pour ajouter la colonne address à la table users
"""
import psycopg2
from app.core.config import settings

def add_address_column():
    """Ajoute la colonne address si elle n'existe pas"""
    try:
        # Connexion à PostgreSQL
        conn = psycopg2.connect(
            host=settings.DATABASE_HOST,
            database=settings.DATABASE_NAME,
            user=settings.DATABASE_USER,
            password=settings.DATABASE_PASSWORD,
            port=settings.DATABASE_PORT
        )
        cursor = conn.cursor()
        
        # Vérifier si la colonne existe déjà
        cursor.execute("""
            SELECT column_name 
            FROM information_schema.columns 
            WHERE table_name='users' AND column_name='address';
        """)
        
        if cursor.fetchone():
            print("✅ La colonne 'address' existe déjà")
        else:
            # Ajouter la colonne
            cursor.execute("""
                ALTER TABLE users 
                ADD COLUMN address VARCHAR(500);
            """)
            conn.commit()
            print("✅ Colonne 'address' ajoutée avec succès")
        
        cursor.close()
        conn.close()
        
    except Exception as e:
        print(f"❌ Erreur: {e}")
        raise

if __name__ == "__main__":
    print("🔄 Ajout de la colonne 'address' à la table users...")
    add_address_column()
    print("✅ Migration terminée")
