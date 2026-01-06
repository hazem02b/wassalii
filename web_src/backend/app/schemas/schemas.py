"""
Pydantic Schemas for API request/response validation
"""
from pydantic import BaseModel, EmailStr, Field, validator, ConfigDict
from typing import Optional, List, Any
from datetime import datetime
from enum import Enum


# ==================== ENUMS ====================

class UserRole(str, Enum):
    CLIENT = "client"
    TRANSPORTER = "transporter"
    ADMIN = "admin"


class BookingStatus(str, Enum):
    PENDING = "pending"
    CONFIRMED = "confirmed"
    IN_TRANSIT = "in_transit"
    DELIVERED = "delivered"
    CANCELLED = "cancelled"


# ==================== USER SCHEMAS ====================

class UserBase(BaseModel):
    email: EmailStr
    name: str = Field(..., min_length=2, max_length=200)  # Nom complet
    phone: Optional[str] = Field(None, max_length=20)
    role: UserRole
    address: Optional[str] = Field(None, max_length=500)  # Adresse


class UserCreate(UserBase):
    password: str = Field(..., min_length=6)  # Minimum 6 caractères comme dans le frontend


class UserCreateSimple(BaseModel):
    """Schema pour inscription sans spécifier le rôle (endpoints /client ou /transporter)"""
    email: EmailStr
    name: str = Field(..., min_length=2, max_length=200)
    phone: Optional[str] = Field(None, max_length=20)
    password: str = Field(..., min_length=6)
    address: Optional[str] = Field(None, max_length=500)


class UserLogin(BaseModel):
    email: EmailStr
    password: str
    role: str  # Accepte "client" ou "transporter" comme string


class UserUpdate(BaseModel):
    name: Optional[str] = Field(None, min_length=2, max_length=200)
    phone: Optional[str] = Field(None, max_length=20)
    avatar_url: Optional[str] = None
    address: Optional[str] = Field(None, max_length=500)


class PasswordChange(BaseModel):
    current_password: str
    new_password: str = Field(..., min_length=6)


class ForgotPasswordRequest(BaseModel):
    email: EmailStr
    role: UserRole


class ResetPasswordRequest(BaseModel):
    email: EmailStr
    role: UserRole
    reset_code: str
    new_password: str = Field(..., min_length=6)


class UserResponse(UserBase):
    id: int
    avatar_url: Optional[str] = None
    is_verified: bool
    is_active: bool
    rating: float
    total_trips: int
    total_bookings: int
    created_at: datetime
    
    model_config = ConfigDict(from_attributes=True)


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse


# ==================== TRIP SCHEMAS ====================

class TripBase(BaseModel):
    origin_city: str = Field(..., max_length=100)
    origin_country: str = Field(..., max_length=100)
    destination_city: str = Field(..., max_length=100)
    destination_country: str = Field(..., max_length=100)
    departure_date: datetime
    arrival_date: Optional[datetime] = None
    max_weight: float = Field(..., gt=0, le=1000)
    price_per_kg: float = Field(..., gt=0)
    description: Optional[str] = None
    accepted_items: Optional[List[str]] = None
    vehicle_info: Optional[str] = Field(None, max_length=200)


class TripCreate(TripBase):
    pass


class TripUpdate(BaseModel):
    origin_city: Optional[str] = Field(None, max_length=100)
    origin_country: Optional[str] = Field(None, max_length=100)
    destination_city: Optional[str] = Field(None, max_length=100)
    destination_country: Optional[str] = Field(None, max_length=100)
    departure_date: Optional[datetime] = None
    arrival_date: Optional[datetime] = None
    max_weight: Optional[float] = Field(None, gt=0, le=1000)
    price_per_kg: Optional[float] = Field(None, gt=0)
    description: Optional[str] = None
    notes: Optional[str] = None
    accepted_items: Optional[List[str]] = None
    vehicle_info: Optional[str] = Field(None, max_length=200)
    is_active: Optional[bool] = None


class TripResponse(TripBase):
    id: int
    transporter_id: int
    available_weight: float
    is_active: bool
    is_completed: bool
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    model_config = ConfigDict(from_attributes=True)


