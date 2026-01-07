# 🎓 SCRIPT DE PRÉSENTATION - Projet Wassali
## Guide complet pour présentation devant le professeur

**Durée estimée** : 15-20 minutes  
**Date** : 5 Janvier 2026

---

## 📋 PLAN DE PRÉSENTATION

1. **Introduction** (2 min)
2. **Architecture globale** (3 min)
3. **Backend - APIs et logique métier** (5 min)
4. **Frontend - Interface utilisateur** (5 min)
5. **Démonstration en direct** (5 min)

---

# PARTIE 1 : INTRODUCTION (2 minutes)

## 🎯 Présentation du projet

**"Bonjour Professeur, je vais vous présenter Wassali, une application complète de livraison de colis entre la Tunisie et l'Europe."**

### Problématique
- Les Tunisiens en Europe ont besoin d'envoyer des colis en Tunisie
- Les transporteurs font régulièrement des trajets Europe-Tunisie
- **Solution** : Connecter clients et transporteurs via une plateforme mobile

### Technologies utilisées
- **Frontend Mobile** : Flutter (Dart) - Cross-platform iOS/Android
- **Backend API** : FastAPI (Python) - Haute performance
- **Base de données** : SQLite (dev) / PostgreSQL (production)
- **Déploiement** : Render.com (backend) + APK Android
- **Architecture** : REST API avec authentification JWT

### Fonctionnalités principales
- ✅ Inscription/Connexion sécurisée (2 types : Client et Transporteur)
- ✅ Gestion de profils avec photos
- ✅ Système de réservation de colis
- ✅ Gestion de trajets pour transporteurs
- ✅ Messagerie en temps réel
- ✅ Système de paiement
- ✅ Notifications et historique

---

# PARTIE 2 : ARCHITECTURE GLOBALE (3 minutes)

## 🏗️ Architecture du système

**"Le projet suit une architecture client-serveur moderne avec séparation des responsabilités."**

### Schéma architectural

```
┌─────────────────────────────────────────────┐
│         APPLICATION MOBILE (Flutter)         │
│  ┌──────────────┐      ┌──────────────┐    │
│  │   Client     │      │ Transporteur │    │
│  │  Interface   │      │  Interface   │    │
│  └──────────────┘      └──────────────┘    │
│           │                    │             │
│           └────────┬───────────┘             │
└────────────────────┼─────────────────────────┘
                     │ HTTP/REST API (JSON)
                     ▼
┌─────────────────────────────────────────────┐
│          BACKEND API (FastAPI)              │
│                                              │
│  ┌──────────────────────────────────────┐  │
│  │      Couche de routage (Routes)      │  │
│  └──────────────────────────────────────┘  │
│               │                              │
│  ┌──────────────────────────────────────┐  │
│  │   Logique métier (Controllers)       │  │
│  │   - Authentification JWT             │  │
│  │   - Gestion utilisateurs             │  │
│  │   - Gestion réservations             │  │
│  │   - Gestion trajets                  │  │
│  └──────────────────────────────────────┘  │
│               │                              │
│  ┌──────────────────────────────────────┐  │
│  │    Accès données (Models ORM)        │  │
│  └──────────────────────────────────────┘  │
└──────────────────┼──────────────────────────┘
                   │
                   ▼
         ┌─────────────────┐
         │  BASE DE DONNÉES │
         │    SQLite/       │
         │   PostgreSQL     │
         └─────────────────┘
```

### Points clés de l'architecture

1. **Séparation frontend/backend**
   - Frontend : 100% indépendant, consomme l'API
   - Backend : API REST pure, répond en JSON
   - Communication via HTTP/HTTPS

2. **Sécurité**
   - Authentification JWT (JSON Web Tokens)
   - Hashage des mots de passe (bcrypt)
   - CORS configuré pour mobile

3. **Scalabilité**
   - API stateless (sans état côté serveur)
   - Base de données relationnelle
   - Déploiement cloud ready

---

# PARTIE 3 : BACKEND - APIs et Logique Métier (7-8 minutes)

## 🔧 Structure du Backend

**"Le backend est organisé en modules selon le principe de séparation des responsabilités. Chaque dossier a un rôle précis dans l'architecture."**

### Organisation complète des dossiers

```
web_src/
└── backend/
    ├── main.py              # 🚀 Point d'entrée de l'application
    ├── requirements.txt     # 📦 Dépendances Python
    ├── .env                 # 🔐 Variables d'environnement (secrets)
    │
    └── app/
        ├── __init__.py      # Package Python
        │
        ├── core/            # 🎯 CONFIGURATION & SÉCURITÉ
        │   ├── __init__.py
        │   ├── config.py    # Configuration globale de l'app
        │   └── security.py  # Fonctions de sécurité (JWT, hashage)
        │
        ├── db/              # 💾 BASE DE DONNÉES
        │   ├── __init__.py
        │   ├── database.py  # Connexion SQLAlchemy + Session
        │   ├── models.py    # Modèles ORM (tables)
        │   └── init_db.py   # Script d'initialisation DB
        │
        ├── schemas/         # ✅ VALIDATION DES DONNÉES (Pydantic)
        │   ├── __init__.py
        │   ├── user.py      # Schémas utilisateurs
        │   ├── booking.py   # Schémas réservations
        │   ├── trip.py      # Schémas trajets
        │   ├── message.py   # Schémas messagerie
        │   └── token.py     # Schémas tokens JWT
        │
        ├── api/             # 🌐 ROUTES & ENDPOINTS
        │   ├── __init__.py
        │   ├── deps.py      # Dépendances communes (authentification)
        │   │
        │   └── v1/          # Version 1 de l'API
        │       ├── __init__.py
        │       ├── auth.py     # Authentification (login, register)
        │       ├── users.py    # Gestion utilisateurs
        │       ├── bookings.py # Gestion réservations
        │       ├── trips.py    # Gestion trajets
        │       ├── messages.py # Messagerie
        │       └── notifications.py # Notifications
        │
        └── utils/           # 🛠️ UTILITAIRES
            ├── __init__.py
            ├── email.py     # Envoi d'emails
            └── helpers.py   # Fonctions helpers
```

### Explication détaillée de chaque dossier

#### 📁 **1. Dossier racine `backend/`**

**Ce dossier contient les fichiers principaux qui lancent l'application backend.**

**`main.py`** - Le cœur de l'application

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le fichier main.py est le point d'entrée de notre application backend. C'est ici que nous créons l'instance FastAPI, configurons tous les middlewares (CORS pour accepter les requêtes depuis l'application mobile), incluons toutes les routes API (auth, users, bookings, trips), et configurons la création automatique des tables de base de données au démarrage. Ce fichier orchestre toute l'application en reliant les différents modules entre eux."

**RÔLE TECHNIQUE :**
- Création de l'application FastAPI avec titre, description et version
- Configuration du CORS pour accepter les requêtes depuis l'app mobile
- Inclusion de tous les routers (auth, users, bookings, trips, messages)
- Event handler "startup" qui crée les tables DB au démarrage
- Endpoint `/health` pour vérifier que le serveur fonctionne
- Point de lancement avec uvicorn (serveur ASGI haute performance)

**CODE COMPLET :**
```python
from fastapi import FastAPI
from app.api.v1 import auth, users, bookings, trips
from app.db.database import engine, Base
from app.core.config import settings

# Création de l'application FastAPI
app = FastAPI(
    title="Wassali API",
    description="API de livraison de colis",
    version="1.0.0"
)

# Création des tables en base de données
@app.on_event("startup")
def startup():
    Base.metadata.create_all(bind=engine)

# Inclusion des routes
app.include_router(auth.router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(users.router, prefix="/api/v1/users", tags=["users"])
app.include_router(bookings.router, prefix="/api/v1/bookings", tags=["bookings"])
app.include_router(trips.router, prefix="/api/v1/trips", tags=["trips"])

# Endpoint de santé
@app.get("/health")
def health_check():
    return {"status": "ok", "message": "Backend is running"}
```

**`requirements.txt`** - Dépendances Python

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le fichier requirements.txt liste toutes les bibliothèques Python nécessaires au fonctionnement du backend. Chaque ligne représente une dépendance avec sa version spécifique. Nous avons FastAPI comme framework web, Uvicorn comme serveur ASGI, SQLAlchemy pour l'ORM (Object-Relational Mapping) qui nous permet de manipuler la base de données avec des objets Python au lieu de SQL brut, Pydantic pour la validation automatique des données, python-jose pour la gestion des tokens JWT, et passlib pour le hashage sécurisé des mots de passe avec l'algorithme bcrypt."

**LISTE DES DÉPENDANCES :**
```
fastapi==0.104.1        # Framework web moderne
uvicorn==0.24.0         # Serveur ASGI
sqlalchemy==2.0.23      # ORM base de données
pydantic==2.5.0         # Validation de données
python-jose[cryptography]==3.3.0  # JWT tokens
passlib[bcrypt]==1.7.4  # Hashage mots de passe
python-multipart==0.0.6 # Upload de fichiers
```

#### 📁 **2. Dossier `app/core/` - Configuration & Sécurité**

**DESCRIPTION DU DOSSIER À DIRE AU PROFESSEUR :**
> "Le dossier core contient tous les éléments de configuration et de sécurité de l'application. C'est le cerveau de notre backend. Ici nous définissons les paramètres globaux (URL de base de données, clés secrètes, durée d'expiration des tokens), et toutes les fonctions de sécurité critiques comme le hashage des mots de passe et la gestion des tokens JWT. Ce dossier est essentiel car il centralise toute la logique de sécurité, ce qui facilite la maintenance et évite la duplication de code."

**RÔLE DU DOSSIER :**
- Centralisation de la configuration (un seul endroit pour tous les paramètres)
- Gestion de la sécurité (JWT, hashage, secrets)
- Utilisation de variables d'environnement pour les secrets (ne jamais exposer les clés dans le code)
- Configuration flexible (dev/production)

---

**`config.py`** - Configuration de l'application

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le fichier config.py utilise Pydantic Settings pour gérer la configuration de l'application. Nous définissons une classe Settings qui charge automatiquement les variables d'environnement depuis le fichier .env. Cela inclut l'URL de la base de données (SQLite en développement, PostgreSQL en production), la clé secrète pour signer les tokens JWT, l'algorithme de cryptage (HS256), la durée d'expiration des tokens (8 heures), et les origines autorisées pour CORS. Cette approche permet de changer facilement la configuration entre développement et production sans modifier le code."
```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    # Base de données
    DATABASE_URL: str = "sqlite:///./wassali.db"
    
    # Sécurité
    SECRET_KEY: str  # Clé pour JWT (depuis .env)
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_HOURS: int = 8
    
    # CORS
    ALLOWED_ORIGINS: list = ["*"]
    
    # Email (si configuré)
    SMTP_HOST: str = ""
    SMTP_PORT: int = 587
    
    class Config:
        env_file = ".env"

settings = Settings()
```

**`security.py`** - Fonctions de sécurité

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le fichier security.py contient toutes les fonctions liées à la sécurité de l'application. Il y a quatre fonctions principales : hash_password() qui transforme un mot de passe en clair en un hash bcrypt impossible à décrypter (algorithme à sens unique avec sel aléatoire), verify_password() qui compare un mot de passe saisi avec le hash stocké, create_access_token() qui génère un token JWT signé contenant les informations utilisateur avec une date d'expiration, et decode_token() qui vérifie la validité d'un token et extrait les données. Ces fonctions sont utilisées partout dans l'application pour garantir que les mots de passe ne sont jamais stockés en clair et que l'authentification est sécurisée."

**FONCTIONS IMPLÉMENTÉES :**
1. **hash_password()** : Transforme mot de passe → hash bcrypt (stocké en DB)
2. **verify_password()** : Compare mot de passe saisi avec hash (lors du login)
3. **create_access_token()** : Génère JWT avec expiration (après login réussi)
4. **decode_token()** : Vérifie et décode JWT (pour chaque requête authentifiée)

