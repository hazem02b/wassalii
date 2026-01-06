"""
Review management endpoints
"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import List

from app.db.database import get_db
from app.models.models import Review, User, Booking
from app.schemas.schemas import ReviewCreate, ReviewResponse
from app.api.v1.endpoints.auth import get_current_user


router = APIRouter(prefix="/reviews", tags=["Reviews"])


@router.post("/", response_model=ReviewResponse, status_code=status.HTTP_201_CREATED)
async def create_review(
    review_data: ReviewCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Create a review (client only, after booking is delivered)"""
    if current_user.role != "client":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only clients can leave reviews"
        )
    
    # Verify booking exists and belongs to current user
    booking = db.query(Booking).filter(Booking.id == review_data.booking_id).first()
    if not booking:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Booking not found"
        )
    
    if booking.client_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You can only review your own bookings"
        )
    
    # Check if booking is delivered
    if booking.status != "delivered":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="You can only review delivered bookings"
        )
    
    # Check if review already exists for this booking
    existing_review = db.query(Review).filter(
        Review.booking_id == review_data.booking_id
    ).first()
    
    if existing_review:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="You have already reviewed this booking"
        )
    
    # Create review
    review = Review(
        booking_id=review_data.booking_id,
        transporter_id=review_data.transporter_id,
        client_id=current_user.id,
        rating=review_data.rating,
        comment=review_data.comment
    )
    
    db.add(review)
    db.commit()
    db.refresh(review)
    
    # Update transporter's average rating
    avg_rating = db.query(func.avg(Review.rating)).filter(
        Review.transporter_id == review_data.transporter_id
    ).scalar()
    
    transporter = db.query(User).filter(User.id == review_data.transporter_id).first()
    if transporter:
        transporter.rating = round(float(avg_rating), 2) if avg_rating else 0.0
        db.commit()
    
    return review


@router.get("/transporter/{transporter_id}", response_model=List[ReviewResponse])
async def get_transporter_reviews(
    transporter_id: int,
    db: Session = Depends(get_db)
):
    """Get all reviews for a specific transporter (public)"""
    reviews = db.query(Review).filter(
        Review.transporter_id == transporter_id
    ).order_by(Review.created_at.desc()).all()
    
    return reviews


@router.get("/my-reviews", response_model=List[ReviewResponse])
async def get_my_reviews(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get reviews for current user (transporter sees received reviews, client sees given reviews)"""
    if current_user.role == "transporter":
        reviews = db.query(Review).filter(
            Review.transporter_id == current_user.id
        ).order_by(Review.created_at.desc()).all()
    else:
        reviews = db.query(Review).filter(
            Review.client_id == current_user.id
        ).order_by(Review.created_at.desc()).all()
    
    return reviews


@router.get("/booking/{booking_id}", response_model=ReviewResponse)
async def get_booking_review(
    booking_id: int,
    db: Session = Depends(get_db)
):
    """Get review for a specific booking"""
    review = db.query(Review).filter(Review.booking_id == booking_id).first()
    
    if not review:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No review found for this booking"
        )
    
    return review
