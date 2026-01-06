"""
Service de notifications en temps réel via WebSocket
"""
from fastapi import WebSocket
from typing import Dict, List
import json
from datetime import datetime


class ConnectionManager:
    """Gestionnaire de connexions WebSocket"""
    
    def __init__(self):
        # user_id -> List[WebSocket]
        self.active_connections: Dict[int, List[WebSocket]] = {}
    
    async def connect(self, websocket: WebSocket, user_id: int):
        """Accepter une nouvelle connexion WebSocket"""
        await websocket.accept()
        if user_id not in self.active_connections:
            self.active_connections[user_id] = []
        self.active_connections[user_id].append(websocket)
        print(f"✅ WebSocket connecté pour user {user_id}")
    
    def disconnect(self, websocket: WebSocket, user_id: int):
        """Déconnecter un WebSocket"""
        if user_id in self.active_connections:
            if websocket in self.active_connections[user_id]:
                self.active_connections[user_id].remove(websocket)
            if not self.active_connections[user_id]:
                del self.active_connections[user_id]
        print(f"❌ WebSocket déconnecté pour user {user_id}")
    
    async def send_personal_message(self, message: dict, user_id: int):
        """Envoyer un message à un utilisateur spécifique"""
        if user_id in self.active_connections:
            message_json = json.dumps(message)
            for connection in self.active_connections[user_id]:
                try:
                    await connection.send_text(message_json)
                except Exception as e:
                    print(f"Erreur envoi message WebSocket: {e}")
    
    async def send_notification(
        self,
        user_id: int,
        notification_type: str,
        title: str,
        message: str,
        data: dict = None
    ):
        """Envoyer une notification à un utilisateur"""
        notification = {
            "type": notification_type,
            "title": title,
            "message": message,
            "data": data or {},
            "timestamp": datetime.utcnow().isoformat()
        }
        await self.send_personal_message(notification, user_id)
    
    async def send_call_notification(
        self,
        user_id: int,
        caller_name: str,
        caller_id: int,
        call_type: str = "voice"  # voice ou video
    ):
        """Notification d'appel entrant"""
        await self.send_notification(
            user_id=user_id,
            notification_type="incoming_call",
            title=f"Appel de {caller_name}",
            message=f"{caller_name} vous appelle",
            data={
                "caller_id": caller_id,
                "caller_name": caller_name,
                "call_type": call_type
            }
        )
    
    async def send_message_notification(
        self,
        user_id: int,
        sender_name: str,
        sender_id: int,
        message_preview: str
    ):
        """Notification de nouveau message"""
        await self.send_notification(
            user_id=user_id,
            notification_type="new_message",
            title=f"Message de {sender_name}",
            message=message_preview,
            data={
                "sender_id": sender_id,
                "sender_name": sender_name
            }
        )
    
    async def send_booking_notification(
        self,
        user_id: int,
        booking_id: int,
        status: str,
        message: str
    ):
        """Notification de changement de statut de réservation"""
        await self.send_notification(
            user_id=user_id,
            notification_type="booking_update",
            title="Mise à jour réservation",
            message=message,
            data={
                "booking_id": booking_id,
                "status": status
            }
        )


# Instance globale
notification_manager = ConnectionManager()