**SÉCURITÉ :**
- Bcrypt utilise un "sel" aléatoire (chaque hash est unique même pour le même mot de passe)
- JWT signé avec clé secrète (impossible de modifier sans invalider la signature)
- Token expire après 8 heures (limite l'exposition en cas de vol)

**CODE COMPLET :**
```python
from passlib.context import CryptContext
from jose import JWTError, jwt
from datetime import datetime, timedelta

# Contexte pour hashage bcrypt
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str) -> str:
    """Hash un mot de passe avec bcrypt"""
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Vérifie un mot de passe"""
    return pwd_context.verify(plain_password, hashed_password)

def create_access_token(data: dict) -> str:
    """Crée un JWT token"""
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(hours=8)
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, settings.SECRET_KEY, algorithm="HS256")

def decode_token(token: str) -> dict:
    """Décode un JWT token"""
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=["HS256"])
        return payload
    except JWTError:
        return None
```

#### 📁 **3. Dossier `app/db/` - Base de données**

**DESCRIPTION DU DOSSIER À DIRE AU PROFESSEUR :**
> "Le dossier db contient tout ce qui concerne la base de données. C'est ici que nous définissons la connexion à la base de données avec SQLAlchemy, les modèles ORM qui représentent nos tables (User, Trip, Booking, Message), et les scripts d'initialisation. SQLAlchemy est un ORM (Object-Relational Mapping) qui nous permet d'interagir avec la base de données en utilisant des objets Python au lieu d'écrire du SQL brut. Chaque classe Python devient une table, chaque attribut devient une colonne, et les relations entre tables sont gérées automatiquement."

**RÔLE DU DOSSIER :**
- Gestion de la connexion à la base de données (engine, session)
- Définition des modèles ORM (tables et relations)
- Migrations et initialisation de la base de données
- Abstraction SQL → Python (plus sûr, plus maintenable)

**AVANTAGES DE L'ORM :**
- Pas de SQL brut (moins d'erreurs)
- Protection automatique contre les injections SQL
- Code Python lisible et maintenable
- Changement de DB facile (SQLite → PostgreSQL)
- Relations automatiques (jointures, clés étrangères)

---

**`database.py`** - Connexion à la base de données

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le fichier database.py configure la connexion à la base de données avec SQLAlchemy. Nous créons un engine qui représente la connexion physique à la base de données, un SessionLocal qui est une factory pour créer des sessions (transactions), et une Base qui sert de classe mère pour tous nos modèles ORM. La fonction get_db() est une dépendance FastAPI qui fournit une session de base de données à chaque endpoint, et garantit qu'elle est fermée après utilisation (gestion automatique des transactions)."
```python
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from app.core.config import settings

# Création du moteur SQLAlchemy
engine = create_engine(
    settings.DATABASE_URL,
    connect_args={"check_same_thread": False}  # Pour SQLite
)

# Session pour les requêtes
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base pour les modèles ORM
Base = declarative_base()

# Dependency pour obtenir une session DB
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```

**`models.py`** - Modèles ORM (Tables de la base de données)

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le fichier models.py contient les définitions de nos tables de base de données sous forme de classes Python. Chaque classe hérite de Base et représente une table. Les attributs de classe deviennent des colonnes avec leur type (Integer, String, Float, DateTime, Enum). Nous utilisons des Column pour définir chaque colonne avec ses contraintes (primary_key, unique, nullable, default). Les relations entre tables sont définies avec relationship() et ForeignKey. Par exemple, un User peut avoir plusieurs Bookings (relation one-to-many), et un Trip appartient à un Transporter (relation many-to-one). SQLAlchemy gère automatiquement les jointures et la cohérence des données."

**TABLES IMPLÉMENTÉES :**
1. **User** : Stocke tous les utilisateurs (clients et transporteurs)
2. **Trip** : Stocke les trajets créés par les transporteurs
3. **Booking** : Stocke les réservations faites par les clients
4. **Message** : Stocke les messages de la messagerie (optionnel)
5. **Notification** : Stocke les notifications (optionnel)

**RELATIONS ENTRE TABLES :**
- User (1) → Trips (N) : Un transporteur peut avoir plusieurs trajets
- User (1) → Bookings (N) : Un client peut avoir plusieurs réservations
- Trip (1) → Bookings (N) : Un trajet peut avoir plusieurs réservations
- User (1) → Messages (N) : Un utilisateur peut envoyer plusieurs messages

**TYPES DE DONNÉES UTILISÉS :**
- Integer : ID, nombres entiers
- String : textes (email, nom, ville)
- Float : nombres décimaux (poids, prix)
- DateTime : dates et heures
- Boolean : vrai/faux (is_active)
- Enum : choix limités (role : CLIENT/TRANSPORTEUR, status)

**CODE COMPLET DES MODÈLES :**
```python
from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship
from datetime import datetime
from app.db.database import Base
import enum

class UserRole(enum.Enum):
    CLIENT = "CLIENT"
    TRANSPORTEUR = "TRANSPORTEUR"

class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    full_name = Column(String, nullable=False)
    phone_number = Column(String)
    role = Column(Enum(UserRole), nullable=False)
    profile_photo = Column(String)  # URL de la photo
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relations
    bookings = relationship("Booking", back_populates="client")
    trips = relationship("Trip", back_populates="transporter")

class Trip(Base):
    __tablename__ = "trips"
    
    id = Column(Integer, primary_key=True, index=True)
    transporter_id = Column(Integer, ForeignKey("users.id"))
    departure_city = Column(String, nullable=False)
    arrival_city = Column(String, nullable=False)
    departure_date = Column(DateTime, nullable=False)
    arrival_date = Column(DateTime)
    available_weight = Column(Float, nullable=False)  # en kg
    price_per_kg = Column(Float, nullable=False)
    status = Column(String, default="DISPONIBLE")  # DISPONIBLE, COMPLET, TERMINÉ
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relations
    transporter = relationship("User", back_populates="trips")
    bookings = relationship("Booking", back_populates="trip")

class Booking(Base):
    __tablename__ = "bookings"
    
    id = Column(Integer, primary_key=True, index=True)
    client_id = Column(Integer, ForeignKey("users.id"))
    trip_id = Column(Integer, ForeignKey("trips.id"))
    description = Column(String)
    weight = Column(Float, nullable=False)
    pickup_address = Column(String, nullable=False)
    delivery_address = Column(String, nullable=False)
    total_price = Column(Float, nullable=False)
    status = Column(String, default="EN_ATTENTE")  # EN_ATTENTE, ACCEPTÉE, REFUSÉE, TERMINÉE
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relations
    client = relationship("User", back_populates="bookings")
    trip = relationship("Trip", back_populates="bookings")
```

#### 📁 **4. Dossier `app/schemas/` - Validation Pydantic**

**DESCRIPTION DU DOSSIER À DIRE AU PROFESSEUR :**
> "Le dossier schemas contient les schémas Pydantic qui valident les données entrantes et sortantes de l'API. C'est une couche de validation automatique entre le client (Flutter) et la base de données. Quand un utilisateur envoie des données (par exemple pour s'inscrire), Pydantic vérifie automatiquement que tous les champs obligatoires sont présents, que les types sont corrects (email valide, nombre positif), et que les contraintes sont respectées. Si une donnée est invalide, une erreur 422 est retournée automatiquement avec un message explicite. Cela protège la base de données et évite les erreurs."

**RÔLE DU DOSSIER :**
- Validation automatique des données (types, contraintes)
- Séparation des données entrées/sorties (UserCreate vs UserResponse)
- Documentation automatique (Swagger utilise ces schémas)
- Sérialisation JSON ↔ Python
- Sécurité : jamais de mots de passe dans les réponses

**TYPES DE SCHÉMAS :**
- **Create** : Données pour créer (ex: UserCreate avec password)
- **Update** : Données pour modifier (ex: UserUpdate, champs optionnels)
- **Response** : Données retournées (ex: UserResponse sans password)
- **InDB** : Données telles qu'en base (avec ID, dates)

**POURQUOI SÉPARER LES SCHÉMAS ?**
- Sécurité : Ne jamais renvoyer les mots de passe hashés
- Flexibilité : Certains champs en lecture seule (created_at, id)
- Validation différente : Create exige password, Update non

---

**"Les schémas Pydantic valident automatiquement les données entrantes et sortantes"**

**`user.py`** - Schémas utilisateurs

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le fichier user.py définit trois schémas pour les utilisateurs : UserCreate pour l'inscription (contient le mot de passe en clair qui sera hashé), UserResponse pour les réponses API (sans mot de passe, avec ID et dates), et UserUpdate pour modifier le profil (tous les champs optionnels). EmailStr valide automatiquement le format email, Optional permet des champs facultatifs, et from_attributes=True permet de convertir automatiquement un modèle ORM en schéma Pydantic."
```python
from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime

# Schéma pour créer un utilisateur
class UserCreate(BaseModel):
    email: EmailStr  # Validation email automatique
    password: str
    full_name: str
    phone_number: Optional[str] = None
    role: str  # "CLIENT" ou "TRANSPORTEUR"

# Schéma pour la réponse (sans mot de passe)
class UserResponse(BaseModel):
    id: int
    email: str
    full_name: str
    phone_number: Optional[str]
    role: str
    profile_photo: Optional[str]
    created_at: datetime
    
    class Config:
        from_attributes = True  # Pour convertir depuis ORM

# Schéma pour mise à jour profil
class UserUpdate(BaseModel):
    full_name: Optional[str] = None
    phone_number: Optional[str] = None
    profile_photo: Optional[str] = None
```

**`booking.py`** - Schémas réservations

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le fichier booking.py définit les schémas pour les réservations. BookingCreate contient les données nécessaires pour créer une réservation : l'ID du trajet, la description du colis, le poids (validé comme float positif), les adresses de ramassage et livraison. Le backend calculera automatiquement le total_price en multipliant le poids par le prix au kg du trajet. BookingResponse contient toutes les informations de la réservation y compris l'ID, le status, et les dates, pour les réponses API."

**CODE COMPLET :**
```python
class BookingCreate(BaseModel):
    trip_id: int
    description: str
    weight: float  # en kg
    pickup_address: str
    delivery_address: str

class BookingResponse(BaseModel):
    id: int
    client_id: int
    trip_id: int
    description: str
    weight: float
    pickup_address: str
    delivery_address: str
    total_price: float
    status: str
    created_at: datetime
    
    class Config:
        from_attributes = True
```

#### 📁 **5. Dossier `app/api/v1/` - Routes & Endpoints**

**DESCRIPTION DU DOSSIER À DIRE AU PROFESSEUR :**
> "Le dossier api/v1 contient tous les endpoints de l'API organisés par ressource. Chaque fichier (auth.py, users.py, bookings.py, trips.py) définit un router FastAPI avec ses endpoints associés. Un endpoint est une URL que l'application mobile peut appeler pour effectuer une action : POST /auth/login pour se connecter, GET /bookings pour récupérer les réservations, etc. Nous utilisons le versioning (v1) pour pouvoir faire évoluer l'API sans casser la compatibilité avec les anciennes versions de l'app mobile."

**RÔLE DU DOSSIER :**
- Définition de tous les endpoints HTTP (GET, POST, PUT, DELETE)
- Gestion des requêtes et réponses
- Appel de la logique métier
- Gestion des erreurs HTTP
- Documentation automatique Swagger

**ORGANISATION PAR RESSOURCE :**
- **auth.py** : Authentification (login, register, forgot password)
- **users.py** : Gestion utilisateurs (profil, update, avatar)
- **bookings.py** : Gestion réservations (CRUD complet)
- **trips.py** : Gestion trajets (CRUD complet)
- **messages.py** : Messagerie entre utilisateurs
- **notifications.py** : Notifications push

**MÉTHODES HTTP UTILISÉES :**
- **GET** : Récupérer des données (lecture)
- **POST** : Créer une ressource (insertion)
- **PUT** : Modifier une ressource (mise à jour)
- **DELETE** : Supprimer une ressource

---

**`deps.py`** - Dépendances communes

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le fichier deps.py contient les dépendances partagées par plusieurs endpoints. La plus importante est get_current_user() qui extrait le token JWT de l'en-tête Authorization, le décode, et retourne l'utilisateur connecté. Cette fonction est utilisée comme dépendance dans tous les endpoints protégés : si le token est invalide ou absent, une erreur 401 Unauthorized est automatiquement retournée. Cela évite de dupliquer le code d'authentification dans chaque endpoint."

**FONCTIONNALITÉS :**
- OAuth2PasswordBearer : Schéma d'authentification standard
- Extraction du token depuis l'en-tête HTTP
- Décodage et validation du JWT
- Récupération de l'utilisateur depuis la DB
- Gestion automatique des erreurs 401

**UTILISATION DANS LES ENDPOINTS :**
```python
@router.get("/profile")
def get_profile(current_user: User = Depends(get_current_user)):
    # current_user est automatiquement injecté et vérifié
    return current_user
```

**CODE COMPLET :**
```python
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from app.core.security import decode_token
from app.db.database import get_db
from sqlalchemy.orm import Session

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")

def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    """Récupère l'utilisateur courant depuis le token JWT"""
    payload = decode_token(token)
    if not payload:
        raise HTTPException(status_code=401, detail="Token invalide")
    
    user_id = payload.get("user_id")
    user = db.query(User).filter(User.id == user_id).first()
    
    if not user:
        raise HTTPException(status_code=401, detail="Utilisateur non trouvé")
    
    return user
```

**`auth.py`** - Endpoints d'authentification

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le fichier auth.py contient tous les endpoints liés à l'authentification. Le endpoint POST /register permet à un nouvel utilisateur de créer un compte : nous vérifions que l'email n'existe pas déjà, hashons le mot de passe avec bcrypt, créons l'utilisateur en base de données, et retournons ses informations. Le endpoint POST /login vérifie les identifiants : nous cherchons l'utilisateur par email, comparons le mot de passe saisi avec le hash stocké, et si tout est correct, générons un token JWT valable 8 heures qui sera envoyé avec chaque requête suivante pour identifier l'utilisateur."

**ENDPOINTS IMPLÉMENTÉS :**
- **POST /auth/register** : Inscription
- **POST /auth/login** : Connexion
- **POST /auth/logout** : Déconnexion (côté client)
- **POST /auth/forgot-password** : Réinitialisation mot de passe

**LOGIQUE MÉTIER - REGISTER :**
1. Recevoir données (email, password, name, role)
2. Valider avec Pydantic (format email, etc.)
3. Vérifier que email n'existe pas déjà (SELECT)
4. Hasher le mot de passe avec bcrypt
5. Créer User en DB (INSERT)
6. Retourner User (sans password)

**LOGIQUE MÉTIER - LOGIN :**
1. Recevoir email + password
2. Chercher utilisateur par email (SELECT)
3. Si non trouvé → erreur 401
4. Comparer password avec hash stocké
5. Si incorrect → erreur 401
6. Générer JWT avec {user_id, role, exp}
7. Retourner {access_token, user}

**SÉCURITÉ :**
- Mots de passe jamais en clair
- Messages d'erreur volontairement vagues ("email ou mot de passe incorrect" et non "email n'existe pas")
- Token avec expiration
- Rate limiting possible (limiter tentatives de connexion)

**CODE COMPLET :**
```python
from fastapi import APIRouter, Depends, HTTPException
from app.schemas.user import UserCreate, UserResponse
from app.schemas.token import Token
from app.core.security import hash_password, verify_password, create_access_token

router = APIRouter()

@router.post("/register", response_model=UserResponse, status_code=201)
def register(user_data: UserCreate, db: Session = Depends(get_db)):
    """Inscription d'un nouvel utilisateur"""
    # Vérifier si email existe déjà
    existing_user = db.query(User).filter(User.email == user_data.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Email déjà utilisé")
    
    # Créer le nouvel utilisateur
    new_user = User(
        email=user_data.email,
        hashed_password=hash_password(user_data.password),
        full_name=user_data.full_name,
        phone_number=user_data.phone_number,
        role=user_data.role
    )
    
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    
    return new_user

@router.post("/login", response_model=Token)
def login(email: str, password: str, db: Session = Depends(get_db)):
    """Connexion utilisateur"""
    # Trouver l'utilisateur
    user = db.query(User).filter(User.email == email).first()
    if not user:
        raise HTTPException(status_code=401, detail="Email ou mot de passe incorrect")
    
    # Vérifier le mot de passe
    if not verify_password(password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Email ou mot de passe incorrect")
    
    # Créer le token JWT
    access_token = create_access_token({"user_id": user.id, "role": user.role})
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": user
    }
```

**`bookings.py`** - Endpoints réservations

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le fichier bookings.py gère tout le cycle de vie des réservations. POST /bookings permet à un client de créer une réservation : nous vérifions qu'il est bien un CLIENT (et non transporteur), que le trajet existe et a assez de poids disponible, calculons le prix total, créons la réservation avec status EN_ATTENTE, et déduisons le poids du trajet. GET /bookings retourne toutes les réservations de l'utilisateur connecté (client voit ses réservations, transporteur voit les demandes pour ses trajets). PUT /bookings/{id}/accept permet au transporteur d'accepter une réservation. Cette logique métier complexe est le cœur de l'application."

**ENDPOINTS IMPLÉMENTÉS :**
- **GET /bookings** : Liste des réservations (filtrées par utilisateur)
- **POST /bookings** : Créer une réservation
- **GET /bookings/{id}** : Détails d'une réservation
- **PUT /bookings/{id}/accept** : Accepter (transporteur)
- **PUT /bookings/{id}/reject** : Refuser (transporteur)
- **PUT /bookings/{id}/cancel** : Annuler (client)
- **PUT /bookings/{id}/complete** : Marquer terminée

**LOGIQUE MÉTIER - CRÉER UNE RÉSERVATION (COMPLEXE) :**
```
1. Vérifier authentification (JWT valide)
2. Vérifier que user.role == "CLIENT" (403 si transporteur)
3. Récupérer le Trip depuis la DB (404 si non trouvé)
4. Vérifier trip.status == "DISPONIBLE" (400 si COMPLET)
5. Vérifier trip.available_weight >= booking.weight (400 si insuffisant)
6. Calculer total_price = booking.weight * trip.price_per_kg
7. Créer Booking en DB avec status="EN_ATTENTE"
8. Déduire poids : trip.available_weight -= booking.weight
9. Si trip.available_weight == 0 : trip.status = "COMPLET"
10. Commit transaction (atomique : tout ou rien)
11. Envoyer notification au transporteur (optionnel)
12. Retourner la réservation créée (201 Created)
```

**RÈGLES MÉTIER :**
- Seuls les CLIENTS peuvent réserver
- Seuls les TRANSPORTEURS peuvent accepter/refuser
- Impossible de réserver plus que le poids disponible
- Prix calculé automatiquement (pas modifiable manuellement)
- Transaction atomique (si erreur, rien n'est modifié)

**GESTION DES ERREURS :**
- 401 : Non authentifié
- 403 : Pas les permissions (client essaie d'accepter)
- 404 : Trajet non trouvé
- 400 : Poids insuffisant, trajet complet, etc.

**CODE COMPLET :**
```python
@router.post("/", response_model=BookingResponse, status_code=201)
def create_booking(
    booking_data: BookingCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Créer une réservation (CLIENT uniquement)"""
    # Vérifier que l'utilisateur est un client
    if current_user.role != "CLIENT":
        raise HTTPException(status_code=403, detail="Seuls les clients peuvent réserver")
    
    # Récupérer le trajet
    trip = db.query(Trip).filter(Trip.id == booking_data.trip_id).first()
    if not trip:
        raise HTTPException(status_code=404, detail="Trajet non trouvé")
    
    # Vérifier disponibilité
    if trip.available_weight < booking_data.weight:
        raise HTTPException(status_code=400, detail="Poids demandé supérieur au poids disponible")
    
    # Calculer le prix
    total_price = booking_data.weight * trip.price_per_kg
    
    # Créer la réservation
    new_booking = Booking(
        client_id=current_user.id,
        trip_id=trip.id,
        description=booking_data.description,
        weight=booking_data.weight,
        pickup_address=booking_data.pickup_address,
        delivery_address=booking_data.delivery_address,
        total_price=total_price,
        status="EN_ATTENTE"
    )
    
    # Déduire le poids du trajet
    trip.available_weight -= booking_data.weight
    
    db.add(new_booking)
    db.commit()
    db.refresh(new_booking)
    
    return new_booking
```

### Modèles de données (ORM)

**"Voici les principaux modèles de la base de données :"**

#### 1. Modèle User (Utilisateur)
```python
class User:
    - id (clé primaire)
    - email (unique)
    - hashed_password
    - full_name
    - phone_number
    - role (CLIENT ou TRANSPORTEUR)
    - profile_photo
    - created_at
    - is_active
```

#### 2. Modèle Trip (Trajet pour transporteurs)
```python
class Trip:
    - id
    - transporter_id (clé étrangère → User)
    - departure_city
    - arrival_city
    - departure_date
    - arrival_date
    - available_weight (kg)
    - price_per_kg
    - status (DISPONIBLE, COMPLET, TERMINÉ)
```

#### 3. Modèle Booking (Réservation pour clients)
```python
class Booking:
    - id
    - client_id (clé étrangère → User)
    - trip_id (clé étrangère → Trip)
    - description
    - weight (kg)
    - pickup_address
    - delivery_address
    - total_price
    - status (EN_ATTENTE, ACCEPTÉE, REFUSÉE, TERMINÉE)
```

### 🔗 RELATIONS ENTRE LES COMPOSANTS DU BACKEND

**À DIRE AU PROFESSEUR :**
> "Il est essentiel de comprendre comment tous ces composants travaillent ensemble. Quand une requête HTTP arrive, elle suit un chemin précis à travers les différentes couches de l'application. Laissez-moi illustrer avec l'exemple concret d'une création de réservation."

**FLUX COMPLET D'UNE REQUÊTE : CRÉER UNE RÉSERVATION**

```
1️⃣ APPLICATION FLUTTER (Frontend)
   │
   ├─> L'utilisateur remplit le formulaire de réservation
   ├─> BookingService.createBooking() est appelé
   ├─> Dio envoie : POST https://wassali-backend.onrender.com/api/v1/bookings
   ├─> Headers: { "Authorization": "Bearer eyJhbGc...", "Content-Type": "application/json" }
   └─> Body: { "trip_id": 1, "weight": 5, "description": "...", ... }
   │
   │ HTTP/HTTPS
   ↓
2️⃣ SERVEUR FASTAPI (Backend - Point d'entrée)
   │
   ├─> Uvicorn reçoit la requête HTTP
   ├─> FastAPI route vers bookings.router
   └─> Trouve l'endpoint : @router.post("/")
   │
   ↓
3️⃣ MIDDLEWARES & DÉPENDANCES
   │
   ├─> CORS : Vérifie que l'origine est autorisée
   ├─> Pydantic : Valide le body JSON avec BookingCreate schema
   │   └─> Si invalide → 400 Bad Request
   ├─> Depends(get_db) : Crée une session de base de données
   └─> Depends(get_current_user) :
       │
       ├─> Extrait le token JWT de l'en-tête Authorization
       ├─> Appelle security.decode_token(token)
       ├─> Vérifie la signature et l'expiration
       ├──> Si invalide → 401 Unauthorized
       ├─> Récupère user_id du payload
       ├─> SELECT * FROM users WHERE id = user_id
       └─> Retourne l'objet User
   │
   ↓
4️⃣ ENDPOINT FUNCTION (Logique métier)
   │
   ├─> def create_booking(booking_data, db, current_user):
   │
   ├─> ✅ Vérification : current_user.role == "CLIENT"
   │   └─> Si TRANSPORTEUR → 403 Forbidden
   │
   ├─> 💾 Requête DB : trip = db.query(Trip).filter(Trip.id == trip_id).first()
   │   └─> Si None → 404 Not Found
   │
   ├─> ✅ Vérification : trip.available_weight >= booking_data.weight
   │   └─> Si insuffisant → 400 Bad Request
   │
   ├─> 💰 Calcul : total_price = booking_data.weight * trip.price_per_kg
   │
   ├─> 💾 Création : new_booking = Booking(...)
   ├─> 💾 db.add(new_booking)
   │
   ├─> 💾 Mise à jour : trip.available_weight -= booking_data.weight
   │
   ├─> 💾 db.commit()  # Sauvegarde en base de données
   ├─> 💾 db.refresh(new_booking)  # Récupère l'ID généré
   │
   └─> Return new_booking
   │
   ↓
5️⃣ SÉRIALISATION & RÉPONSE
   │
   ├─> FastAPI convertit new_booking (ORM) en BookingResponse (Pydantic)
   ├─> Sérialise en JSON
   └─> HTTP Response : 201 Created + JSON body
   │
   ↓
6️⃣ APPLICATION FLUTTER (Frontend)
   │
   ├─> Dio reçoit la réponse HTTP
   ├─> Parse le JSON en BookingModel
   ├─> BookingProvider ajoute la réservation à la liste
   ├─> notifyListeners() déclenche le rebuild des widgets
   └─> L'utilisateur voit la réservation dans "Mes réservations"
```

**SCHÉMA DES COUCHES :**

```
┌──────────────────────────────────┐
│      FLUTTER APP (Frontend)       │
│  - UI (Screens & Widgets)         │
│  - State (Providers)              │
│  - Services (API calls)           │
└─────────────┬─────────────────────┘
              │ HTTP/JSON (REST API)
              │ Authorization: Bearer JWT
              │
┌─────────────┴─────────────────────┐
│      FASTAPI (Backend)            │
│                                    │
│  ┌────────────────────────────┐  │
│  │   ROUTES (api/v1/)         │  │
│  │   - auth.py                │  │
│  │   - users.py               │  │
│  │   - bookings.py            │  │
│  └─────────┬──────────────────┘  │
│           │                         │
│  ┌─────────┴──────────────────┐  │
│  │   LOGIQUE MÉTIER            │  │
│  │   - Vérifications          │  │
│  │   - Calculs                │  │
│  │   - Règles métier         │  │
│  └─────────┬──────────────────┘  │
│           │                         │
│  ┌─────────┴──────────────────┐  │
│  │   ORM (db/models.py)       │  │
│  │   - User, Trip, Booking    │  │
│  └─────────┬──────────────────┘  │
│           │ SQLAlchemy            │
└───────────┬─┴─────────────────────┘
           │ SQL Queries
           │
┌──────────┴─────────────────────┐
│    BASE DE DONNÉES (SQLite)      │
│                                    │
│  Tables:                          │
│  - users                          │
│  - trips                          │
│  - bookings                       │
│  - messages                       │
└──────────────────────────────────┘
```

**POINTS CLÉS À EXPLIQUER :**

1. **Séparation des responsabilités**
   - Routes : Reçoivent les requêtes HTTP
   - Logique métier : Traite les données
   - ORM : Communique avec la DB
   - Schémas : Valident les données

2. **Dépendances cascadées**
   - Endpoint dépend de get_current_user
   - get_current_user dépend de get_db
   - get_current_user dépend de decode_token
   - FastAPI gère automatiquement l'ordre

3. **Transactions atomiques**
   - db.commit() : Tout est sauvegardé
   - Exception : Rollback automatique
   - Cohérence garantie

4. **Sécurité multicouche**
   - CORS : Filtrage des origines
   - JWT : Authentification
   - Pydantic : Validation
   - ORM : Protection SQL injection

---

### 📋 RÉSUMÉ DES APIs BACKEND

**"Voici la liste complète des endpoints que notre backend expose à l'application mobile."**

#### 🔐 Authentification (`/api/v1/auth`)
- `POST /auth/register` - Inscription d'un nouvel utilisateur
- `POST /auth/login` - Connexion (retourne JWT token)
- `POST /auth/logout` - Déconnexion
- `POST /auth/forgot-password` - Réinitialisation mot de passe

**Exemple de logique - Login :**
```
1. Recevoir email + password
2. Vérifier que l'utilisateur existe
3. Comparer le hash du mot de passe
4. Si OK : Générer un JWT token
5. Retourner : { "access_token": "...", "user": {...} }
```

#### 👤 Utilisateurs (`/api/v1/users`)
- `GET /users/profile` - Récupérer profil utilisateur
- `PUT /users/profile` - Mettre à jour profil
- `POST /users/avatar` - Upload photo de profil
- `GET /users/{id}` - Voir profil public

#### 📦 Réservations (`/api/v1/bookings`)
- `GET /bookings` - Liste des réservations (filtrées par utilisateur)
- `POST /bookings` - Créer une réservation
- `GET /bookings/{id}` - Détails d'une réservation
- `PUT /bookings/{id}/accept` - Accepter (transporteur)
- `PUT /bookings/{id}/cancel` - Annuler
- `PUT /bookings/{id}/complete` - Marquer terminée

**Logique métier - Créer une réservation :**
```
1. Vérifier que le client est authentifié
2. Vérifier que le trajet existe et est disponible
3. Vérifier que le poids demandé ≤ poids disponible
4. Calculer le prix total (poids × prix_par_kg)
5. Créer la réservation en DB (status = EN_ATTENTE)
6. Déduire le poids du trajet
7. Envoyer notification au transporteur
8. Retourner la réservation créée
```

#### 🚛 Trajets (`/api/v1/trips`)
- `GET /trips` - Liste des trajets disponibles
- `POST /trips` - Créer un trajet (transporteur uniquement)
- `GET /trips/{id}` - Détails d'un trajet
- `PUT /trips/{id}` - Modifier un trajet
- `DELETE /trips/{id}` - Supprimer un trajet
- `GET /trips/search` - Rechercher trajets (ville départ/arrivée, date)

#### 💬 Messagerie (`/api/v1/chat`)
- `GET /chat/conversations` - Liste des conversations
- `GET /chat/messages/{conversation_id}` - Messages d'une conversation
- `POST /chat/messages` - Envoyer un message

#### 🔔 Notifications (`/api/v1/notifications`)
- `GET /notifications` - Liste des notifications
- `PUT /notifications/{id}/read` - Marquer comme lue

### Sécurité implémentée

**"La sécurité est au cœur du backend :"**

1. **Authentification JWT**
   - Token généré après login
   - Expire après 8 heures
   - Vérifié sur chaque requête protégée

2. **Hashage des mots de passe**
   - Utilise bcrypt (algorithme sécurisé)
   - Jamais de mots de passe en clair en base

3. **Validation des données**
   - Pydantic valide toutes les entrées
   - Protection contre injection SQL (ORM)

4. **CORS configuré**
   - Autorise l'app mobile
   - Bloque les requêtes non autorisées

### Gestion des erreurs

**"Le backend gère proprement toutes les erreurs :"**

- **400 Bad Request** : Données invalides
- **401 Unauthorized** : Token manquant/invalide
- **403 Forbidden** : Pas les permissions
- **404 Not Found** : Ressource inexistante
- **500 Internal Server Error** : Erreur serveur

---

# PARTIE 4 : FRONTEND - Interface Utilisateur (7-8 minutes)

## 📱 Application Mobile Flutter

**"À DIRE AU PROFESSEUR :"**
> "Maintenant que nous avons vu le backend, passons au frontend. L'application mobile offre une interface moderne et intuitive pour 2 types d'utilisateurs : clients et transporteurs. J'ai choisi Flutter car c'est un framework cross-platform de Google qui permet d'écrire le code UNE SEULE FOIS et de le déployer sur Android ET iOS. Flutter utilise le langage Dart et offre des performances natives grâce à sa compilation AOT (Ahead-Of-Time). L'application communique avec notre backend FastAPI via des appels HTTP REST, utilise Provider pour la gestion d'état réactive, et stocke le token JWT de manière sécurisée avec flutter_secure_storage."

**POURQUOI FLUTTER ?**
1. **Cross-platform** : Un code → Android + iOS + Web
2. **Performance native** : 60fps, compilation native
3. **Hot Reload** : Voir les changements instantanément
4. **Rich UI** : Widgets Material Design et Cupertino
5. **Grande communauté** : Utilisé par Google, BMW, Alibaba
6. **Dart** : Langage moderne, orienté objet, type-safe

**ARCHITECTURE FLUTTER DU PROJET :**
- **Widgets** : Interface utilisateur (Screens + composants)
- **Providers** : Gestion d'état (ChangeNotifier)
- **Services** : Communication avec le backend (Dio HTTP client)
- **Models** : Représentation des données (User, Booking, Trip)
- **Config** : Configuration (URLs API, thème)

**PACKAGES FLUTTER UTILISÉS :**
```yaml
dependencies:
  flutter: sdk
  provider: ^6.0.0              # Gestion d'état
  dio: ^5.0.0                   # Client HTTP
  flutter_secure_storage: ^9.0.0  # Stockage sécurisé (tokens)
  google_maps_flutter: ^2.5.0   # Cartes
  image_picker: ^1.0.0          # Upload photos
  intl: ^0.18.0                 # Formatage dates/nombres
```

### Structure complète de l'application Flutter

```
lib/
├── main.dart                    # 🚀 Point d'entrée de l'application
│
├── config/                      # ⚙️ CONFIGURATION
│   ├── api_config.dart          # URLs API (dev/production)
│   ├── theme_config.dart        # Thème de l'app (couleurs, styles)
│   └── routes_config.dart       # Configuration des routes
│
├── models/                      # 📊 MODÈLES DE DONNÉES
│   ├── user_model.dart          # Modèle utilisateur
│   ├── booking_model.dart       # Modèle réservation
│   ├── trip_model.dart          # Modèle trajet
│   ├── message_model.dart       # Modèle message
│   └── notification_model.dart  # Modèle notification
│
├── services/                    # 🔧 SERVICES (Communication Backend)
│   ├── api_service.dart         # Client HTTP Dio
│   ├── auth_service.dart        # Service authentification
│   ├── booking_service.dart     # Service réservations
│   ├── trip_service.dart        # Service trajets
│   ├── user_service.dart        # Service utilisateurs
│   ├── message_service.dart     # Service messagerie
│   └── storage_service.dart     # Stockage local (tokens, cache)
│
├── providers/                   # 🔄 GESTION D'ÉTAT (Provider)
│   ├── auth_provider.dart       # État authentification
│   ├── booking_provider.dart    # État réservations
│   ├── trip_provider.dart       # État trajets
│   ├── message_provider.dart    # État messagerie
│   └── theme_provider.dart      # État thème (dark/light)
│
├── screens/                     # 📱 ÉCRANS DE L'APPLICATION
│   ├── auth/                    # Authentification
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── forgot_password_screen.dart
│   │
│   ├── client/                  # Écrans CLIENT
│   │   ├── client_home_screen.dart
│   │   ├── trip_list_screen.dart
│   │   ├── trip_detail_screen.dart
│   │   ├── create_booking_screen.dart
│   │   ├── my_bookings_screen.dart
│   │   └── booking_detail_screen.dart
│   │
│   ├── transporter/             # Écrans TRANSPORTEUR
│   │   ├── transporter_home_screen.dart
│   │   ├── create_trip_screen.dart
│   │   ├── my_trips_screen.dart
│   │   ├── trip_bookings_screen.dart
│   │   └── booking_requests_screen.dart
│   │
│   └── shared/                  # Écrans PARTAGÉS
│       ├── profile_screen.dart
│       ├── edit_profile_screen.dart
│       ├── messages_screen.dart
│       ├── chat_screen.dart
│       ├── notifications_screen.dart
│       └── settings_screen.dart
│
├── widgets/                     # 🧩 COMPOSANTS RÉUTILISABLES
│   ├── common/                  # Widgets communs
│   │   ├── custom_button.dart
│   │   ├── custom_input.dart
│   │   ├── custom_app_bar.dart
│   │   ├── loading_indicator.dart
│   │   └── error_widget.dart
│   │
│   ├── cards/                   # Cartes
│   │   ├── trip_card.dart
│   │   ├── booking_card.dart
│   │   └── message_card.dart
│   │
│   └── dialogs/                 # Dialogues
│       ├── confirmation_dialog.dart
│       └── info_dialog.dart
│
├── utils/                       # 🛠️ UTILITAIRES
│   ├── constants.dart           # Constantes de l'app
│   ├── validators.dart          # Validation formulaires
│   ├── formatters.dart          # Formatage dates, prix
│   └── helpers.dart             # Fonctions helpers
│
└── constants/                   # 📝 CONSTANTES
    ├── colors.dart              # Couleurs de l'app
    ├── text_styles.dart         # Styles de texte
    └── api_constants.dart       # Constantes API
```

### Explication détaillée de chaque dossier Flutter

#### 📁 **1. Fichier racine `main.dart`**

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le fichier main.dart est le point d'entrée de l'application Flutter. C'est ici que nous initialisons tout : les providers pour la gestion d'état, le stockage sécurisé pour les tokens, le thème de l'application (mode clair/sombre), et la navigation. Nous utilisons MultiProvider pour injecter plusieurs providers dans l'arbre de widgets : AuthProvider pour l'authentification, BookingProvider pour les réservations, TripProvider pour les trajets. Le Consumer<AuthProvider> dans le build permet de rediriger automatiquement l'utilisateur vers l'écran de login s'il n'est pas connecté, ou vers l'écran approprié selon son rôle (client ou transporteur)."

**RÔLE TECHNIQUE :**
- Point d'entrée : fonction `main()` exécutée au lancement
- Initialisation du stockage sécurisé (FlutterSecureStorage)
- Configuration de MultiProvider pour l'état global
- Configuration du thème (Material Design 3)
- Navigation conditionnelle selon l'authentification
- Hot Reload activé pour le développement rapide

**FONCTIONNALITÉS CLÉS :**
1. **MultiProvider** : Injection de dépendances pour l'état global
2. **Consumer** : Écoute les changements d'état et rebuild automatiquement
3. **MaterialApp** : Configuration de l'app (thème, routes, titre)
4. **Redirection automatique** : Login si non connecté, sinon home approprié

**CODE COMPLET :**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/trip_provider.dart';
import 'config/theme_config.dart';
import 'screens/auth/login_screen.dart';
import 'screens/client/client_home_screen.dart';
import 'screens/transporter/transporter_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser le stockage sécurisé
  final storage = FlutterSecureStorage();
  
  runApp(
    // MultiProvider pour gérer l'état global
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(storage)),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wassali',
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          // Redirection selon l'état d'authentification
          if (!authProvider.isAuthenticated) {
            return LoginScreen();
          } else if (authProvider.user?.role == 'CLIENT') {
            return ClientHomeScreen();
          } else {
            return TransporterHomeScreen();
          }
        },
      ),
    );
  }
}
```

#### 📁 **2. Dossier `config/` - Configuration**

**DESCRIPTION DU DOSSIER À DIRE AU PROFESSEUR :**
> "Le dossier config centralise toute la configuration de l'application. Cela inclut les URLs de l'API (avec switch dev/production), le thème visuel de l'application (couleurs, styles de texte, formes des boutons), et les routes de navigation. Cette centralisation permet de changer facilement de backend (localhost en développement, Render en production) sans modifier le code des services. Pour compiler l'APK en mode production, je change simplement isDevelopmentMode de true à false."

**RÔLE DU DOSSIER :**
- Centralisation de la configuration (DRY : Don't Repeat Yourself)
- Séparation environnement dev/production
- Thème visuel global
- Routes de navigation

**FICHIERS :**
- `api_config.dart` : URLs backend
- `theme_config.dart` : Couleurs, styles
- `routes_config.dart` : Navigation

---

**`api_config.dart`** - Configuration des URLs API

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le fichier api_config.dart définit les URLs de l'API backend. Le booléen isDevelopmentMode permet de basculer entre localhost (pour tester sur mon PC) et l'URL de production Render (pour l'APK Android). Le getter baseUrl retourne l'URL active selon le mode. Tous les services utilisent ApiConfig.baseUrl, donc changer l'URL n'affecte qu'un seul fichier. Les endpoints sont définis comme constantes pour éviter les erreurs de frappe."

**AVANTAGES :**
- Un seul endroit pour changer l'URL
- Switch dev/production facile
- Auto-complétion IDE (pas d'erreurs de frappe)
- Constantes réutilisables

**CODE COMPLET :**
```dart
class ApiConfig {
  // Mode développement (true) ou production (false)
  static const bool isDevelopmentMode = true;
  
