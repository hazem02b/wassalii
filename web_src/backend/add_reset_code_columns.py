"""
Script pour ajouter les colonnes reset_code et reset_code_expires à la table users
"""
from sqlalchemy import create_engine, text

DATABASE_URL = "postgresql://postgres:hazem@localhost/wassali_db?client_encoding=utf8"

def add_reset_code_columns():
    """Ajoute les colonnes reset_code et reset_code_expires"""
    try:
        # Créer le moteur de base de données
        engine = create_engine(DATABASE_URL)
        
        print("🔧 Ajout des colonnes reset_code...")
        
        with engine.connect() as conn:
            # Vérifier si les colonnes existent déjà
            result = conn.execute(text("""
                SELECT column_name 
                FROM information_schema.columns 
                WHERE table_name='users' 
                AND column_name IN ('reset_code', 'reset_code_expires')
            """))
            existing_columns = [row[0] for row in result]
            
            # Ajouter reset_code si elle n'existe pas
            if 'reset_code' not in existing_columns:
                conn.execute(text("""
                    ALTER TABLE users 
                    ADD COLUMN reset_code VARCHAR(6)
                """))
                print("✅ Colonne reset_code ajoutée")
            else:
                print("ℹ️  Colonne reset_code existe déjà")
            
            # Ajouter reset_code_expires si elle n'existe pas
            if 'reset_code_expires' not in existing_columns:
                conn.execute(text("""
                    ALTER TABLE users 
                    ADD COLUMN reset_code_expires TIMESTAMP WITH TIME ZONE
                """))
                print("✅ Colonne reset_code_expires ajoutée")
            else:
                print("ℹ️  Colonne reset_code_expires existe déjà")
            
            # Valider les changements
            conn.commit()
            print("\n✅ Migration réussie!")
            
            # Vérifier la structure finale
            result = conn.execute(text("""
                SELECT column_name, data_type, is_nullable
                FROM information_schema.columns
                WHERE table_name = 'users'
                AND column_name IN ('reset_code', 'reset_code_expires')
                ORDER BY column_name
            """))
            
            print("\n📋 Structure des colonnes ajoutées:")
            for row in result:
                print(f"   - {row[0]}: {row[1]} (nullable: {row[2]})")
        
    except Exception as e:
        print(f"❌ Erreur: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    add_reset_code_columns()