class TripWithTransporter(TripResponse):
    transporter: UserResponse


# ==================== BOOKING SCHEMAS ====================

class BookingBase(BaseModel):
    weight: float = Field(..., gt=0, le=100)
    item_type: str = Field(..., max_length=100)
    description: Optional[str] = None
    pickup_address: str = Field(..., max_length=500)
    pickup_city: str = Field(..., max_length=100)
    delivery_address: str = Field(..., max_length=500)
    delivery_city: str = Field(..., max_length=100)
    recipient_name: str = Field(..., max_length=200)
    recipient_phone: str = Field(..., max_length=20)


class BookingCreate(BookingBase):
    trip_id: int


class BookingUpdate(BaseModel):
    status: Optional[BookingStatus] = None
    is_paid: Optional[bool] = None
    payment_method: Optional[str] = None
    notes: Optional[str] = None


class BookingResponse(BookingBase):
    id: int
    trip_id: int
    client_id: int
    total_price: float
    is_paid: bool
    payment_method: Optional[str] = None
    status: BookingStatus
    tracking_number: str
    notes: Optional[str] = None
    created_at: datetime
    updated_at: Optional[datetime] = None
    delivered_at: Optional[datetime] = None
    
    model_config = ConfigDict(from_attributes=True)


class BookingWithDetails(BookingResponse):
    trip: TripWithTransporter
    client: UserResponse


# ==================== REVIEW SCHEMAS ====================

class ReviewBase(BaseModel):
    rating: int = Field(..., ge=1, le=5)
    comment: Optional[str] = None


class ReviewCreate(ReviewBase):
    booking_id: int
    transporter_id: int


class ReviewResponse(ReviewBase):
    id: int
    booking_id: int
    transporter_id: int
    client_id: int
    created_at: datetime
    client: UserResponse
    
    model_config = ConfigDict(from_attributes=True)


# ==================== MESSAGE SCHEMAS ====================

class MessageCreate(BaseModel):
    receiver_id: int
    content: str = Field(..., min_length=1)


class MessageResponse(BaseModel):
    id: int
    conversation_id: str
    sender_id: int
    receiver_id: int
    content: str
    is_read: bool
    created_at: datetime
    
    model_config = ConfigDict(from_attributes=True)


# ==================== NOTIFICATION SCHEMAS ====================

class NotificationCreate(BaseModel):
    user_id: int
    title: str = Field(..., max_length=200)
    message: str
    type: Optional[str] = Field(None, max_length=50)
    link: Optional[str] = None


class NotificationResponse(BaseModel):
    id: int
    user_id: int
    title: str
    message: str
    type: Optional[str] = None
    link: Optional[str] = None
    is_read: bool
    created_at: datetime
    
    model_config = ConfigDict(from_attributes=True)


# ==================== SEARCH/FILTER SCHEMAS ====================

class TripSearchFilters(BaseModel):
    origin_city: Optional[str] = None
    destination_city: Optional[str] = None
    min_departure_date: Optional[datetime] = None
    max_departure_date: Optional[datetime] = None
    min_weight: Optional[float] = None
    max_price_per_kg: Optional[float] = None


class PaginationParams(BaseModel):
    skip: int = Field(0, ge=0)
    limit: int = Field(10, ge=1, le=100)


# ==================== MESSAGE SCHEMAS ====================

class MessageCreate(BaseModel):
    receiver_id: int
    content: str = Field(..., min_length=1, max_length=5000)


class MessageResponse(BaseModel):
    id: int
    conversation_id: str
    sender_id: int
    receiver_id: int
    content: str
    is_read: bool
    created_at: datetime
    
    model_config = ConfigDict(from_attributes=True)


class ConversationResponse(BaseModel):
    conversation_id: str
    other_user_id: int
    other_user_name: str
    other_user_email: str
    last_message: str
    last_message_time: datetime
    unread_count: int
    is_online: bool


# ==================== RESPONSE WRAPPERS ====================

class ListResponse(BaseModel):
    items: List[Any]
    total: int
    skip: int
    limit: int


class MessageResponseModel(BaseModel):
    message: str
    success: bool = True