  // URLs
  static const String _localUrl = 'http://localhost:8000/api/v1';
  static const String _productionUrl = 'https://wassali-backend.onrender.com/api/v1';
  
  // URL active selon le mode
  static String get baseUrl => isDevelopmentMode ? _localUrl : _productionUrl;
  
  // Endpoints
  static String get authLogin => '$baseUrl/auth/login';
  static String get authRegister => '$baseUrl/auth/register';
  static String get userProfile => '$baseUrl/users/profile';
  static String get bookings => '$baseUrl/bookings';
  static String get trips => '$baseUrl/trips';
}
```

**`theme_config.dart`** - Configuration du thème

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le fichier theme_config.dart définit l'apparence visuelle de toute l'application. Nous définissons deux thèmes : un thème clair et un thème sombre. Les couleurs principales (primaryColor, secondaryColor) sont utilisées partout dans l'app pour garantir une cohérence visuelle. Le thème inclut aussi les styles des boutons (ElevatedButton avec coins arrondis), les couleurs de la AppBar, les styles de texte, etc. L'utilisateur peut basculer entre mode clair et sombre dans les paramètres. Material Design 3 offre une expérience utilisateur moderne et familiale."

**ÉLÉMENTS DE THÈME :**
- Couleurs primaires et secondaires
- Styles de boutons
- Styles de texte
- Formes (border radius)
- Couleurs d'arrière-plan

**CODE COMPLET :**
```dart
import 'package:flutter/material.dart';

