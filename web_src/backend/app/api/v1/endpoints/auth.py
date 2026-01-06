"""
Authentication and user management endpoints
"""
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from datetime import timedelta, datetime
import secrets

from app.db.database import get_db
from app.models.models import User
from app.schemas.schemas import (
    UserCreate, UserCreateSimple, UserLogin, UserResponse, UserUpdate,
    Token, PasswordChange, ForgotPasswordRequest, ResetPasswordRequest
)
from app.core.security import (
    verify_password, get_password_hash, create_access_token, decode_access_token
)
from app.core.config import settings
from app.core.email import email_service
from app.models.models import UserRole


router = APIRouter(prefix="/auth", tags=["Authentication"])
oauth2_scheme = OAuth2PasswordBearer(tokenUrl=f"{settings.API_V1_PREFIX}/auth/login")


async def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
) -> User:
    """Get current authenticated user"""
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    payload = decode_access_token(token)
    if payload is None:
        raise credentials_exception
    
    user_id_str: str = payload.get("sub")
    if user_id_str is None:
        raise credentials_exception
    
    try:
        user_id = int(user_id_str)
    except (ValueError, TypeError):
        raise credentials_exception
    
    user = db.query(User).filter(User.id == user_id).first()
    if user is None:
        raise credentials_exception
    
    return user


@router.post("/register", response_model=Token, status_code=status.HTTP_201_CREATED)
async def register(user_data: UserCreate, db: Session = Depends(get_db)):
    """Register a new user (generic endpoint)"""
    # Check if email already exists for this role
    existing_user = db.query(User).filter(
        User.email == user_data.email,
        User.role == user_data.role
    ).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Email already registered as {user_data.role}"
        )
    
    # Create new user
    user = User(
        email=user_data.email,
        phone=user_data.phone,
        name=user_data.name,
        role=user_data.role,
        password_hash=get_password_hash(user_data.password),
    )
    
    db.add(user)
    db.commit()
    db.refresh(user)
    
    # Envoyer email de bienvenue
    try:
        email_service.send_welcome_email(user.email, user.name)
    except Exception as e:
        print(f"Erreur envoi email bienvenue: {e}")
    
    # Create access token
    access_token = create_access_token(data={"sub": str(user.id)})
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": user,
    }


@router.post("/register/client", response_model=Token, status_code=status.HTTP_201_CREATED)
async def register_client(user_data: UserCreateSimple, db: Session = Depends(get_db)):
    """Register a new client"""
    
    # Check if email already exists for client role
    existing_user = db.query(User).filter(
        User.email == user_data.email,
        User.role == UserRole.CLIENT
    ).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered as client"
        )
    
    # Create new client user
    user = User(
        email=user_data.email,
        phone=user_data.phone,
        name=user_data.name,
        role=UserRole.CLIENT,
        password_hash=get_password_hash(user_data.password),
    )
    
    db.add(user)
    db.commit()
    db.refresh(user)
    
    # Envoyer email de bienvenue
    try:
        email_service.send_welcome_email(user.email, user.name)
    except Exception as e:
        print(f"Erreur envoi email bienvenue: {e}")
    
    # Create access token
    access_token = create_access_token(data={"sub": str(user.id)})
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": user,
    }


@router.post("/register/transporter", response_model=Token, status_code=status.HTTP_201_CREATED)
async def register_transporter(user_data: UserCreateSimple, db: Session = Depends(get_db)):
    """Register a new transporter"""
    
    # Check if email already exists for transporter role
    existing_user = db.query(User).filter(
        User.email == user_data.email,
        User.role == UserRole.TRANSPORTER
    ).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered as transporter"
        )
    
    # Create new transporter user
    user = User(
        email=user_data.email,
        phone=user_data.phone,
        name=user_data.name,
        role=UserRole.TRANSPORTER,
        password_hash=get_password_hash(user_data.password),
    )
    
    db.add(user)
    db.commit()
    db.refresh(user)
    
    # Envoyer email de bienvenue
    try:
        email_service.send_welcome_email(user.email, user.name)
    except Exception as e:
        print(f"Erreur envoi email bienvenue: {e}")
    
    # Create access token
    access_token = create_access_token(data={"sub": str(user.id)})
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": user,
    }


@router.post("/login", response_model=Token)
async def login(
    login_data: UserLogin,
    db: Session = Depends(get_db)
):
    """Login user with email, password and role"""
    try:
        # Normaliser le rôle en majuscule pour l'enum SQLAlchemy
        role_normalized = login_data.role.upper()
        print(f"==== LOGIN ATTEMPT START ====")
        print(f"Login attempt: {login_data.email} with role {login_data.role} (normalized: {role_normalized})")
    
        # Try finding user by email first to debug
        user_by_email = db.query(User).filter(User.email == login_data.email).first()
        if user_by_email:
            print(f"User found by email: {user_by_email.email}, Role in DB: {user_by_email.role}, Requested Role: {login_data.role}")
            print(f"Role match? {user_by_email.role == role_normalized}")
            print(f"Role types: DB={type(user_by_email.role)}, Req={type(role_normalized)}")
    
        user = db.query(User).filter(
            User.email == login_data.email,
            User.role == role_normalized
        ).first()
        
        if user:
            print(f"User found: {user.email}, Role: {user.role}")
            print(f"Password verify: {verify_password(login_data.password, user.password_hash)}")
        else:
            print("User not found with this email/role combination")
        
        if not user or not verify_password(login_data.password, user.password_hash):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail=f"Incorrect email or password for {login_data.role} account",
                headers={"WWW-Authenticate": "Bearer"},
            )
        
        if not user.is_active:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Account is inactive"
            )
        
        # Create access token
        access_token = create_access_token(data={"sub": str(user.id)})
        
        print(f"==== LOGIN SUCCESS ====")
        return {
            "access_token": access_token,
            "token_type": "bearer",
            "user": user,
        }
    except HTTPException:
        # Re-raise HTTP exceptions as-is
        raise
    except Exception as e:
        print(f"==== LOGIN ERROR ====")
        print(f"Error type: {type(e).__name__}")
        print(f"Error message: {str(e)}")
        import traceback
        print(f"Traceback:\n{traceback.format_exc()}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Internal server error during login: {str(e)}"
        )


