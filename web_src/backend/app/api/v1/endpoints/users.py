from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func
from app.db.database import get_db
from app.models.models import User, Booking, Trip
from app.api.v1.endpoints.auth import get_current_user
from app.schemas.schemas import UserResponse, UserUpdate
from datetime import datetime

router = APIRouter(prefix="/users", tags=["users"])


@router.get("/available", response_model=List[UserResponse])
def get_available_users(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Get list of users available for messaging.
    Returns all users except the current user.
    """
    users = db.query(User).filter(User.id != current_user.id).all()
    return users


@router.get("/me")
def get_current_user_info(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Get current user information with full details.
    """
    return {
        "id": current_user.id,
        "email": current_user.email,
        "name": current_user.name,
        "phone": current_user.phone,
        "address": current_user.address,
        "role": current_user.role,
        "vehicle_type": getattr(current_user, 'vehicle_type', None),
        "profile_picture": current_user.avatar_url,
        "created_at": current_user.created_at
    }


@router.get("/me/stats")
def get_user_stats(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Get user statistics (bookings count, total spent, etc.)
    """
    if current_user.role == "client":
        # Statistiques client
        total_bookings = db.query(Booking).filter(
            Booking.client_id == current_user.id
        ).count()
        
        # Total dépensé (réservations payées)
        total_spent = db.query(func.sum(Booking.total_price)).filter(
            Booking.client_id == current_user.id,
            Booking.is_paid == True
        ).scalar() or 0
        
        # Réservations actives
        active_bookings = db.query(Booking).filter(
            Booking.client_id == current_user.id,
            Booking.status.in_(['pending', 'confirmed', 'in_transit'])
        ).count()
        
        # Réservations terminées
        completed_bookings = db.query(Booking).filter(
            Booking.client_id == current_user.id,
            Booking.status == 'delivered'
        ).count()
        
        return {
            "total_bookings": total_bookings,
            "total_spent": float(total_spent),
            "active_bookings": active_bookings,
            "completed_bookings": completed_bookings,
            "cancelled_bookings": total_bookings - active_bookings - completed_bookings
        }
    
    elif current_user.role == "transporter":
        # Statistiques transporteur
        total_trips = db.query(Trip).filter(
            Trip.transporter_id == current_user.id
        ).count()
        
        # Total revenus (réservations livrées et payées)
        total_revenue = db.query(func.sum(Booking.total_price)).join(
            Trip, Booking.trip_id == Trip.id
        ).filter(
            Trip.transporter_id == current_user.id,
            Booking.status == 'delivered',
            Booking.is_paid == True
        ).scalar() or 0
        
        # Réservations en attente
        pending_bookings = db.query(Booking).join(
            Trip, Booking.trip_id == Trip.id
        ).filter(
            Trip.transporter_id == current_user.id,
            Booking.status == 'pending'
        ).count()
        
        # Réservations confirmées
        confirmed_bookings = db.query(Booking).join(
            Trip, Booking.trip_id == Trip.id
        ).filter(
            Trip.transporter_id == current_user.id,
            Booking.status == 'confirmed'
        ).count()
        
        # Réservations en transit
        in_transit_bookings = db.query(Booking).join(
            Trip, Booking.trip_id == Trip.id
        ).filter(
            Trip.transporter_id == current_user.id,
            Booking.status == 'in_transit'
        ).count()
        
        return {
            "total_trips": total_trips,
            "total_revenue": float(total_revenue),
            "pending_bookings": pending_bookings,
            "confirmed_bookings": confirmed_bookings,
            "in_transit_bookings": in_transit_bookings
        }
    
    return {}


@router.put("/me")
def update_user_profile(
    user_update: UserUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Update current user profile.
    """
    # Mettre à jour les champs fournis
    if user_update.name is not None:
        current_user.name = user_update.name
    if user_update.phone is not None:
        current_user.phone = user_update.phone
    if user_update.address is not None:
        current_user.address = user_update.address
    
    db.commit()
    db.refresh(current_user)
    
    return {
        "id": current_user.id,
        "email": current_user.email,
        "name": current_user.name,
        "phone": current_user.phone,
        "address": current_user.address,
        "role": current_user.role
    }


@router.put("/me/profile-picture")
def update_profile_picture(
    data: dict,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Update user profile picture (base64 encoded image).
    """
    profile_picture = data.get("profile_picture")
    
    if not profile_picture:
        raise HTTPException(status_code=400, detail="Profile picture is required")
    
    # Stocker l'image en base64 dans avatar_url
    current_user.avatar_url = profile_picture
    
    db.commit()
    db.refresh(current_user)
    
    return {
        "success": True,
        "message": "Photo de profil mise à jour avec succès"
    }