class ThemeConfig {
  // Couleurs principales
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFFFF9800);
  
  // Thème clair
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
  
  // Thème sombre
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Color(0xFF121212),
  );
}
```

#### 📁 **3. Dossier `models/` - Modèles de données**

**DESCRIPTION DU DOSSIER À DIRE AU PROFESSEUR :**
> "Le dossier models contient les classes Dart qui représentent les données de l'application. Chaque modèle correspond à une table backend : UserModel pour les utilisateurs, TripModel pour les trajets, BookingModel pour les réservations. Ces classes ont deux méthodes importantes : fromJson() qui convertit un JSON reçu de l'API en objet Dart, et toJson() qui convertit un objet Dart en JSON pour l'envoyer à l'API. Cette sérialisation/désérialisation automatique facilite la communication avec le backend et permet un code type-safe (le compilateur vérifie les types)."

**RÔLE DU DOSSIER :**
- Représentation type-safe des données
- Sérialisation JSON ↔ Dart
- Documentation du format des données
- Auto-complétion IDE

**MODÈLES IMPLÉMENTÉS :**
1. **UserModel** : Utilisateur (client ou transporteur)
2. **TripModel** : Trajet (créé par transporteur)
3. **BookingModel** : Réservation (créée par client)
4. **MessageModel** : Message de chat
5. **NotificationModel** : Notification

**POURQUOI DES MODÈLES ?**
- **Type-safety** : Le compilateur détecte les erreurs
- **Auto-complétion** : IDE suggère les propriétés
- **Maintenabilité** : Changement de structure centralisé
- **Documentation** : Structure des données explicite

---

**`user_model.dart`** - Modèle utilisateur

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le modèle UserModel représente un utilisateur de l'application. Il contient l'ID, l'email, le nom complet, le numéro de téléphone optionnel, le rôle (CLIENT ou TRANSPORTEUR), la photo de profil optionnelle, et la date de création. La méthode fromJson() parse le JSON reçu de l'API et crée une instance UserModel. Les champs optionnels utilisent le type nullable (?). La méthode toJson() fait l'inverse pour envoyer les données à l'API."

**MAPPING JSON ↔ DART :**
- Backend envoie : `{"full_name": "John"}` (snake_case)
- Dart reçoit : `fullName` (camelCase)
- fromJson() fait la conversion automatiquement

**CODE COMPLET :**
```dart
class UserModel {
  final int id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String role;  // "CLIENT" ou "TRANSPORTEUR"
  final String? profilePhoto;
  final DateTime createdAt;
  
  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    required this.role,
    this.profilePhoto,
    required this.createdAt,
  });
  
  // Conversion depuis JSON (réponse API)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      role: json['role'],
      profilePhoto: json['profile_photo'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  
  // Conversion vers JSON (requête API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'role': role,
      'profile_photo': profilePhoto,
    };
  }
}
```

**`booking_model.dart`** - Modèle réservation

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le modèle BookingModel représente une réservation de colis. Il contient tous les détails : l'ID de la réservation, l'ID du client, l'ID du trajet associé, la description du colis, le poids en kilogrammes, les adresses de ramassage et livraison, le prix total calculé par le backend, le status (EN_ATTENTE, ACCEPTÉE, REFUSÉE, TERMINÉE), et la date de création. Comme pour UserModel, nous avons fromJson() et toJson() pour la sérialisation. Ce modèle est utilisé partout dans l'app : affichage de la liste des réservations, détails, création."

**CODE COMPLET :**
```dart
class BookingModel {
  final int id;
  final int clientId;
  final int tripId;
  final String description;
  final double weight;
  final String pickupAddress;
  final String deliveryAddress;
  final double totalPrice;
  final String status;  // "EN_ATTENTE", "ACCEPTÉE", "REFUSÉE", "TERMINÉE"
  final DateTime createdAt;
  
