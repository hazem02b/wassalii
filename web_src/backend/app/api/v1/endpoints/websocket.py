"""
Endpoints WebSocket pour notifications en temps réel
"""
from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Depends, Query
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.core.notifications import notification_manager
from app.core.security import decode_access_token


router = APIRouter(prefix="/ws", tags=["WebSocket"])


@router.websocket("/notifications")
async def websocket_notifications(
    websocket: WebSocket,
    token: str = Query(...),
    db: Session = Depends(get_db)
):
    """
    WebSocket endpoint pour recevoir des notifications en temps réel
    
    Usage:
    ws://localhost:8000/api/v1/ws/notifications?token=YOUR_JWT_TOKEN
    """
    # Vérifier le token
    payload = decode_access_token(token)
    if not payload:
        await websocket.close(code=1008, reason="Invalid token")
        return
    
    user_id_str = payload.get("sub")
    if not user_id_str:
        await websocket.close(code=1008, reason="Invalid token payload")
        return
    
    try:
        user_id = int(user_id_str)
    except (ValueError, TypeError):
        await websocket.close(code=1008, reason="Invalid user ID")
        return
    
    # Connecter le WebSocket
    await notification_manager.connect(websocket, user_id)
    
    try:
        # Boucle pour garder la connexion active
        while True:
            # Recevoir les messages du client (pour ping/pong)
            data = await websocket.receive_text()
            
            # On peut traiter les messages du client ici si nécessaire
            if data == "ping":
                await websocket.send_text("pong")
                
    except WebSocketDisconnect:
        notification_manager.disconnect(websocket, user_id)
    except Exception as e:
        print(f"WebSocket error: {e}")
        notification_manager.disconnect(websocket, user_id)
