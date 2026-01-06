"""
Wassali API - Main Application Entry Point
FastAPI backend for Wassali parcel delivery application
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from app.core.config import settings
from app.db.database import engine, Base
from app.api.v1.api import api_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan events"""
    # Startup
    print("Starting Wassali API...")
    print(f"Database URL: {settings.DATABASE_URL}")
    
    # Create tables
    Base.metadata.create_all(bind=engine)
    print("Database tables created")
    
    yield
    
    # Shutdown
    print("Shutting down Wassali API...")


# Initialize FastAPI app
app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="API backend pour l'application Wassali - Livraison de colis Tunisie-Europe",
    docs_url=f"{settings.API_V1_PREFIX}/docs",
    redoc_url=f"{settings.API_V1_PREFIX}/redoc",
    openapi_url=f"{settings.API_V1_PREFIX}/openapi.json",
    lifespan=lifespan,
)

# Configure CORS - Allow all origins for development
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Permet toutes les origines en dev
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"],
    allow_headers=["*"],
    expose_headers=["*"],
    max_age=3600,
)

# Add request logging middleware
@app.middleware("http")
async def log_requests(request, call_next):
    print(f"📨 Incoming request: {request.method} {request.url}")
    print(f"   Origin: {request.headers.get('origin', 'N/A')}")
    response = await call_next(request)
    print(f"✅ Response status: {response.status_code}")
    return response

# Include API router

print("[DEBUG] Inclusion du api_router dans FastAPI...")
app.include_router(api_router, prefix=settings.API_V1_PREFIX)
print("[DEBUG] api_router inclus avec succès !")


@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "🚀 Bienvenue sur l'API Wassali",
        "version": settings.VERSION,
        "docs": f"{settings.API_V1_PREFIX}/docs",
    }


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "service": settings.PROJECT_NAME,
        "version": settings.VERSION,
    }


if __name__ == "__main__":
    import uvicorn
    
    uvicorn.run(
        app,
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info",
    )