  BookingModel({...});
  
  factory BookingModel.fromJson(Map<String, dynamic> json) {...}
  Map<String, dynamic> toJson() {...}
}
```

#### 📁 **4. Dossier `services/` - Communication avec le Backend**

**DESCRIPTION DU DOSSIER À DIRE AU PROFESSEUR :**
> "Le dossier services contient toutes les classes qui communiquent avec le backend via HTTP. C'est la couche de communication entre l'app Flutter et l'API FastAPI. Le service principal est ApiService qui utilise Dio (un client HTTP puissant) pour faire les requêtes GET, POST, PUT, DELETE. Les autres services (AuthService, BookingService, TripService) utilisent ApiService pour appeler les endpoints spécifiques. Par exemple, AuthService.login() appelle POST /auth/login et retourne un UserModel et un token. Les services gèrent aussi les erreurs HTTP (401, 404, 500) et les transforment en exceptions Dart compréhensibles."

**RÔLE DU DOSSIER :**
- Communication HTTP avec le backend
- Gestion des tokens JWT (automatique dans les headers)
- Gestion des erreurs et timeouts
- Sérialisation/désérialisation JSON
- Retry logic et gestion hors ligne (possible)

**SERVICES IMPLÉMENTÉS :**
1. **ApiService** : Client HTTP de base (Dio)
2. **AuthService** : Login, register, logout
3. **BookingService** : CRUD réservations
4. **TripService** : CRUD trajets
5. **UserService** : Profil, update, avatar
6. **MessageService** : Chat
7. **StorageService** : Stockage local sécurisé

**ARCHITECTURE DES SERVICES :**
```
AuthService  ───┐
BookingService ├──> ApiService ──> Dio ──> Backend API
TripService  ───┘
```

---

**`api_service.dart`** - Client HTTP (Dio)

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le fichier api_service.dart est le cœur de la communication avec le backend. Il crée une instance Dio avec des configurations : baseUrl depuis ApiConfig, timeout de 90 secondes (pour le cold start de Render), headers JSON par défaut. L'intercepteur est très important : il ajoute automatiquement le token JWT dans l'en-tête Authorization de CHAQUE requête. Ainsi, les endpoints protégés fonctionnent automatiquement. Si le backend retourne 401 (token expiré), l'intercepteur peut déconnecter automatiquement l'utilisateur. C'est une couche d'abstraction qui simplifie tous les appels API."

**FONCTIONNALITÉS CLÉS :**
1. **Configuration Dio** : baseUrl, timeouts, headers
2. **Intercepteur** : Injection automatique du JWT
3. **Gestion erreurs** : 401 → déconnexion automatique
4. **Méthodes HTTP** : get(), post(), put(), delete()
5. **Timeout** : 90 secondes pour Render cold start

**POURQUOI 90 SECONDES DE TIMEOUT ?**
- Render free tier : serveur se met en veille
- Première requête après veille : 30-60 secondes
- 90 secondes garantit que ça fonctionne
- Requêtes suivantes : instantanées

**CODE COMPLET :**
```dart
import 'package:dio/dio.dart';
import '../config/api_config.dart';

class ApiService {
  late Dio _dio;
  
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: Duration(seconds: 90),  // Pour Render cold start
        receiveTimeout: Duration(seconds: 90),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    
    // Intercepteur pour ajouter le token JWT
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Récupérer le token depuis le storage
          final token = await storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          // Gestion des erreurs globales
          if (error.response?.statusCode == 401) {
            // Token expiré → déconnexion
          }
          return handler.next(error);
        },
      ),
    );
  }
  
  // Méthodes HTTP
  Future<Response> get(String path) => _dio.get(path);
  Future<Response> post(String path, dynamic data) => _dio.post(path, data: data);
  Future<Response> put(String path, dynamic data) => _dio.put(path, data: data);
  Future<Response> delete(String path) => _dio.delete(path);
}
```

**`auth_service.dart`** - Service d'authentification

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le service AuthService gère toute l'authentification. La méthode register() envoie les données d'inscription au backend (email, password, nom, rôle) via POST /auth/register, et retourne un UserModel si succès. La méthode login() envoie email et password via POST /auth/login, et si les identifiants sont corrects, reçoit un token JWT et les informations utilisateur. Ces méthodes utilisent ApiService pour les requêtes HTTP, et gèrent les exceptions (mauvais identifiants, serveur indisponible, etc.) pour afficher des messages d'erreur clairs à l'utilisateur."

**MÉTHODES IMPLÉMENTÉES :**
- **register()** : Inscription d'un nouvel utilisateur
- **login()** : Connexion avec email/password
- **logout()** : Déconnexion (suppression du token local)
- **forgotPassword()** : Réinitialisation mot de passe

**GESTION DES ERREURS :**
```dart
try {
  final result = await login(email, password);
  // Succès
} on DioException catch (e) {
  if (e.response?.statusCode == 401) {
    throw Exception('Email ou mot de passe incorrect');
  } else if (e.response?.statusCode == 500) {
    throw Exception('Erreur serveur');
  } else {
    throw Exception('Erreur de connexion');
  }
}
```

**CODE COMPLET :**
```dart
import 'api_service.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  
  // Inscription
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
    required String role,
  }) async {
    try {
      final response = await _apiService.post('/auth/register', {
        'email': email,
        'password': password,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'role': role,
      });
      
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erreur lors de l\'inscription: $e');
    }
  }
  
  // Connexion
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });
      
      return {
        'access_token': response.data['access_token'],
        'user': UserModel.fromJson(response.data['user']),
      };
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
}
```

**`booking_service.dart`** - Service réservations

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le service BookingService gère toutes les opérations sur les réservations. getMyBookings() appelle GET /bookings pour récupérer toutes les réservations de l'utilisateur connecté (le backend filtre automatiquement grâce au token JWT). createBooking() appelle POST /bookings pour créer une nouvelle réservation avec toutes les informations (trajet, poids, description, adresses). cancelBooking() appelle PUT /bookings/{id}/cancel pour annuler une réservation. Toutes ces méthodes retournent des objets typés (List<BookingModel>, BookingModel) après avoir parsé le JSON."

**MÉTHODES IMPLÉMENTÉES :**
- **getMyBookings()** : Liste des réservations
- **getBookingById(id)** : Détails d'une réservation
- **createBooking(...)** : Créer réservation
- **cancelBooking(id)** : Annuler réservation
- **acceptBooking(id)** : Accepter (transporteur)
- **rejectBooking(id)** : Refuser (transporteur)

**EXEMPLE D'UTILISATION :**
```dart
// Dans un widget ou provider
final bookingService = BookingService();

// Créer une réservation
final newBooking = await bookingService.createBooking(
  tripId: 1,
  description: 'Vêtements et cadeaux',
  weight: 5.0,
  pickupAddress: '123 Rue de Paris',
  deliveryAddress: '456 Avenue de Tunis',
);

print('Réservation créée avec succès ! Prix: ${newBooking.totalPrice}€');
```

**CODE COMPLET :**
```dart
class BookingService {
  final ApiService _apiService = ApiService();
  
  // Récupérer toutes les réservations de l'utilisateur
  Future<List<BookingModel>> getMyBookings() async {
    final response = await _apiService.get('/bookings');
    return (response.data as List)
        .map((json) => BookingModel.fromJson(json))
        .toList();
  }
  
  // Créer une réservation
  Future<BookingModel> createBooking({
    required int tripId,
    required String description,
    required double weight,
    required String pickupAddress,
    required String deliveryAddress,
  }) async {
    final response = await _apiService.post('/bookings', {
      'trip_id': tripId,
      'description': description,
      'weight': weight,
      'pickup_address': pickupAddress,
      'delivery_address': deliveryAddress,
    });
    
    return BookingModel.fromJson(response.data);
  }
  
  // Annuler une réservation
  Future<void> cancelBooking(int bookingId) async {
    await _apiService.put('/bookings/$bookingId/cancel', {});
  }
}
```

#### 📁 **5. Dossier `providers/` - Gestion d'état**

**DESCRIPTION DU DOSSIER À DIRE AU PROFESSEUR :**
> "Le dossier providers contient la gestion d'état de l'application avec le pattern Provider. Un provider est une classe qui hérite de ChangeNotifier et qui contient l'état global de l'application. Quand l'état change (par exemple, un utilisateur se connecte), le provider appelle notifyListeners() et tous les widgets qui écoutent ce provider se reconstruisent automatiquement. C'est le pattern de gestion d'état recommandé par Flutter. Par exemple, AuthProvider stocke l'utilisateur connecté et son token. Quand on appelle authProvider.login(), il fait l'appel API, sauvegarde le token, met à jour l'état, et tous les widgets qui dépendent de l'authentification se mettent à jour automatiquement."

**RÔLE DU DOSSIER :**
- Gestion d'état global (partagé entre plusieurs écrans)
- Réactivité automatique (rebuild des widgets)
- Logique métier côté frontend
- Cache des données (moins d'appels API)

**PROVIDERS IMPLÉMENTÉS :**
1. **AuthProvider** : Authentification, utilisateur connecté
2. **BookingProvider** : Liste des réservations
3. **TripProvider** : Liste des trajets
4. **MessageProvider** : Conversations et messages
5. **ThemeProvider** : Mode clair/sombre

**PATTERN PROVIDER :**
```dart
// 1. Classe Provider
class AuthProvider with ChangeNotifier {
  User? _user;
  
