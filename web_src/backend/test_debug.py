import sys
import traceback
sys.path.insert(0, 'C:\\Wassaliparceldeliveryapp\\backend')

try:
    from app.api.v1.endpoints.auth import router
    print("✅ Import du router auth réussi")
    
    from app.schemas.schemas import UserCreate, UserCreateSimple
    print("✅ Import des schémas réussi")
    
    from app.models.models import UserRole
    print("✅ Import de UserRole réussi")
    
    # Essayer de créer une instance de UserCreate
    user_data = UserCreate(
        email="test@example.com",
        name="Test User",
        phone="+212600123456",
        password="test123456",
        role=UserRole.CLIENT,
        address=None
    )
    print(f"✅ UserCreate créé: {user_data}")
    
    # Essayer de créer une instance de UserCreateSimple
    user_data_simple = UserCreateSimple(
        email="test@example.com",
        name="Test User",
        phone="+212600123456",
        password="test123456",
        address=None
    )
    print(f"✅ UserCreateSimple créé: {user_data_simple}")
    
except Exception as e:
    print(f"❌ ERREUR: {e}")
    traceback.print_exc()
