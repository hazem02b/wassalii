"""
Booking management endpoints
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import List
import secrets
import string

from app.db.database import get_db
from app.models.models import Booking, Trip, User
from app.schemas.schemas import (
    BookingCreate, BookingUpdate, BookingResponse, BookingWithDetails
)
from app.api.v1.endpoints.auth import get_current_user


router = APIRouter(prefix="/bookings", tags=["Bookings"])


def generate_tracking_number() -> str:
    """Generate unique tracking number"""
    chars = string.ascii_uppercase + string.digits
    return 'WSL-' + ''.join(secrets.choice(chars) for _ in range(10))


@router.post("/", response_model=BookingResponse, status_code=status.HTTP_201_CREATED)
async def create_booking(
    booking_data: BookingCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Create a new booking (clients only)"""
    from app.models.models import UserRole
    if current_user.role != UserRole.CLIENT:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only clients can create bookings"
        )
    
    # Check if trip exists and is available
    trip = db.query(Trip).filter(Trip.id == booking_data.trip_id).first()
    if not trip:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Trip not found"
        )
    
    if not trip.is_active:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Trip is no longer active"
        )
    
    if trip.available_weight < booking_data.weight:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Not enough capacity. Available: {trip.available_weight}kg"
        )
    
    # Calculate total price
    total_price = booking_data.weight * trip.price_per_kg
    
    # Create booking
    booking = Booking(
        client_id=current_user.id,
        total_price=total_price,
        tracking_number=generate_tracking_number(),
        **booking_data.model_dump()
    )
    
    db.add(booking)
    
    # Update trip available weight
    trip.available_weight -= booking_data.weight
    
    # Update user stats
    current_user.total_bookings += 1
    
    db.commit()
    db.refresh(booking)
    
    return booking


@router.get("/my", response_model=List[BookingWithDetails])
async def get_my_bookings_dedicated(
    current_user: User = Depends(get_current_user),
    skip: int = Query(0, ge=0),
    limit: int = Query(10, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """Get current user's bookings (dedicated endpoint)"""
    if current_user.role == "client":
        bookings = db.query(Booking)\
            .filter(Booking.client_id == current_user.id)\
            .order_by(Booking.created_at.desc())\
            .offset(skip)\
            .limit(limit)\
            .all()
    elif current_user.role == "transporter":
        # For transporters, get bookings for their trips
        bookings = db.query(Booking)\
            .join(Trip)\
            .filter(Trip.transporter_id == current_user.id)\
            .order_by(Booking.created_at.desc())\
            .offset(skip)\
            .limit(limit)\
            .all()
    else:
        bookings = []
    
    return bookings


@router.get("/", response_model=List[BookingWithDetails])
async def get_my_bookings(
    current_user: User = Depends(get_current_user),
    skip: int = Query(0, ge=0),
    limit: int = Query(10, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """Get current user's bookings"""
    if current_user.role == "client":
        bookings = db.query(Booking)\
            .filter(Booking.client_id == current_user.id)\
            .order_by(Booking.created_at.desc())\
            .offset(skip)\
            .limit(limit)\
            .all()
    elif current_user.role == "transporter":
        # Get bookings for transporter's trips
        bookings = db.query(Booking)\
            .join(Trip)\
            .filter(Trip.transporter_id == current_user.id)\
            .order_by(Booking.created_at.desc())\
            .offset(skip)\
            .limit(limit)\
            .all()
    else:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Invalid role"
        )
    
    return bookings


@router.get("/{booking_id}", response_model=BookingWithDetails)
async def get_booking(
    booking_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get booking by ID"""
    booking = db.query(Booking).filter(Booking.id == booking_id).first()
    if not booking:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Booking not found"
        )
    
    # Check access permissions
    trip = db.query(Trip).filter(Trip.id == booking.trip_id).first()
    if booking.client_id != current_user.id and trip.transporter_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access denied"
        )
    
    return booking


@router.get("/tracking/{tracking_number}", response_model=BookingWithDetails)
async def track_booking(tracking_number: str, db: Session = Depends(get_db)):
    """Track booking by tracking number (public endpoint)"""
    booking = db.query(Booking).filter(
        Booking.tracking_number == tracking_number
    ).first()
    
    if not booking:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Booking not found with this tracking number"
        )
    
    return booking


@router.put("/{booking_id}", response_model=BookingResponse)
async def update_booking(
    booking_id: int,
    booking_data: BookingUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Update booking status (transporter can update status, client can update payment)"""
    booking = db.query(Booking).filter(Booking.id == booking_id).first()
    if not booking:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Booking not found"
        )
    
    # Check permissions
    trip = db.query(Trip).filter(Trip.id == booking.trip_id).first()
    is_transporter = trip.transporter_id == current_user.id
    is_client = booking.client_id == current_user.id
    
    if not (is_transporter or is_client):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access denied"
        )
    
    # Transporter can update status
    if is_transporter and booking_data.status:
        booking.status = booking_data.status
        if booking_data.status == "delivered":
            from datetime import datetime
            booking.delivered_at = datetime.utcnow()
    
    # Client can update payment
    if is_client and (booking_data.is_paid is not None or booking_data.payment_method):
        if booking_data.is_paid is not None:
            booking.is_paid = booking_data.is_paid
        if booking_data.payment_method:
            booking.payment_method = booking_data.payment_method
    
    # Anyone involved can add notes
    if booking_data.notes:
        booking.notes = booking_data.notes
    
    db.commit()
    db.refresh(booking)
    
    return booking


@router.delete("/{booking_id}", status_code=status.HTTP_204_NO_CONTENT)
async def cancel_booking(
    booking_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Cancel booking (client only, before confirmation)"""
    booking = db.query(Booking).filter(Booking.id == booking_id).first()
    if not booking:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Booking not found"
        )
    
    if booking.client_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You can only cancel your own bookings"
        )
    
    if booking.status != "pending":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Can only cancel pending bookings"
        )
    
    # Restore trip capacity
    trip = db.query(Trip).filter(Trip.id == booking.trip_id).first()
    trip.available_weight += booking.weight
    
    # Update booking status
    booking.status = "cancelled"
    
    db.commit()