  Future<void> login(...) async {
    _user = await authService.login(...);
    notifyListeners(); // Déclenche rebuild
  }
}

// 2. Injection dans l'app
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
  ],
  child: MyApp(),
)

// 3. Utilisation dans un widget
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    return Text(authProvider.user?.name ?? 'Non connecté');
  },
)
```

**AVANTAGES :**
- État centralisé
- Pas de duplication de données
- Rebuild optimisé (seuls les widgets concernés)
- Code maintenable

---

**`auth_provider.dart`** - Provider d'authentification

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le AuthProvider est le provider le plus important. Il stocke l'utilisateur connecté, le token JWT, et l'état de chargement. La méthode login() appelle AuthService.login(), sauvegarde le token dans le stockage sécurisé (pour le garder après fermeture de l'app), met à jour _user et _token, puis appelle notifyListeners(). Tous les widgets Consumer<AuthProvider> se reconstruisent et voient le nouvel utilisateur. Le getter isAuthenticated retourne true si un token valide existe. La méthode logout() supprime le token et l'utilisateur, puis notifie les listeners. Le constructor charge automatiquement le token au démarrage pour garder l'utilisateur connecté."

**ÉTAT GÉRÉ :**
- `_user` : Utilisateur connecté (ou null)
- `_token` : Token JWT (ou null)
- `_isLoading` : Chargement en cours (pour spinner)

**MÉTHODES :**
- **login()** : Connexion + sauvegarde token
- **logout()** : Déconnexion + suppression token
- **register()** : Inscription
- **_loadToken()** : Chargement token au démarrage

**GETTERS :**
- **user** : Utilisateur connecté
- **isAuthenticated** : Booléen
- **isLoading** : Booléen

**PERSISTANCE :**
```dart
// Sauvegarde sécurisée
await _storage.write(key: 'access_token', value: token);

// Chargement au démarrage
final token = await _storage.read(key: 'access_token');
if (token != null) {
  // Charger le profil utilisateur
}
```

**CODE COMPLET :**
```dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage;
  
  UserModel? _user;
  String? _token;
  bool _isLoading = false;
  
  AuthProvider(this._storage) {
    // Charger le token au démarrage
    _loadToken();
  }
  
  // Getters
  UserModel? get user => _user;
  bool get isAuthenticated => _token != null && _user != null;
  bool get isLoading => _isLoading;
  
  // Connexion
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _authService.login(email, password);
      _token = result['access_token'];
      _user = result['user'];
      
      // Sauvegarder le token
      await _storage.write(key: 'access_token', value: _token);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }
  
  // Déconnexion
  Future<void> logout() async {
    _token = null;
    _user = null;
    await _storage.delete(key: 'access_token');
    notifyListeners();
  }
  
  // Charger le token depuis le storage
  Future<void> _loadToken() async {
    _token = await _storage.read(key: 'access_token');
    if (_token != null) {
      // TODO: Charger le profil utilisateur
    }
    notifyListeners();
  }
}
```

#### 📁 **6. Dossier `screens/` - Écrans de l'application**

**DESCRIPTION DU DOSSIER À DIRE AU PROFESSEUR :**
> "Le dossier screens contient tous les écrans (pages) de l'application organisés par fonctionnalité. Chaque écran est un StatefulWidget ou StatelessWidget qui affiche une interface complète. Les écrans sont organisés en trois sous-dossiers : auth/ pour l'authentification (login, register), client/ pour les écrans spécifiques aux clients (liste des trajets, créer réservation, mes réservations), transporter/ pour les écrans spécifiques aux transporteurs (créer trajet, gérer trajets, accepter réservations), et shared/ pour les écrans communs (profil, messagerie, paramètres). Chaque écran utilise les providers pour accéder à l'état et les services pour faire des appels API."

**RÔLE DU DOSSIER :**
- Interface utilisateur complète
- Navigation entre écrans
- Affichage des données
- Formulaires de saisie
- Gestion des interactions utilisateur

**ORGANISATION :**
```
screens/
├── auth/          # Authentification (7 écrans)
│   ├── login_screen.dart
│   ├── register_screen.dart
│   └── forgot_password_screen.dart
│
├── client/        # Écrans CLIENT (10+ écrans)
│   ├── client_home_screen.dart
│   ├── trip_list_screen.dart
│   ├── trip_detail_screen.dart
│   ├── create_booking_screen.dart
│   ├── my_bookings_screen.dart
│   └── booking_detail_screen.dart
│
├── transporter/   # Écrans TRANSPORTEUR (10+ écrans)
│   ├── transporter_home_screen.dart
│   ├── create_trip_screen.dart
│   ├── my_trips_screen.dart
│   ├── trip_bookings_screen.dart
│   └── booking_requests_screen.dart
│
└── shared/        # Écrans PARTAGÉS (8 écrans)
    ├── profile_screen.dart
    ├── edit_profile_screen.dart
    ├── messages_screen.dart
    ├── chat_screen.dart
    ├── notifications_screen.dart
    └── settings_screen.dart
```

**TOTAL : 35+ écrans implémentés**

---

**`auth/login_screen.dart`** - Écran de connexion

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "L'écran de connexion est le premier écran que l'utilisateur voit s'il n'est pas connecté. Il contient un formulaire avec deux champs : email et mot de passe, validés avec des validators (format email, champ non vide). Quand l'utilisateur clique sur Se connecter, nous récupérons le AuthProvider, appelons authProvider.login() qui fait l'appel API, et si succès, le Consumer dans main.dart détecte le changement et redirige automatiquement vers l'écran approprié (client_home ou transporter_home selon le rôle). En cas d'erreur (401), nous affichons un SnackBar avec le message d'erreur. L'écran affiche aussi un bouton pour aller vers l'inscription."

**COMPOSANTS UTILISÉS :**
- **Form** : Gestion du formulaire
- **GlobalKey<FormState>** : Validation
- **TextEditingController** : Contrôle des champs
- **CustomInput** : Widget réutilisable
- **CustomButton** : Bouton avec loading
- **Provider.of<AuthProvider>** : Accès au provider
- **SnackBar** : Messages d'erreur/succès

**FLUX UTILISATEUR :**
1. Utilisateur saisit email + password
2. Clique "Se connecter"
3. Validation du formulaire (format, champs requis)
4. Appel authProvider.login()
5. Si succès : Redirection automatique
6. Si erreur : Affichage SnackBar

**CODE COMPLET :**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_input.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset('assets/images/logo.png', height: 100),
                SizedBox(height: 40),
                
                // Titre
                Text(
                  'Bienvenue sur Wassali',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                
                // Champ Email
                CustomInput(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                // Champ Mot de passe
                CustomInput(
                  controller: _passwordController,
                  label: 'Mot de passe',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                
                // Bouton Connexion
                CustomButton(
                  text: 'Se connecter',
                  isLoading: authProvider.isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await authProvider.login(
                          _emailController.text,
                          _passwordController.text,
                        );
                        // Navigation automatique via Consumer dans main.dart
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erreur: $e')),
                        );
                      }
                    }
                  },
                ),
                
                // Lien Inscription
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RegisterScreen()),
                    );
                  },
                  child: Text('Pas encore de compte ? S\'inscrire'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

#### 📁 **7. Dossier `widgets/` - Composants réutilisables**

**DESCRIPTION DU DOSSIER À DIRE AU PROFESSEUR :**
> "Le dossier widgets contient tous les composants réutilisables de l'application. Au lieu de dupliquer le même code de bouton ou de carte dans chaque écran, nous créons des widgets personnalisés que nous pouvons réutiliser partout. Par exemple, CustomButton est utilisé dans tous les formulaires, TripCard affiche un trajet de manière uniforme dans toutes les listes, CustomInput standardise les champs de saisie. Cette approche DRY (Don't Repeat Yourself) rend le code plus maintenable : si je veux changer le style de tous les boutons, je modifie un seul fichier. Les widgets sont organisés par catégorie : common/ pour les widgets de base, cards/ pour les cartes d'affichage, dialogs/ pour les boîtes de dialogue."

**RÔLE DU DOSSIER :**
- Réutilisation de code (DRY)
- Cohérence visuelle
- Maintenabilité (changement centralisé)
- Composants testés et fiables

**ORGANISATION :**
```
widgets/
├── common/         # Widgets de base (15+ widgets)
│   ├── custom_button.dart
│   ├── custom_input.dart
│   ├── custom_app_bar.dart
│   ├── loading_indicator.dart
│   └── error_widget.dart
│
├── cards/          # Cartes d'affichage (10+ widgets)
│   ├── trip_card.dart
│   ├── booking_card.dart
│   └── message_card.dart
│
└── dialogs/        # Boîtes de dialogue (5+ widgets)
    ├── confirmation_dialog.dart
    └── info_dialog.dart
```

**AVANTAGES DES WIDGETS RÉUTILISABLES :**
1. **DRY** : Un seul endroit pour chaque composant
2. **Cohérence** : Tous les boutons ont le même style
3. **Maintenabilité** : Changement facile et rapide
4. **Testabilité** : Test une fois, utilise partout
5. **Productivité** : Développement plus rapide

---

**`common/custom_button.dart`** - Bouton personnalisé

**DESCRIPTION À DIRE AU PROFESSEUR :**
> "Le widget CustomButton est un bouton réutilisable avec des fonctionnalités communes. Il accepte un texte, une fonction onPressed, un booléen isLoading pour afficher un spinner pendant le chargement, et une couleur optionnelle. Quand isLoading est true, le bouton est désactivé et affiche un CircularProgressIndicator au lieu du texte. Le bouton a une taille fixe (width: double.infinity pour occuper toute la largeur, height: 50), des coins arrondis, et utilise la couleur primaire du thème par défaut. Ce widget est utilisé dans tous les formulaires : login, register, création de trajet, etc."

**PROPRIÉTÉS :**
- `text` : Texte affiché sur le bouton
- `onPressed` : Fonction appelée au clic
- `isLoading` : Affiche spinner si true
- `backgroundColor` : Couleur personnalisée (optionnelle)

**UTILISATION :**
```dart
CustomButton(
  text: 'Se connecter',
  isLoading: authProvider.isLoading,
  onPressed: () async {
    await authProvider.login(email, password);
  },
)
```

**CODE COMPLET :**
```dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  
  const CustomButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        ),
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(text, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
```

**`cards/trip_card.dart`** - Carte de trajet
```dart
class TripCard extends StatelessWidget {
  final TripModel trip;
  final VoidCallback onTap;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Villes
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    '${trip.departureCity} → ${trip.arrivalCity}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              
              // Date
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(DateFormat('dd/MM/yyyy').format(trip.departureDate)),
                ],
              ),
              SizedBox(height: 8),
              
              // Poids et prix
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${trip.availableWeight} kg disponibles',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    '${trip.pricePerKg}€/kg',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 🔗 RELATIONS FRONTEND - BACKEND - DATABASE

**À DIRE AU PROFESSEUR :**
> "Maintenant que nous avons vu le frontend et le backend séparément, il est crucial de comprendre comment ils travaillent ensemble avec la base de données. Laissez-moi vous montrer le flux complet d'une action utilisateur, de l'interface mobile jusqu'à la base de données et retour."

---

**SCÉNARIO COMPLET : L'UTILISATEUR CRÉE UNE RÉSERVATION**

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃         📱 FLUTTER APP (Smartphone Android)          ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

1️⃣  UI LAYER (Widgets)
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃  CreateBookingScreen                       ┃
    ┃                                            ┃
    ┃  - Utilisateur remplit le formulaire       ┃
    ┃  - Sélectionne trajet : "Paris → Tunis"    ┃
    ┃  - Saisit poids : 5 kg                     ┃
    ┃  - Description : "Vêtements"               ┃
    ┃  - Adresses pickup & delivery              ┃
    ┃                                            ┃
    ┃  ✅ Validation du formulaire (Flutter)    ┃
    ┃     - Poids > 0                           ┃
    ┃     - Champs requis remplis               ┃
    ┃                                            ┃
    ┃  🔒 L'utilisateur clique "Réserver"        ┃
    ┗━━━━━━━━━━━━━━━━━━━┬━━━━━━━━━━━━━━━━━━━━┛
                     │
                     │ onPressed: () { ... }
                     │
2️⃣  STATE LAYER (Provider)
    ┏━━━━━━━━━━━━┴━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃  BookingProvider.createBooking()          ┃
    ┃                                            ┃
    ┃  setLoading(true)  // Spinner visible     ┃
    ┃  notifyListeners() // Rebuild UI          ┃
    ┗━━━━━━━━━━━━━━━━━━━┬━━━━━━━━━━━━━━━━━━━━┛
                     │
                     │ Appelle le service
                     │
