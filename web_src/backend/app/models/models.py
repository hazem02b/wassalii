"""
Database Models - SQLAlchemy ORM
"""
from sqlalchemy import (
    Column, Integer, String, Float, DateTime, Boolean,
    ForeignKey, Enum, Text, JSON, UniqueConstraint, Index
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum

from app.db.database import Base


class UserRole(str, enum.Enum):
    """User role enumeration"""
    CLIENT = "client"
    TRANSPORTER = "transporter"
    ADMIN = "admin"


class BookingStatus(str, enum.Enum):
    """Booking status enumeration"""
    PENDING = "pending"
    CONFIRMED = "confirmed"
    IN_TRANSIT = "in_transit"
    DELIVERED = "delivered"
    CANCELLED = "cancelled"


class User(Base):
    """User model"""
    __tablename__ = "users"
    __table_args__ = (
        UniqueConstraint('email', 'role', name='uq_email_role'),
        Index('idx_email_role', 'email', 'role'),
    )
    
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(255), index=True, nullable=False)  # Removed unique=True
    phone = Column(String(20), index=True)  # Removed unique=True to allow same phone for client/transporter
    password_hash = Column(String(255), nullable=False)
    
    # Profile info
    name = Column(String(200), nullable=False)  # Nom complet
    role = Column(Enum(UserRole), nullable=False)
    avatar_url = Column(String(500))
    address = Column(String(500))  # Adresse de localisation
    vehicle_type = Column(String(100))  # Type de véhicule pour transporteur
    
    # Verification
    is_verified = Column(Boolean, default=False)
    is_active = Column(Boolean, default=True)
    
    # Stats
    rating = Column(Float, default=0.0)
    total_trips = Column(Integer, default=0)
    total_bookings = Column(Integer, default=0)
    
    # Password Reset
    reset_code = Column(String(6), nullable=True)
    reset_code_expires = Column(DateTime(timezone=True), nullable=True)
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    trips = relationship("Trip", back_populates="transporter")
    bookings = relationship("Booking", back_populates="client")
    reviews_given = relationship("Review", foreign_keys="Review.client_id", back_populates="client")
    reviews_received = relationship("Review", foreign_keys="Review.transporter_id", back_populates="transporter")


class Trip(Base):
    """Trip model"""
    __tablename__ = "trips"
    
    id = Column(Integer, primary_key=True, index=True)
    transporter_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    
    # Origin & Destination
    origin_city = Column(String(100), nullable=False)
    origin_country = Column(String(100), nullable=False)
    destination_city = Column(String(100), nullable=False)
    destination_country = Column(String(100), nullable=False)
    
    # Dates
    departure_date = Column(DateTime(timezone=True), nullable=False)
    arrival_date = Column(DateTime(timezone=True))
    
    # Capacity
    max_weight = Column(Float, nullable=False)  # kg
    available_weight = Column(Float, nullable=False)
    price_per_kg = Column(Float, nullable=False)
    
    # Details
    description = Column(Text)
    accepted_items = Column(JSON)  # List of accepted item types
    vehicle_info = Column(String(200))
    
    # Status
    is_active = Column(Boolean, default=True)
    is_completed = Column(Boolean, default=False)
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    transporter = relationship("User", back_populates="trips")
    bookings = relationship("Booking", back_populates="trip")


class Booking(Base):
    """Booking model"""
    __tablename__ = "bookings"
    
    id = Column(Integer, primary_key=True, index=True)
    trip_id = Column(Integer, ForeignKey("trips.id"), nullable=False)
    client_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    
    # Package details
    weight = Column(Float, nullable=False)  # kg
    item_type = Column(String(100), nullable=False)
    description = Column(Text)
    
    # Pickup & Delivery
    pickup_address = Column(String(500), nullable=False)
    pickup_city = Column(String(100), nullable=False)
    delivery_address = Column(String(500), nullable=False)
    delivery_city = Column(String(100), nullable=False)
    
    # Contact
    recipient_name = Column(String(200), nullable=False)
    recipient_phone = Column(String(20), nullable=False)
    
    # Pricing
    total_price = Column(Float, nullable=False)
    is_paid = Column(Boolean, default=False)
    payment_method = Column(String(50))
    
    # Status
    status = Column(Enum(BookingStatus), default=BookingStatus.PENDING)
    
    # Tracking
    tracking_number = Column(String(50), unique=True, index=True)
    notes = Column(Text)
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    delivered_at = Column(DateTime(timezone=True))
    
    # Relationships
    trip = relationship("Trip", back_populates="bookings")
    client = relationship("User", back_populates="bookings")


class Review(Base):
    """Review model"""
    __tablename__ = "reviews"
    
    id = Column(Integer, primary_key=True, index=True)
    booking_id = Column(Integer, ForeignKey("bookings.id"), nullable=False)
    transporter_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    client_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    
    # Review content
    rating = Column(Integer, nullable=False)  # 1-5
    comment = Column(Text)
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationships
    transporter = relationship("User", foreign_keys=[transporter_id], back_populates="reviews_received")
    client = relationship("User", foreign_keys=[client_id], back_populates="reviews_given")


class Message(Base):
    """Message model"""
    __tablename__ = "messages"
    
    id = Column(Integer, primary_key=True, index=True)
    conversation_id = Column(String(100), index=True, nullable=False)
    sender_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    receiver_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    
    # Content
    content = Column(Text, nullable=False)
    
    # Status
    is_read = Column(Boolean, default=False)
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())


class Notification(Base):
    """Notification model"""
    __tablename__ = "notifications"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    
    # Content
    title = Column(String(200), nullable=False)
    message = Column(Text, nullable=False)
    type = Column(String(50))  # booking, trip, message, etc.
    
    # Link
    link = Column(String(500))
    
    # Status
    is_read = Column(Boolean, default=False)
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())
