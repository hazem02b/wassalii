"""
Migration script to separate client and transporter accounts
Allows same email to have both client and transporter accounts
"""
import sys
from sqlalchemy import text
from app.db.database import engine, SessionLocal

def migrate():
    """Run migration to separate accounts by role"""
    print("🔄 Starting migration to separate client/transporter accounts...")
    
    db = SessionLocal()
    try:
        # 1. Remove the unique constraint on email
        print("📝 Step 1: Removing unique constraint on email...")
        try:
            db.execute(text("ALTER TABLE users DROP CONSTRAINT IF EXISTS users_email_key"))
            db.commit()
            print("✅ Unique constraint on email removed")
        except Exception as e:
            print(f"⚠️  Warning: {e}")
            db.rollback()
        
        # 2. Remove unique constraint on phone
        print("📝 Step 2: Removing unique constraint on phone...")
        try:
            db.execute(text("ALTER TABLE users DROP CONSTRAINT IF EXISTS users_phone_key"))
            db.commit()
            print("✅ Unique constraint on phone removed")
        except Exception as e:
            print(f"⚠️  Warning: {e}")
            db.rollback()
        
        # 3. Add unique constraint on (email, role)
        print("📝 Step 3: Adding unique constraint on (email, role)...")
        try:
            db.execute(text(
                "ALTER TABLE users ADD CONSTRAINT uq_email_role UNIQUE (email, role)"
            ))
            db.commit()
            print("✅ Unique constraint on (email, role) added")
        except Exception as e:
            print(f"⚠️  Constraint may already exist: {e}")
            db.rollback()
        
        # 4. Create index for better performance
        print("📝 Step 4: Creating index on (email, role)...")
        try:
            db.execute(text(
                "CREATE INDEX IF NOT EXISTS idx_email_role ON users (email, role)"
            ))
            db.commit()
            print("✅ Index on (email, role) created")
        except Exception as e:
            print(f"⚠️  Warning: {e}")
            db.rollback()
        
        print("\n✅ Migration completed successfully!")
        print("ℹ️  Now users can have separate client and transporter accounts with the same email")
        
    except Exception as e:
        print(f"\n❌ Migration failed: {e}")
        db.rollback()
        sys.exit(1)
    finally:
        db.close()

if __name__ == "__main__":
    migrate()
