"""
Add vehicle_type column to users table
"""
from sqlalchemy import text
from app.db.database import engine

def add_vehicle_type_column():
    """Add vehicle_type column to users table"""
    with engine.connect() as conn:
        # Check if column exists
        result = conn.execute(text("""
            SELECT column_name 
            FROM information_schema.columns 
            WHERE table_name='users' AND column_name='vehicle_type'
        """))
        
        if result.fetchone() is None:
            print("Adding vehicle_type column...")
            conn.execute(text("""
                ALTER TABLE users 
                ADD COLUMN vehicle_type VARCHAR(100)
            """))
            conn.commit()
            print("✅ vehicle_type column added successfully!")
        else:
            print("✅ vehicle_type column already exists!")

if __name__ == "__main__":
    add_vehicle_type_column()
