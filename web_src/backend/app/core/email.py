"""
Service d'envoi d'emails
Utilise SMTP pour envoyer des emails transactionnels
"""
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import smtplib
from typing import List, Optional
from app.core.config import settings


class EmailService:
    """Service pour envoyer des emails"""
    
    def __init__(self):
        self.smtp_server = settings.SMTP_SERVER
        self.smtp_port = settings.SMTP_PORT
        self.smtp_username = settings.SMTP_USERNAME
        self.smtp_password = settings.SMTP_PASSWORD
        self.from_email = settings.FROM_EMAIL
        self.from_name = settings.FROM_NAME
    
    def send_email(
        self,
        to_email: str,
        subject: str,
        html_content: str,
        text_content: Optional[str] = None
    ) -> bool:
        """
        Envoyer un email
        
        Args:
            to_email: Email du destinataire
            subject: Sujet de l'email
            html_content: Contenu HTML de l'email
            text_content: Contenu texte alternatif (optionnel)
        
        Returns:
            True si l'email est envoyé avec succès, False sinon
        """
        try:
            # Créer le message
            message = MIMEMultipart('alternative')
            message['Subject'] = subject
            message['From'] = f"{self.from_name} <{self.from_email}>"
            message['To'] = to_email
            
            # Ajouter le contenu texte si fourni
            if text_content:
                part1 = MIMEText(text_content, 'plain')
                message.attach(part1)
            
            # Ajouter le contenu HTML
            part2 = MIMEText(html_content, 'html')
            message.attach(part2)
            
            # Se connecter au serveur SMTP et envoyer
            with smtplib.SMTP(self.smtp_server, self.smtp_port) as server:
                server.starttls()
                server.login(self.smtp_username, self.smtp_password)
                server.send_message(message)
            
            print(f"✅ Email envoyé à {to_email}: {subject}")
            return True
            
        except Exception as e:
            print(f"❌ Erreur envoi email à {to_email}: {str(e)}")
            return False
    
    def send_welcome_email(self, to_email: str, name: str) -> bool:
        """Email de bienvenue pour les nouveaux utilisateurs"""
        subject = "Bienvenue sur Wassali ! 🎉"
        html_content = f"""
        <html>
          <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
            <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
              <h1 style="color: #0066FF;">Bienvenue sur Wassali, {name} ! 🎉</h1>
              <p>Merci de vous être inscrit sur Wassali, votre plateforme de livraison de colis entre la Tunisie et l'Europe.</p>
              
              <div style="background-color: #f5f5f5; padding: 20px; border-radius: 10px; margin: 20px 0;">
                <h2 style="color: #0066FF;">Que pouvez-vous faire maintenant ?</h2>
                <ul>
                  <li>📦 Rechercher des transporteurs pour vos colis</li>
                  <li>🚗 Proposer vos trajets si vous êtes transporteur</li>
                  <li>💬 Communiquer directement avec les transporteurs</li>
                  <li>💳 Payer en toute sécurité</li>
                </ul>
              </div>
              
              <p>Si vous avez des questions, n'hésitez pas à nous contacter à <a href="mailto:support@wassali.com">support@wassali.com</a></p>
              
              <p style="margin-top: 30px;">À bientôt,<br><strong>L'équipe Wassali</strong></p>
            </div>
          </body>
        </html>
        """
        return self.send_email(to_email, subject, html_content)
    
    def send_booking_confirmation(
        self,
        to_email: str,
        name: str,
        booking_id: int,
        from_location: str,
        to_location: str,
        date: str,
        price: float
    ) -> bool:
        """Email de confirmation de réservation"""
        subject = f"Réservation confirmée #{booking_id} ✅"
        html_content = f"""
        <html>
          <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
            <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
              <h1 style="color: #0066FF;">Réservation confirmée ! ✅</h1>
              <p>Bonjour {name},</p>
              <p>Votre réservation a été confirmée avec succès.</p>
              
              <div style="background-color: #f5f5f5; padding: 20px; border-radius: 10px; margin: 20px 0;">
                <h2 style="color: #0066FF;">Détails de votre réservation</h2>
                <p><strong>Numéro de réservation:</strong> #{booking_id}</p>
                <p><strong>Départ:</strong> {from_location}</p>
                <p><strong>Arrivée:</strong> {to_location}</p>
                <p><strong>Date:</strong> {date}</p>
                <p><strong>Prix total:</strong> {price}€</p>
              </div>
              
              <p>Vous recevrez une notification lorsque le transporteur acceptera votre réservation.</p>
              
              <p style="margin-top: 30px;">Bon voyage,<br><strong>L'équipe Wassali</strong></p>
            </div>
          </body>
        </html>
        """
        return self.send_email(to_email, subject, html_content)
    
    def send_booking_accepted(
        self,
        to_email: str,
        name: str,
        booking_id: int,
        transporter_name: str
    ) -> bool:
        """Email quand le transporteur accepte la réservation"""
        subject = f"Réservation #{booking_id} acceptée par le transporteur ! 🎉"
        html_content = f"""
        <html>
          <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
            <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
              <h1 style="color: #0066FF;">Bonne nouvelle ! 🎉</h1>
              <p>Bonjour {name},</p>
              <p><strong>{transporter_name}</strong> a accepté votre réservation #{booking_id}.</p>
              
              <div style="background-color: #e8f5e9; padding: 20px; border-radius: 10px; margin: 20px 0;">
                <h2 style="color: #4caf50;">Prochaines étapes</h2>
                <ol>
                  <li>Vous pouvez contacter le transporteur via la messagerie</li>
                  <li>Préparez votre colis pour l'envoi</li>
                  <li>Le transporteur vous contactera pour finaliser les détails</li>
                </ol>
              </div>
              
              <p>Connectez-vous à votre compte pour plus de détails.</p>
              
              <p style="margin-top: 30px;">Cordialement,<br><strong>L'équipe Wassali</strong></p>
            </div>
          </body>
        </html>
        """
        return self.send_email(to_email, subject, html_content)
    
    def send_password_changed(self, to_email: str, name: str) -> bool:
        """Email de confirmation de changement de mot de passe"""
        subject = "Votre mot de passe a été modifié 🔒"
        html_content = f"""
        <html>
          <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
            <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
              <h1 style="color: #0066FF;">Mot de passe modifié 🔒</h1>
              <p>Bonjour {name},</p>
              <p>Votre mot de passe a été modifié avec succès.</p>
              
              <div style="background-color: #fff3cd; padding: 20px; border-radius: 10px; margin: 20px 0; border-left: 4px solid #ffc107;">
                <p><strong>⚠️ Ce n'était pas vous ?</strong></p>
                <p>Si vous n'avez pas effectué cette modification, contactez-nous immédiatement à <a href="mailto:support@wassali.com">support@wassali.com</a></p>
              </div>
              
              <p style="margin-top: 30px;">Cordialement,<br><strong>L'équipe Wassali</strong></p>
            </div>
          </body>
        </html>
        """
        return self.send_email(to_email, subject, html_content)
    
    def send_new_message_notification(
        self,
        to_email: str,
        name: str,
        sender_name: str,
        message_preview: str
    ) -> bool:
        """Notification de nouveau message"""
        subject = f"Nouveau message de {sender_name} 💬"
        html_content = f"""
        <html>
          <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
            <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
              <h1 style="color: #0066FF;">Nouveau message 💬</h1>
              <p>Bonjour {name},</p>
              <p><strong>{sender_name}</strong> vous a envoyé un message :</p>
              
              <div style="background-color: #f5f5f5; padding: 20px; border-radius: 10px; margin: 20px 0; font-style: italic;">
                "{message_preview}"
              </div>
              
              <p>Connectez-vous pour répondre.</p>
              
              <p style="margin-top: 30px;">Cordialement,<br><strong>L'équipe Wassali</strong></p>
            </div>
          </body>
        </html>
        """
        return self.send_email(to_email, subject, html_content)
    
    def send_password_reset(self, to_email: str, name: str, reset_code: str) -> bool:
        """Email avec code de réinitialisation de mot de passe"""
        subject = "Code de réinitialisation de votre mot de passe 🔑"
        html_content = f"""
        <html>
          <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
            <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
              <h1 style="color: #0066FF;">Réinitialisation de mot de passe 🔑</h1>
              <p>Bonjour {name},</p>
              <p>Vous avez demandé à réinitialiser votre mot de passe.</p>
              
              <div style="background-color: #f5f5f5; padding: 30px; border-radius: 10px; margin: 30px 0; text-align: center;">
                <p style="font-size: 14px; margin-bottom: 10px;">Votre code de réinitialisation :</p>
                <p style="font-size: 32px; font-weight: bold; color: #0066FF; letter-spacing: 5px; margin: 20px 0;">{reset_code}</p>
                <p style="font-size: 12px; color: #666; margin-top: 10px;">Ce code est valide pendant 15 minutes</p>
              </div>
              
              <div style="background-color: #fff3cd; padding: 15px; border-radius: 10px; margin: 20px 0; border-left: 4px solid #ffc107;">
                <p><strong>⚠️ Vous n'avez pas demandé ce code ?</strong></p>
                <p style="margin: 0;">Ignorez cet email. Votre mot de passe reste inchangé.</p>
              </div>
              
              <p style="margin-top: 30px;">Cordialement,<br><strong>L'équipe Wassali</strong></p>
            </div>
          </body>
        </html>
        """
        return self.send_email(to_email, subject, html_content)


# Instance globale du service email
email_service = EmailService()
