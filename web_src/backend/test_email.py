"""
Script de test pour le système d'emails
"""
import sys
sys.path.append('.')

from app.core.email import email_service

def test_emails():
    """Tester tous les types d'emails"""
    
    # Email de test - REMPLACEZ PAR VOTRE EMAIL
    test_email = "votre.email@gmail.com"
    
    print("🧪 Test du système d'emails Wassali\n")
    
    # 1. Email de bienvenue
    print("1️⃣ Test email de bienvenue...")
    success = email_service.send_welcome_email(
        to_email=test_email,
        name="Test User"
    )
    print(f"   {'✅ Réussi' if success else '❌ Échec'}\n")
    
    # 2. Email de confirmation réservation
    print("2️⃣ Test email confirmation réservation...")
    success = email_service.send_booking_confirmation(
        to_email=test_email,
        name="Test User",
        booking_id=12345,
        from_location="Paris, France",
        to_location="Tunis, Tunisie",
        date="25 Décembre 2025",
        price=150.00
    )
    print(f"   {'✅ Réussi' if success else '❌ Échec'}\n")
    
    # 3. Email réservation acceptée
    print("3️⃣ Test email réservation acceptée...")
    success = email_service.send_booking_accepted(
        to_email=test_email,
        name="Test User",
        booking_id=12345,
        transporter_name="Mohamed Ali"
    )
    print(f"   {'✅ Réussi' if success else '❌ Échec'}\n")
    
    # 4. Email changement mot de passe
    print("4️⃣ Test email changement mot de passe...")
    success = email_service.send_password_changed(
        to_email=test_email,
        name="Test User"
    )
    print(f"   {'✅ Réussi' if success else '❌ Échec'}\n")
    
    # 5. Email nouveau message
    print("5️⃣ Test email nouveau message...")
    success = email_service.send_new_message_notification(
        to_email=test_email,
        name="Test User",
        sender_name="Sarah Martin",
        message_preview="Bonjour, j'ai une question concernant votre trajet..."
    )
    print(f"   {'✅ Réussi' if success else '❌ Échec'}\n")
    
    print("\n" + "="*50)
    print("✅ Tests terminés!")
    print("📧 Vérifiez votre boîte email:", test_email)
    print("="*50)


if __name__ == "__main__":
    print("\n⚠️  ATTENTION: Configurez d'abord les variables SMTP dans .env")
    print("Voir EMAIL_NOTIFICATIONS_GUIDE.md pour les instructions\n")
    
    response = input("Continuer les tests ? (o/n): ")
    if response.lower() == 'o':
        test_emails()
    else:
        print("Tests annulés")
