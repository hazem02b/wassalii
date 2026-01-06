"""
Messages API Endpoints
"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import or_, and_, func
from typing import List
from datetime import datetime

from app.db.database import get_db
from app.models.models import Message, User
from app.schemas.schemas import MessageCreate, MessageResponse, ConversationResponse
from app.api.v1.endpoints.auth import get_current_user

router = APIRouter(prefix="/messages", tags=["Messages"])


@router.post("/", response_model=MessageResponse, status_code=status.HTTP_201_CREATED)
async def send_message(
    message_data: MessageCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Send a message to another user"""
    # Vérifier que le destinataire existe
    receiver = db.query(User).filter(User.id == message_data.receiver_id).first()
    if not receiver:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Receiver not found"
        )
    
    # Générer conversation_id unique (toujours le même ordre: plus petit id en premier)
    user_ids = sorted([current_user.id, message_data.receiver_id])
    conversation_id = f"{user_ids[0]}_{user_ids[1]}"
    
    # Créer le message
    new_message = Message(
        conversation_id=conversation_id,
        sender_id=current_user.id,
        receiver_id=message_data.receiver_id,
        content=message_data.content,
        is_read=False
    )
    
    db.add(new_message)
    db.commit()
    db.refresh(new_message)
    
    return new_message


@router.get("/conversations", response_model=List[ConversationResponse])
async def get_conversations(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get all conversations for the current user"""
    # Récupérer tous les messages où l'utilisateur est sender ou receiver
    messages = db.query(Message).filter(
        or_(
            Message.sender_id == current_user.id,
            Message.receiver_id == current_user.id
        )
    ).order_by(Message.created_at.desc()).all()
    
    # Grouper par conversation_id et récupérer le dernier message de chaque conversation
    conversations = {}
    for msg in messages:
        if msg.conversation_id not in conversations:
            # Déterminer l'autre utilisateur (pas moi)
            other_user_id = msg.receiver_id if msg.sender_id == current_user.id else msg.sender_id
            other_user = db.query(User).filter(User.id == other_user_id).first()
            
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
                "is_online": False  # TODO: Implémenter le statut en ligne avec WebSocket
            }
    
    return list(conversations.values())


@router.get("/{conversation_id}", response_model=List[MessageResponse])
async def get_conversation_messages(
    conversation_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get all messages in a conversation"""
    # Vérifier que l'utilisateur fait partie de la conversation
    user_ids = conversation_id.split('_')
    if str(current_user.id) not in user_ids:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to access this conversation"
        )
    
    # Récupérer tous les messages de la conversation
    messages = db.query(Message).filter(
        Message.conversation_id == conversation_id
    ).order_by(Message.created_at.asc()).all()
    
    # Marquer comme lus les messages reçus
    db.query(Message).filter(
        and_(
            Message.conversation_id == conversation_id,
            Message.receiver_id == current_user.id,
            Message.is_read == False
        )
    ).update({"is_read": True})
    db.commit()
    
    return messages


@router.get("/conversation/{other_user_id}", response_model=List[MessageResponse])
async def get_conversation_with_user(
    other_user_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get all messages in a conversation with a specific user"""
    # Vérifier que l'autre utilisateur existe
    other_user = db.query(User).filter(User.id == other_user_id).first()
    if not other_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    # Générer conversation_id (toujours le même ordre: plus petit id en premier)
    user_ids = sorted([current_user.id, other_user_id])
    conversation_id = f"{user_ids[0]}_{user_ids[1]}"
    
    # Récupérer tous les messages de la conversation
    messages = db.query(Message).filter(
        Message.conversation_id == conversation_id
    ).order_by(Message.created_at.asc()).all()
    
    # Marquer comme lus les messages reçus
    db.query(Message).filter(
        and_(
            Message.conversation_id == conversation_id,
            Message.receiver_id == current_user.id,
            Message.is_read == False
        )
    ).update({"is_read": True})
    db.commit()
    
    return messages


@router.put("/{message_id}/read", response_model=MessageResponse)
async def mark_message_as_read(
    message_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Mark a message as read"""
    message = db.query(Message).filter(Message.id == message_id).first()
    
    if not message:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Message not found"
        )
    
    if message.receiver_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to mark this message as read"
        )
    
    message.is_read = True
    db.commit()
    db.refresh(message)
    
    return message


@router.delete("/{conversation_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_conversation(
    conversation_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Delete all messages in a conversation"""
    # Vérifier que l'utilisateur fait partie de la conversation
    user_ids = conversation_id.split('_')
    if str(current_user.id) not in user_ids:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to delete this conversation"
        )
    
    # Supprimer tous les messages de la conversation
    db.query(Message).filter(Message.conversation_id == conversation_id).delete()
    db.commit()
    
    return None