# Endpoint de login OAuth2 pour compatibilité (utilisé par Swagger/docs)
@router.post("/login/oauth2", response_model=Token, include_in_schema=False)
async def login_oauth2(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db)
):
    """Login user with OAuth2 form (for Swagger docs only)"""
    # Find user by email (username field in form) - prioritize client role
    user = db.query(User).filter(User.email == form_data.username).first()
    
    if not user or not verify_password(form_data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Account is inactive"
        )
    
    # Create access token
    access_token = create_access_token(data={"sub": str(user.id)})
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": user,
    }


@router.get("/me", response_model=UserResponse)
async def get_current_user_info(current_user: User = Depends(get_current_user)):
    """Get current user information"""
    return current_user


@router.put("/me", response_model=UserResponse)
async def update_current_user(
    user_data: UserUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Update current user information"""
    # Check if phone is being updated and if it's already taken by another user
    if user_data.phone and user_data.phone != current_user.phone:
        existing_phone = db.query(User).filter(
            User.phone == user_data.phone,
            User.id != current_user.id
        ).first()
        if existing_phone:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Phone number already registered"
            )
    
    # Update fields
    if user_data.name:
        current_user.name = user_data.name
    if user_data.phone:
        current_user.phone = user_data.phone
    if user_data.avatar_url is not None:
        current_user.avatar_url = user_data.avatar_url
    if user_data.address is not None:
        current_user.address = user_data.address
    
    try:
        db.commit()
        db.refresh(current_user)
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error updating profile: {str(e)}"
        )
    
    return current_user


@router.get("/users/{user_id}", response_model=UserResponse)
async def get_user(user_id: int, db: Session = Depends(get_db)):
    """Get user by ID"""
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    return user


@router.put("/change-password")
async def change_password(
    password_data: PasswordChange,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Change user password"""
    # Verify current password
    if not verify_password(password_data.current_password, current_user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Current password is incorrect"
        )
    
    # Update password
    current_user.password_hash = get_password_hash(password_data.new_password)
    
    try:
        db.commit()
        db.refresh(current_user)
        
        # Envoyer email de confirmation
        try:
            email_service.send_password_changed(current_user.email, current_user.name)
        except Exception as e:
            print(f"Erreur envoi email changement mot de passe: {e}")
            
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error updating password: {str(e)}"
        )
    
    return {"message": "Password updated successfully"}


@router.post("/forgot-password")
async def forgot_password(
    request: ForgotPasswordRequest,
    db: Session = Depends(get_db)
):
    """Send password reset code to user email"""
    # Find user by email and role
    user = db.query(User).filter(
        User.email == request.email,
        User.role == request.role
    ).first()
    
    if not user:
        # For security, return success even if user doesn't exist
        return {"message": "If the email exists, a reset code has been sent"}
    
    # Generate 6-digit reset code
    reset_code = ''.join([str(secrets.randbelow(10)) for _ in range(6)])
    
    # Save code with 15 minutes expiration
    user.reset_code = reset_code
    user.reset_code_expires = datetime.utcnow() + timedelta(minutes=15)
    
    try:
        db.commit()
        
        # Send email with reset code
        try:
            email_service.send_password_reset(user.email, user.name, reset_code)
        except Exception as e:
            print(f"Erreur envoi email reset: {e}")
            
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error generating reset code: {str(e)}"
        )
    
    return {"message": "If the email exists, a reset code has been sent"}


@router.post("/reset-password")
async def reset_password(
    request: ResetPasswordRequest,
    db: Session = Depends(get_db)
):
    """Reset password using code sent to email"""
    # Find user by email and role
    user = db.query(User).filter(
        User.email == request.email,
        User.role == request.role
    ).first()
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid reset code or email"
        )
    
    # Check if reset code exists and matches
    if not user.reset_code or user.reset_code != request.reset_code:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid reset code"
        )
    
    # Check if code is expired
    if not user.reset_code_expires or user.reset_code_expires < datetime.utcnow():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Reset code has expired"
        )
    
    # Update password and clear reset code
    user.password_hash = get_password_hash(request.new_password)
    user.reset_code = None
    user.reset_code_expires = None
    
    try:
        db.commit()
        db.refresh(user)
        
        # Send confirmation email
        try:
            email_service.send_password_changed(user.email, user.name)
        except Exception as e:
            print(f"Erreur envoi email confirmation: {e}")
            
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error resetting password: {str(e)}"
        )
    
    return {"message": "Password reset successfully"}

