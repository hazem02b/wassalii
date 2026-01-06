"""
Application Configuration Settings
"""
from pydantic_settings import BaseSettings
from typing import List
from pathlib import Path

# Get the backend directory path
BACKEND_DIR = Path(__file__).parent.parent.parent


class Settings(BaseSettings):
    """Application settings"""
    
    # Project Info
    PROJECT_NAME: str = "Wassali API"
    VERSION: str = "1.0.0"
    API_V1_PREFIX: str = "/api/v1"
    DEBUG: bool = True
    
    # Database
    DATABASE_URL: str
    DATABASE_HOST: str = "localhost"
    DATABASE_PORT: int = 5432
    DATABASE_NAME: str = "wassali_db"
    DATABASE_USER: str = "wassali_user"
    DATABASE_PASSWORD: str = "wassali_password"
    
    # Security
    SECRET_KEY: str
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 480  # 8 heures pour les tests
    
    # CORS
    ALLOWED_ORIGINS: str = "*"
    
    def get_allowed_origins(self) -> List[str]:
        """Parse ALLOWED_ORIGINS string into list"""
        if self.ALLOWED_ORIGINS == "*":
            return ["*"]
        return [origin.strip() for origin in self.ALLOWED_ORIGINS.split(",")]
    
    # File Upload
    MAX_FILE_SIZE: int = 10485760  # 10MB
    UPLOAD_DIR: str = "./uploads"
    
    # Email Configuration (SMTP)
    SMTP_SERVER: str = "smtp.gmail.com"
    SMTP_PORT: int = 587
    SMTP_USERNAME: str = ""  # À configurer dans .env
    SMTP_PASSWORD: str = ""  # À configurer dans .env
    FROM_EMAIL: str = "noreply@wassali.com"
    FROM_NAME: str = "Wassali"
    
    # Twilio pour les appels/SMS (optionnel)
    TWILIO_ACCOUNT_SID: str = ""
    TWILIO_AUTH_TOKEN: str = ""
    TWILIO_PHONE_NUMBER: str = ""
    
    class Config:
        env_file = str(BACKEND_DIR / ".env")
        env_file_encoding = 'utf-8'
        case_sensitive = True
        extra = 'ignore'


settings = Settings()
