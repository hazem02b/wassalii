"""
API v1 Router - Combines all endpoint routers
"""
from fastapi import APIRouter

from app.api.v1.endpoints import auth, trips, bookings, websocket, messages, users, reviews


api_router = APIRouter()

# Include all endpoint routers
api_router.include_router(auth.router)
api_router.include_router(trips.router)
api_router.include_router(bookings.router)
api_router.include_router(messages.router)
api_router.include_router(users.router)
api_router.include_router(reviews.router)
api_router.include_router(websocket.router)
