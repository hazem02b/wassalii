import os
import sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app.db.database import SessionLocal
from app.models.models import User

db = SessionLocal()

try:
    # Rechercher l'utilisateur
    email = "hazembellili80@gmail.com"
    users = db.query(User).filter(User.email == email).all()
    
    print(f"\n{'='*80}")
    print(f"Recherche pour: {email}")
    print(f"{'='*80}\n")
    
    if not users:
        print("✅ Aucun utilisateur trouvé avec cet email")
        print("L'inscription devrait fonctionner!")
    else:
        print(f"❌ {len(users)} utilisateur(s) trouvé(s):\n")
        for i, user in enumerate(users, 1):
            print(f"Utilisateur {i}:")
            print(f"  - ID: {user.id}")
            print(f"  - Nom: {user.name}")
            print(f"  - Email: {user.email}")
            print(f"  - Rôle: {user.role}")
            print(f"  - Téléphone: {user.phone}")
            print(f"  - Actif: {user.is_active}")
            print(f"  - Vérifié: {user.is_verified}")
            print("")
        
        # Proposer de supprimer
        print("\n" + "="*80)
        choice = input("Voulez-vous supprimer ces utilisateurs? (oui/non): ")
        if choice.lower() in ['oui', 'o', 'yes', 'y']:
            for user in users:
                db.delete(user)
            db.commit()
            print(f"\n✅ {len(users)} utilisateur(s) supprimé(s)")
            print("Vous pouvez maintenant créer un nouveau compte!")
        else:
            print("\n❌ Aucune suppression effectuée")
    
except Exception as e:
    print(f"\n❌ Erreur: {str(e)}")
    import traceback
    traceback.print_exc()
finally:
    db.close()
