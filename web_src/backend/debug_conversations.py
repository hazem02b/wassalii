from app.db.database import SessionLocal
from app.models.models import Message, User
from sqlalchemy import or_, and_

db = SessionLocal()

# Simuler current_user = hazem (ID 2)
current_user_id = 2
current_user = db.query(User).filter(User.id == current_user_id).first()

print(f"=== Utilisateur actuel: {current_user.name} (ID: {current_user.id}) ===\n")

# Récupérer tous les messages où l'utilisateur est sender ou receiver
messages = db.query(Message).filter(
    or_(
        Message.sender_id == current_user.id,
        Message.receiver_id == current_user.id
    )
).order_by(Message.created_at.desc()).all()

print(f"Total messages: {len(messages)}\n")

# Afficher tous les messages
print("=== Liste des messages (du plus récent au plus ancien) ===")
for i, msg in enumerate(messages):
    sender = db.query(User).filter(User.id == msg.sender_id).first()
    receiver = db.query(User).filter(User.id == msg.receiver_id).first()
    print(f"\nMessage {i+1}:")
    print(f"  conversation_id: {msg.conversation_id}")
    print(f"  sender: {sender.name} (ID: {msg.sender_id})")
    print(f"  receiver: {receiver.name} (ID: {msg.receiver_id})")
    print(f"  content: {msg.content}")
    print(f"  created_at: {msg.created_at}")

# Grouper par conversation_id et récupérer le dernier message de chaque conversation
conversations = {}
for msg in messages:
    if msg.conversation_id not in conversations:
        # Déterminer l'autre utilisateur (pas moi)
        other_user_id = msg.receiver_id if msg.sender_id == current_user.id else msg.sender_id
        other_user = db.query(User).filter(User.id == other_user_id).first()
        
        print(f"\n--- Traitement conversation {msg.conversation_id} ---")
        print(f"  Ce message: sender_id={msg.sender_id}, receiver_id={msg.receiver_id}")
        print(f"  current_user.id = {current_user.id}")
        print(f"  msg.sender_id == current_user.id ? {msg.sender_id == current_user.id}")
        print(f"  → other_user_id = {other_user_id}")
        print(f"  → other_user = {other_user.name if other_user else 'None'}")
        
        # Compter les messages non lus
        unread_count = db.query(Message).filter(
            and_(
                Message.conversation_id == msg.conversation_id,
                Message.receiver_id == current_user.id,
                Message.is_read == False
            )
        ).count()
        
        conversations[msg.conversation_id] = {
            "conversation_id": msg.conversation_id,
            "other_user_id": other_user_id,
            "other_user_name": other_user.name if (other_user and other_user.name) else (other_user.email.split('@')[0] if other_user else "Unknown"),
            "other_user_email": other_user.email if other_user else "",
            "last_message": msg.content,
            "last_message_time": msg.created_at,
            "unread_count": unread_count,
            "is_online": False
        }

print("\n\n=== Résultat final des conversations ===")
for conv_id, conv in conversations.items():
    print(f"\nConversation: {conv_id}")
    print(f"  other_user_id: {conv['other_user_id']}")
    print(f"  other_user_name: {conv['other_user_name']}")
    print(f"  other_user_email: {conv['other_user_email']}")
    print(f"  last_message: {conv['last_message']}")

db.close()