3️⃣  SERVICE LAYER (HTTP Client)
    ┏━━━━━━━━━━━━┴━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃  BookingService.createBooking(...)        ┃
    ┃                                            ┃
    ┃  🔐 Récupère token JWT du storage        ┃
    ┃     token = "eyJhbGciOiJIUzI1NiIsInR5..."  ┃
    ┃                                            ┃
    ┃  📦 Prépare la requête HTTP             ┃
    ┃     Method: POST                          ┃
    ┃     URL: /api/v1/bookings                 ┃
    ┃     Headers: {                            ┃
    ┃       "Authorization": "Bearer eyJ..."    ┃
    ┃       "Content-Type": "application/json"  ┃
    ┃     }                                      ┃
    ┃     Body: {                                ┃
    ┃       "trip_id": 1,                       ┃
    ┃       "weight": 5.0,                      ┃
    ┃       "description": "Vêtements",         ┃
    ┃       "pickup_address": "123 Rue...",     ┃
    ┃       "delivery_address": "456 Ave..."    ┃
    ┃     }                                      ┃
    ┃                                            ┃
    ┃  🌐 Dio envoie la requête HTTPS          ┃
    ┗━━━━━━━━━━━━━━━━━━━┬━━━━━━━━━━━━━━━━━━━━┛
                     │
                     │ HTTPS sur Internet
                     │ (WiFi / 4G / 5G)
                     │
      ┌──────────────┴──────────────┐
      │     ☁️ INTERNET ☁️         │
      │  (Render.com Cloud)      │
      └──────────────┬──────────────┘
                     │
┏━━━━━━━━━━━━━━━━━━┴━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃      🚀 FASTAPI BACKEND (Python)                ┃
┃   https://wassali-backend.onrender.com          ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

4️⃣  UVICORN SERVER
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃  Reçoit : POST /api/v1/bookings          ┃
    ┃  Route vers : bookings.router            ┃
    ┗━━━━━━━━━━━━━━━━━━━┬━━━━━━━━━━━━━━━━━━━━┛
                     │
5️⃣  MIDDLEWARES
    ┏━━━━━━━━━━━━┴━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃  ✅ CORS : Origin autorisée               ┃
    ┃  ✅ Pydantic : Validation du JSON        ┃
    ┃     - trip_id : int ✓                    ┃
    ┃     - weight : float ✓                   ┃
    ┃     - description : str ✓                ┃
    ┃     - adresses : str ✓                   ┃
    ┃                                            ┃
    ┃  🔐 get_current_user(token)              ┃
    ┃     1. Extrait token de l'en-tête        ┃
    ┃     2. Décode JWT avec security.py         ┃
    ┃     3. Vérifie signature + expiration      ┃
    ┃     4. Extrait user_id = 5                ┃
    ┗━━━━━━━━━━━━━━━━━━━┬━━━━━━━━━━━━━━━━━━━━┛
                     │ SQL
                     │
6️⃣  DATABASE QUERY #1 - Get User
    ┏━━━━━━━━━━━━┴━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃  SQLAlchemy → SQLite                     ┃
    ┃                                            ┃
    ┃  SELECT * FROM users WHERE id = 5;       ┃
    ┃                                            ┃
    ┃  Résultat :                                ┃
    ┃  User {                                   ┃
    ┃    id: 5,                                 ┃
    ┃    email: "client@test.com",              ┃
    ┃    role: "CLIENT",                        ┃
    ┃    ...                                    ┃
    ┃  }                                        ┃
    ┗━━━━━━━━━━━━━━━━━━━┬━━━━━━━━━━━━━━━━━━━━┛
                     │
7️⃣  ENDPOINT FUNCTION (Logique Métier)
    ┏━━━━━━━━━━━━┴━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃  @router.post("/")                        ┃
    ┃  def create_booking(...):                 ┃
    ┃                                            ┃
    ┃  ✅ Vérification 1 : Rôle                 ┃
    ┃     if current_user.role != "CLIENT":     ┃
    ┃       raise 403 Forbidden                 ┃
    ┃     ✓ OK : C'est un CLIENT                ┃
    ┗━━━━━━━━━━━━━━━━━━━┬━━━━━━━━━━━━━━━━━━━━┛
                     │ SQL
                     │
8️⃣  DATABASE QUERY #2 - Get Trip
    ┏━━━━━━━━━━━━┴━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃  SELECT * FROM trips WHERE id = 1;       ┃
    ┃                                            ┃
    ┃  Résultat :                                ┃
    ┃  Trip {                                   ┃
    ┃    id: 1,                                 ┃
    ┃    transporter_id: 10,                    ┃
    ┃    departure: "Paris",                    ┃
    ┃    arrival: "Tunis",                      ┃
    ┃    available_weight: 20.0 kg,             ┃
    ┃    price_per_kg: 8.0€,                    ┃
    ┃    status: "DISPONIBLE"                   ┃
    ┃  }                                        ┃
    ┗━━━━━━━━━━━━━━━━━━━┬━━━━━━━━━━━━━━━━━━━━┛
                     │
9️⃣  LOGIQUE MÉTIER (Suite)
    ┏━━━━━━━━━━━━┴━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃  ✅ Vérification 2 : Disponibilité        ┃
    ┃     if trip.available_weight < 5.0:       ┃
    ┃       raise 400 Bad Request               ┃
    ┃     ✓ OK : 20.0 >= 5.0                   ┃
    ┃                                            ┃
    ┃  💰 Calcul du prix :                      ┃
    ┃     total_price = 5.0 kg * 8.0€/kg       ┃
    ┃                 = 40.0€                    ┃
    ┃                                            ┃
    ┃  📦 Création de l'objet Booking :        ┃
    ┃     new_booking = Booking(                 ┃
    ┃       client_id = 5,                       ┃
    ┃       trip_id = 1,                         ┃
    ┃       weight = 5.0,                        ┃
    ┃       description = "Vêtements",            ┃
    ┃       total_price = 40.0,                  ┃
    ┃       status = "EN_ATTENTE",               ┃
    ┃       created_at = now()                   ┃
    ┃     )                                      ┃
    ┃                                            ┃
    ┃  🔄 Mise à jour du trajet :              ┃
    ┃     trip.available_weight -= 5.0          ┃
    ┃     trip.available_weight = 15.0 kg       ┃
    ┗━━━━━━━━━━━━━━━━━━━┬━━━━━━━━━━━━━━━━━━━━┛
                     │ SQL
                     │
🔟 DATABASE TRANSACTIONS
    ┏━━━━━━━━━━━━┴━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃  BEGIN TRANSACTION;                      ┃
    ┃                                            ┃
    ┃  INSERT INTO bookings (                  ┃
    ┃    client_id, trip_id, weight,           ┃
    ┃    description, total_price,             ┃
    ┃    status, created_at                    ┃
    ┃  ) VALUES (                               ┃
    ┃    5, 1, 5.0, "Vêtements",                ┃
    ┃    40.0, "EN_ATTENTE", "2026-01-05"      ┃
    ┃  );                                       ┃
    ┃  → Booking ID = 42 (auto-increment)      ┃
    ┃                                            ┃
    ┃  UPDATE trips                             ┃
    ┃  SET available_weight = 15.0             ┃
    ┃  WHERE id = 1;                            ┃
    ┃                                            ┃
    ┃  COMMIT;  ✓ Succès                        ┃
    ┃  (Si erreur → ROLLBACK automatique)      ┃
    ┗━━━━━━━━━━━━━━━━━━━┬━━━━━━━━━━━━━━━━━━━━┛
                     │
🔙 RETOUR AU BACKEND
    ┏━━━━━━━━━━━━┴━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃  db.refresh(new_booking)                  ┃
    ┃  → Récupère l'ID généré = 42            ┃
    ┃                                            ┃
    ┃  return new_booking                       ┃
    ┃  → Objet ORM Booking                     ┃
    ┗━━━━━━━━━━━━━━━━━━━┬━━━━━━━━━━━━━━━━━━━━┛
                     │
📦 SÉRIALISATION
    ┏━━━━━━━━━━━━┴━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃  FastAPI + Pydantic                       ┃
    ┃                                            ┃
    ┃  Booking (ORM) → BookingResponse (Schema) ┃
    ┃  BookingResponse → JSON                   ┃
    ┃                                            ┃
    ┃  HTTP Response :                          ┃
    ┃  Status: 201 Created                      ┃
    ┃  Body: {                                  ┃
    ┃    "id": 42,                              ┃
    ┃    "client_id": 5,                        ┃
    ┃    "trip_id": 1,                          ┃
    ┃    "weight": 5.0,                         ┃
    ┃    "description": "Vêtements",             ┃
    ┃    "pickup_address": "123 Rue...",        ┃
    ┃    "delivery_address": "456 Ave...",      ┃
    ┃    "total_price": 40.0,                   ┃
    ┃    "status": "EN_ATTENTE",                ┃
    ┃    "created_at": "2026-01-05T14:30:00Z"   ┃
    ┃  }                                        ┃
    ┗━━━━━━━━━━━━━━━━━━━┬━━━━━━━━━━━━━━━━━━━━┛
                     │ HTTPS sur Internet
                     │
      ┌──────────────┬──────────────┐
      │  ☁️ INTERNET ☁️          │
      └──────────────┬──────────────┘
                     │
📥 RETOUR AU FLUTTER
    ┏━━━━━━━━━━━━┴━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃  BookingService reçoit la réponse        ┃
    ┃                                            ┃
    ┃  response.statusCode == 201 ✓            ┃
    ┃                                            ┃
    ┃  final json = response.data;              ┃
    ┃  final booking = BookingModel.fromJson(json);
    ┃                                            ┃
    ┃  return booking; // Au Provider           ┃
    ┗━━━━━━━━━━━━━━━━━━━┬━━━━━━━━━━━━━━━━━━━━┛
                     │
🔄 MISE À JOUR DE L'ÉTAT
    ┏━━━━━━━━━━━━┴━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃  BookingProvider                          ┃
    ┃                                            ┃
    ┃  _bookings.add(booking);                  ┃
    ┃  setLoading(false);                       ┃
    ┃  notifyListeners(); // 🔔 REBUILD !      ┃
    ┗━━━━━━━━━━━━━━━━━━━┬━━━━━━━━━━━━━━━━━━━━┛
                     │
🎉 INTERFACE UTILISATEUR
    ┏━━━━━━━━━━━━┴━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃  Consumer<BookingProvider> détecte       ┃
    ┃  le changement                            ┃
    ┃                                            ┃
    ┃  - Spinner disparaît                     ┃
    ┃  - SnackBar : "✅ Réservation créée !"     ┃
    ┃  - Navigation vers "Mes réservations"    ┃
    ┃  - Liste rebuilt avec nouvelle réservation┃
    ┃                                            ┃
    ┃  👤 L'utilisateur voit sa réservation    ┃
    ┃     avec le status "EN_ATTENTE"           ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

---

### 🔑 POINTS CLÉS DES RELATIONS

**À EXPLIQUER AU PROFESSEUR :**

**1. SÉPARATION FRONTEND / BACKEND**
- Frontend et Backend sont complètement indépendants
- Communication uniquement via HTTP/JSON
- Backend peut servir plusieurs clients (mobile, web, etc.)
- Frontend peut changer de backend facilement

**2. AUTHENTIFICATION AVEC JWT**
- Token généré au login
- Stocké de manière sécurisée dans le smartphone
- Envoyé automatiquement avec chaque requête
- Backend identifie l'utilisateur sans session

**3. VALIDATION MULTICOUCHE**
- Flutter : Validation UI (format, champs requis)
- Pydantic : Validation backend (types, contraintes)
- SQLAlchemy : Contraintes DB (unique, foreign keys)

**4. GESTION D'ÉTAT RÉACTIVE**
- Provider notifie les changements
- Widgets se reconstruisent automatiquement
- Pas de rafraîchissement manuel
- Interface toujours synchronisée

**5. BASE DE DONNÉES RELATIONNELLE**
- Tables liées par foreign keys
- Transactions atomiques (ACID)
- Cohérence des données garantie
- ORM simplifie les requêtes

**6. GESTION DES ERREURS**
- Chaque couche gère ses erreurs
- HTTP status codes (400, 401, 403, 404, 500)
- Messages d'erreur clairs pour l'utilisateur
- Rollback automatique en cas d'erreur DB

---

### 📖 RÉSUMÉ DE L'ARCHITECTURE COMPLÈTE

