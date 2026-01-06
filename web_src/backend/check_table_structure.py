"""
Vérifier la structure de la table users
"""
import psycopg2
from app.core.config import settings

try:
    conn = psycopg2.connect(
        host=settings.DATABASE_HOST,
        database=settings.DATABASE_NAME,
        user=settings.DATABASE_USER,
        password=settings.DATABASE_PASSWORD,
        port=settings.DATABASE_PORT
    )
    cursor = conn.cursor()
    
    # Récupérer toutes les colonnes de la table users
    cursor.execute("""
        SELECT column_name, data_type, character_maximum_length, is_nullable
        FROM information_schema.columns 
        WHERE table_name='users'
        ORDER BY ordinal_position;
    """)
    
    print("=" * 70)
    print("STRUCTURE DE LA TABLE 'users'")
    print("=" * 70)
    print(f"{'Colonne':<20} {'Type':<20} {'Taille':<10} {'NULL?':<10}")
    print("-" * 70)
    
    for row in cursor.fetchall():
        col_name, data_type, max_length, nullable = row
        length_str = str(max_length) if max_length else "-"
        print(f"{col_name:<20} {data_type:<20} {length_str:<10} {nullable:<10}")
    
    # Vérifier spécifiquement la colonne address
    cursor.execute("""
        SELECT column_name 
        FROM information_schema.columns 
        WHERE table_name='users' AND column_name='address';
    """)
    
    if cursor.fetchone():
        print("\n" + "=" * 70)
        print("✅ La colonne 'address' existe dans la table")
        print("=" * 70)
    else:
        print("\n" + "=" * 70)
        print("❌ La colonne 'address' N'EXISTE PAS dans la table!")
        print("=" * 70)
    
    cursor.close()
    conn.close()
    
except Exception as e:
    print(f"❌ Erreur: {e}")
