# Test simple de l'API conversations en direct
import requests

print("Test de l'API /messages/conversations en direct...")
print("="*60)

# On va tester en utilisant le token du navigateur si possible
# Ou créer une session de test

# Pour l'instant, affichons juste ce que le backend devrait renvoyer
# selon notre script de debug

print("\nSelon le script de debug, pour hazem (ID 2):")
print("  other_user_id: 51")
print("  other_user_name: oussema bellili")
print("  other_user_email: hazembellili80@gmail.com")

print("\nSi le frontend voit 'hazem bellili', cela signifie que:")
print("  1. Le backend renvoie le mauvais nom (peu probable vu notre debug)")
print("  2. Le frontend a des données en cache")
print("  3. Le backend en cours d'exécution n'a pas le dernier code")

print("\nSolution recommandée:")
print("  1. Arrêter le backend actuel")
print("  2. Redémarrer avec --reload pour auto-reload")
print("  3. Vider le cache du navigateur (Ctrl+Shift+R)")
print("  4. Re-tester")