```
FLUTTER APP (Dart)          Backend (Python)        Database
  ┏━━━━━━━━━━━━━┓             ┏━━━━━━━━━━━━━┓        ┏━━━━━━━━┓
  ┃  UI Widgets  ┃             ┃  Routes API ┃        ┃  users  ┃
  ┃  (Screens)   ┃             ┃  (FastAPI)  ┃        ╠────────╢
  ┗━━━━━┬━━━━━━━┛             ┗━━━━┬━━━━━━━┛        ┃  trips  ┃
       │                          │                 ╠────────╢
  ┏━━━━┴━━━━━━━┓             ┏━━━━┴━━━━━━━┓        ┃bookings┃
  ┃  Providers  ┃             ┃  Business  ┃        ╠────────╢
  ┃ (State Mgmt)┃             ┃   Logic    ┃        ┃messages┃
  ┗━━━━┬━━━━━━━┛             ┗━━━━┬━━━━━━━┛        ┗━━━━━━━━┛
       │                          │
  ┏━━━━┴━━━━━━━┓             ┏━━━━┴━━━━━━━┓
  ┃  Services   ┃─── HTTP ─────────►┃ SQLAlchemy ┃── SQL ──► SQLite
  ┃ (API Calls) ┃             ┃    ORM     ┃
  ┗━━━━━━━━━━━━━┛             ┗━━━━━━━━━━━━━┛

  Models (Dart)               Models (Python)
  - UserModel                 - User (ORM)
  - TripModel                 - Trip (ORM)
  - BookingModel              - Booking (ORM)
```

---

#### 🔵 Côté CLIENT

**"Les clients ont accès à ces écrans :"**

1. **Écran d'accueil**
   - Liste des trajets disponibles
   - Barre de recherche (ville, date)
   - Carte avec localisation

2. **Créer une réservation**
   - Sélectionner un trajet
   - Formulaire : poids, description, adresses
   - Calcul du prix en temps réel
   - Bouton "Réserver"

3. **Mes réservations**
   - Liste avec status (En attente, Acceptée, Terminée)
   - Détails de chaque réservation
   - Actions : Annuler, Contacter transporteur

4. **Profil**
   - Photo de profil
   - Informations personnelles
   - Historique des réservations
   - Paramètres (langue, mode sombre)

5. **Messagerie**
   - Chat en temps réel avec transporteurs
   - Liste des conversations
   - Notifications de nouveaux messages

#### 🟢 Côté TRANSPORTEUR

**"Les transporteurs ont accès à ces écrans :"**

1. **Tableau de bord**
   - Statistiques (trajets actifs, revenus)
   - Prochains trajets
   - Demandes en attente

2. **Gérer mes trajets**
   - Liste des trajets créés
   - Créer un nouveau trajet (formulaire)
   - Modifier/Supprimer trajet

3. **Réservations reçues**
   - Liste des demandes (En attente, Acceptées)
   - Détails de chaque demande
   - Actions : Accepter / Refuser

4. **Profil transporteur**
   - Photo, informations
   - Évaluations/avis clients
   - Revenus totaux

5. **Messagerie**
   - Chat avec clients
   - Notifications

### Fonctionnalités clés

**"Voici les fonctionnalités techniques implémentées :"**

1. **Navigation**
   - Bottom Navigation Bar (5 onglets)
   - Navigation fluide entre écrans
   - Retour arrière intuitif

2. **Gestion d'état**
   - Provider pour état global
   - Réactivité en temps réel
   - Mises à jour automatiques

3. **Design**
   - Material Design 3
   - Mode sombre/clair
   - Animations fluides
   - Responsive (s'adapte à toutes tailles)

4. **Performance**
   - Lazy loading des images
   - Cache des données
   - Pagination des listes

5. **Localisation**
   - Multilingue (FR/EN/AR)
   - Google Maps intégré
   - Géolocalisation

---

# PARTIE 5 : DÉMONSTRATION EN DIRECT (5 minutes)

## 🎬 Script de démonstration

### 1️⃣ Lancement du Backend

**"Je vais d'abord démarrer le backend localement."**

```powershell
# Ouvrir terminal PowerShell
cd C:\Users\HAZEM\Wassaliparceldeliveryapp\wassali_app

# Lancer tout automatiquement
.\start_all.ps1
```

**Ce que fait le script :**
- ✅ Vérifie Python et Flutter
- ✅ Installe les dépendances backend
- ✅ Lance le serveur FastAPI sur http://localhost:8000
- ✅ Installe les dépendances Flutter
- ✅ Lance l'app mobile sur Chrome

**Montrer au professeur :**
- Terminal qui montre "Uvicorn running on http://localhost:8000"
- Ouvrir navigateur : http://localhost:8000/docs
- Montrer la documentation Swagger interactive
- Tester un endpoint (par exemple `/health`)

### 2️⃣ Démonstration API (Swagger)

**"Le backend expose une documentation interactive Swagger :"**

1. **Ouvrir** : http://localhost:8000/api/v1/docs
2. **Montrer** : Liste de tous les endpoints
3. **Tester** :
   - Cliquer sur `POST /auth/register`
   - "Try it out"
   - Remplir les données :
     ```json
     {
       "email": "demo@test.com",
       "password": "password123",
       "full_name": "Démo Utilisateur",
       "phone_number": "+33612345678",
       "role": "CLIENT"
     }
     ```
   - Execute
   - Montrer la réponse 201 Created

4. **Tester login** :
   - `POST /auth/login`
   - Email : demo@test.com / password123
   - Montrer le JWT token retourné

5. **Tester endpoint protégé** :
   - `GET /users/profile`
   - Copier le token dans "Authorize"
   - Execute
   - Montrer le profil retourné

### 3️⃣ Démonstration Application Mobile

**"L'application mobile se lance automatiquement sur Chrome :"**

#### Scénario CLIENT :

1. **Connexion**
   - Email : `client@test.com`
   - Password : `password123`
   - Cliquer "Se connecter"
   - Montrer : Transition vers écran d'accueil

2. **Explorer les trajets**
   - Voir liste des trajets disponibles
   - Carte avec localisations
   - Filtrer par ville/date

3. **Créer une réservation**
   - Sélectionner un trajet
   - Remplir formulaire :
     * Poids : 5 kg
     * Description : "Vêtements et cadeaux"
     * Adresses pickup/delivery
   - Voir prix calculé automatiquement
   - Cliquer "Réserver"
   - Montrer notification de succès

4. **Voir mes réservations**
   - Onglet "Réservations"
   - Liste avec status
   - Cliquer sur une réservation
   - Voir détails complets

5. **Messagerie**
   - Onglet "Messages"
   - Ouvrir conversation avec transporteur
   - Envoyer un message

6. **Profil**
   - Onglet "Profil"
   - Voir photo, informations
   - Modifier profil
   - Changer mode (sombre/clair)

#### Scénario TRANSPORTEUR :

1. **Déconnexion client** → **Connexion transporteur**
   - Email : `transporteur@test.com`
   - Password : `password123`

2. **Tableau de bord**
   - Voir statistiques
   - Trajets actifs
   - Demandes en attente

3. **Créer un trajet**
   - Bouton "Nouveau trajet"
   - Formulaire :
     * Départ : Paris
     * Arrivée : Tunis
     * Date départ : 10/01/2026
     * Poids disponible : 50 kg
     * Prix par kg : 5€
   - Créer
   - Voir trajet dans la liste

4. **Gérer réservations**
   - Onglet "Réservations"
   - Voir demande du client
   - Accepter la demande
   - Voir status changé

5. **Messagerie**
   - Répondre au client

### 4️⃣ Démonstration APK Android (Si temps)

**"L'application fonctionne aussi sur téléphone Android :"**

1. **Montrer le téléphone**
2. **Ouvrir l'app Wassali**
3. **Activer le serveur** (ouvrir web/activer_serveur.html sur PC)
4. **Connexion** sur le téléphone
5. **Montrer** : Interface mobile native
6. **Tester** : Créer réservation, chat, etc.

---

# QUESTIONS FRÉQUENTES DU PROFESSEUR

## 💡 Préparation aux questions

### Q1 : "Pourquoi avoir choisi Flutter ?"

**Réponse :**
> "Flutter permet de développer UNE application qui fonctionne sur Android ET iOS avec le même code. C'est très performant (60fps), a une grande communauté, et permet un développement rapide avec Hot Reload. C'est utilisé par Google, BMW, Alibaba."

### Q2 : "Pourquoi FastAPI et pas Django ?"

**Réponse :**
> "FastAPI est moderne, très rapide (basé sur Starlette/Pydantic), génère automatiquement la documentation OpenAPI/Swagger, et est idéal pour les APIs REST. C'est plus léger que Django et mieux adapté aux microservices."

### Q3 : "Comment gérez-vous la sécurité ?"

**Réponse :**
> "Plusieurs niveaux :
> 1. Authentification JWT (tokens expirables)
> 2. Hashage bcrypt des mots de passe
> 3. Validation Pydantic des données
> 4. Protection CSRF via tokens
> 5. HTTPS en production
> 6. ORM pour éviter SQL injection"

### Q4 : "L'application est-elle scalable ?"

**Réponse :**
> "Oui :
> - Backend stateless (peut avoir plusieurs instances)
> - Base de données relationnelle (PostgreSQL en prod)
> - API REST standard (peut ajouter load balancer)
> - Frontend mobile indépendant
> - Déployable sur cloud (Render, AWS, Azure)"

### Q5 : "Pourquoi le serveur gratuit perd les données ?"

**Réponse :**
> "C'est une limitation de Render.com gratuit qui utilise un système de fichiers éphémère. SQLite n'est pas persistant sur ce type d'hébergement. En production réelle, on utiliserait PostgreSQL avec stockage persistant. J'ai documenté cette limitation pour les testeurs."

### Q6 : "Avez-vous testé l'application ?"

**Réponse :**
> "Oui, plusieurs types de tests :
> - Tests unitaires des endpoints API
> - Tests d'intégration backend
> - Tests manuels de l'interface
> - Tests sur émulateur Android
> - Tests sur téléphone physique
> - Documentation des résultats dans RESULTATS_TESTS.md"

### Q7 : "Comment quelqu'un d'autre peut tester ?"

**Réponse :**
> "Trois façons :
> 1. Test local PC : clone repo + `.\start_all.ps1` (tout automatique)
> 2. Test APK : installer l'APK + activer serveur Render (1 minute)
> 3. Compilation APK : clone repo + `flutter build apk`
> Tout est documenté dans README.md et guides"

### Q8 : "Quelles sont les améliorations possibles ?"

**Réponse :**
> "Plusieurs axes :
> 1. Backend : PostgreSQL persistant, Redis pour cache, WebSockets pour chat temps réel
> 2. Frontend : Notifications push, géolocalisation temps réel, paiement intégré
> 3. Fonctionnalités : Système de reviews, tracking GPS, multi-devises
> 4. DevOps : CI/CD, monitoring, analytics
> 5. Tests : Tests automatisés complets, Postman"

---

# ⏱️ TIMING RECOMMANDÉ

| Section | Durée | Contenu |
|---------|-------|---------|
| Introduction | 2 min | Problématique, technologies, fonctionnalités |
| Architecture | 3 min | Schéma, séparation responsabilités, sécurité |
| **Backend détaillé** | **7-8 min** | Structure dossiers, modèles ORM, APIs, logique métier, exemples code |
| **Frontend détaillé** | **7-8 min** | Structure dossiers Flutter, services, providers, screens, widgets, exemples code |
| Démonstration | 5 min | Lancement, Swagger, app mobile, APK |
| **TOTAL** | **25-27 min** | + 5-10 min questions |

---

# ✅ CHECKLIST AVANT PRÉSENTATION

## 🔧 Technique

- [ ] Backend fonctionne : `cd web_src\backend && python main.py`
- [ ] Swagger accessible : http://localhost:8000/docs
- [ ] App Flutter lance : `flutter run -d chrome`
- [ ] Comptes de test OK : client@test.com / transporteur@test.com
- [ ] APK Android disponible si demandé
- [ ] Page activation serveur fonctionne

## 📄 Documentation

- [ ] README.md à jour
- [ ] GUIDE_TEST_APK_ANDROID.md disponible
- [ ] ARCHITECTURE.md lisible
- [ ] Scripts de lancement fonctionnels

## 🎤 Présentation

- [ ] Répéter le script 2-3 fois
- [ ] Chronométrer (environ 25-27 minutes)
- [ ] Préparer les réponses aux questions
- [ ] Avoir le schéma architectural sous les yeux
- [ ] Avoir la liste des endpoints API imprimée

---

# 📌 POINTS CLÉS À RETENIR

## 🌟 Forces du projet

1. ✅ **Architecture moderne** : Séparation frontend/backend propre
2. ✅ **Technologies actuelles** : Flutter + FastAPI (2024-2026)
3. ✅ **Sécurité implémentée** : JWT, hashage, validation
4. ✅ **Documentation complète** : 15+ fichiers MD
5. ✅ **Déploiement fonctionnel** : Backend sur Render, APK Android
6. ✅ **Code propre** : Structure claire, commentaires
7. ✅ **Testé** : PC + mobile
8. ✅ **Autonome** : Script de lancement automatique

## 💪 Ce qui impressionne

- Application **complète** et **fonctionnelle**
- Déployée en **production** (accessible via internet)
- APK **indépendant** (fonctionne sur n'importe quel Android)
- Documentation **professionnelle**
- Architecture **scalable** et **maintenable**

---

# 🎯 MESSAGE DE CLÔTURE

**"En conclusion, Wassali est une application moderne et complète qui répond à un besoin réel. L'architecture est professionnelle, la sécurité est prise en compte, et l'application est déployée et testable par n'importe qui. Le code est propre, documenté, et suivre les bonnes pratiques de développement. Je suis disponible pour toute question ou démonstration supplémentaire."**

---

**Bonne présentation ! 🚀**
