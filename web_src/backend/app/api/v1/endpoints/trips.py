"""
Trip management endpoints
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from sqlalchemy import and_, or_
from typing import List, Optional
from datetime import datetime

from app.db.database import get_db
from app.models.models import Trip, User, Booking
from app.schemas.schemas import (
    TripCreate, TripUpdate, TripResponse, TripWithTransporter,
    TripSearchFilters, PaginationParams
)
from app.api.v1.endpoints.auth import get_current_user


router = APIRouter(prefix="/trips", tags=["Trips"])


@router.post("/", response_model=TripResponse, status_code=status.HTTP_201_CREATED)
async def create_trip(
    trip_data: TripCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Create a new trip (transporters only)"""
    from app.models.models import UserRole
    if current_user.role != UserRole.TRANSPORTER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only transporters can create trips"
        )
    
    trip = Trip(
        transporter_id=current_user.id,
        available_weight=trip_data.max_weight,  # Initially all weight is available
        **trip_data.model_dump()
    )
    
    db.add(trip)
    db.commit()
    db.refresh(trip)
    
    # Update user stats
    current_user.total_trips += 1
    db.commit()
    
    return trip


@router.get("/my", response_model=List[TripWithTransporter])
async def get_my_trips(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get current user's trips (transporters only)"""
    from app.models.models import UserRole
    if current_user.role != UserRole.TRANSPORTER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only transporters can view their trips"
        )
    
    trips = db.query(Trip)\
        .filter(Trip.transporter_id == current_user.id)\
        .filter(Trip.is_active == True)\
        .order_by(Trip.departure_date.desc())\
        .all()
    
    return trips


@router.get("/", response_model=List[TripWithTransporter])
async def search_trips(
    origin_city: Optional[str] = None,
    destination_city: Optional[str] = None,
    min_departure_date: Optional[datetime] = None,
    max_departure_date: Optional[datetime] = None,
    min_weight: Optional[float] = None,
    max_price_per_kg: Optional[float] = None,
    skip: int = Query(0, ge=0),
    limit: int = Query(10, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """Search trips with filters"""
    query = db.query(Trip).filter(Trip.is_active == True)
    
    if origin_city:
        query = query.filter(Trip.origin_city.ilike(f"%{origin_city}%"))
    
    if destination_city:
        query = query.filter(Trip.destination_city.ilike(f"%{destination_city}%"))
    
    if min_departure_date:
        query = query.filter(Trip.departure_date >= min_departure_date)
    
    if max_departure_date:
        query = query.filter(Trip.departure_date <= max_departure_date)
    
    if min_weight:
        query = query.filter(Trip.available_weight >= min_weight)
    
    if max_price_per_kg:
        query = query.filter(Trip.price_per_kg <= max_price_per_kg)
    
    trips = query.offset(skip).limit(limit).all()
    return trips


@router.get("/{trip_id}", response_model=TripWithTransporter)
async def get_trip(trip_id: int, db: Session = Depends(get_db)):
    """Get trip by ID"""
    trip = db.query(Trip).filter(Trip.id == trip_id, Trip.is_active == True).first()
    if not trip:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Trip not found"
        )
    return trip


@router.put("/{trip_id}", response_model=TripResponse)
async def update_trip(
    trip_id: int,
    trip_data: TripUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Update trip (owner only)"""
    trip = db.query(Trip).filter(Trip.id == trip_id).first()
    if not trip:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Trip not found"
        )
    
    if trip.transporter_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You can only update your own trips"
        )
    
    # Update fields
    for field, value in trip_data.model_dump(exclude_unset=True).items():
        setattr(trip, field, value)
    
    db.commit()
    db.refresh(trip)
    
    return trip


@router.delete("/{trip_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_trip(
    trip_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Delete trip (owner only) - Also deletes or cancels associated bookings"""
    trip = db.query(Trip).filter(Trip.id == trip_id).first()
    if not trip:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Trip not found"
        )
    
    if trip.transporter_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You can only delete your own trips"
        )
    
    # Vérifier s'il y a des bookings payés
    paid_bookings = db.query(Booking).filter(
        Booking.trip_id == trip_id,
        Booking.is_paid == True
    ).count()
    
    if paid_bookings > 0:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Cannot delete trip with {paid_bookings} paid booking(s)"
        )
    
    # Annuler (supprimer) tous les bookings non payés pour ce trajet
    unpaid_bookings = db.query(Booking).filter(
        Booking.trip_id == trip_id,
        Booking.is_paid == False
    ).all()
    
    for booking in unpaid_bookings:
        booking.status = 'cancelled'
    
    # Soft delete - mark trip as inactive
    trip.is_active = False
    db.commit()
    
    return None


@router.get("/transporter/{transporter_id}", response_model=List[TripResponse])
async def get_transporter_trips(
    transporter_id: int,
    skip: int = Query(0, ge=0),
    limit: int = Query(10, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """Get trips by transporter"""
    trips = db.query(Trip)\
        .filter(Trip.transporter_id == transporter_id)\
        .filter(Trip.is_active == True)\
        .order_by(Trip.departure_date.desc())\
        .offset(skip)\
        .limit(limit)\
        .all()
    
    return trips
