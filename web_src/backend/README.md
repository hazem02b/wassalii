# 🚀 Wassali Backend API

Backend FastAPI pour l'application Wassali - Livraison de colis entre la Tunisie et l'Europe.

## 📋 Fonctionnalités

- ✅ **Authentification JWT** complète
- ✅ **Gestion des utilisateurs** (Clients & Transporteurs)
- ✅ **Gestion des trajets** avec recherche avancée
- ✅ **Gestion des réservations** avec tracking
- ✅ **Base de données PostgreSQL**
- ✅ **Documentation API automatique** (Swagger/ReDoc)
- ✅ **Validation Pydantic** pour tous les endpoints

## 🛠️ Stack Technique

- **Framework**: FastAPI 0.109+
- **Base de données**: PostgreSQL
- **ORM**: SQLAlchemy 2.0
- **Authentification**: JWT (python-jose)
- **Hashing**: bcrypt (passlib)
- **Validation**: Pydantic v2

## 📁 Structure du Projet

```
backend/
├── app/
│   ├── api/
│   │   └── v1/
│   │       ├── endpoints/
│   │       │   ├── auth.py          # Authentification
│   │       │   ├── trips.py         # Gestion trajets
│   │       │   └── bookings.py      # Gestion réservations
│   │       └── api.py               # Router principal
│   ├── core/
│   │   ├── config.py                # Configuration
│   │   └── security.py              # JWT & hashing
│   ├── db/
│   │   └── database.py              # Connexion DB
│   ├── models/
│   │   └── models.py                # Modèles SQLAlchemy
│   └── schemas/
│       └── schemas.py               # Schémas Pydantic
├── main.py                          # Point d'entrée
├── requirements.txt                 # Dépendances
├── .env.example                     # Template environnement
└── README.md                        # Ce fichier
```

## 🚀 Installation

### 1. Prérequis

- Python 3.9+
- PostgreSQL 12+
- pip

### 2. Installation de PostgreSQL

**Windows:**
```powershell
# Télécharger depuis: https://www.postgresql.org/download/windows/
# Ou avec chocolatey:
choco install postgresql

# Démarrer le service
net start postgresql
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
```

**macOS:**
```bash
brew install postgresql
brew services start postgresql
```

### 3. Créer la base de données

```bash
# Se connecter à PostgreSQL
psql -U postgres

# Créer la base de données et l'utilisateur
CREATE DATABASE wassali_db;
CREATE USER wassali_user WITH PASSWORD 'wassali_password';
GRANT ALL PRIVILEGES ON DATABASE wassali_db TO wassali_user;
\q
```

### 4. Installer les dépendances Python

```powershell
# Créer un environnement virtuel
cd backend
python -m venv venv

# Activer l'environnement virtuel
# Windows PowerShell:
.\venv\Scripts\Activate.ps1

# Linux/macOS:
source venv/bin/activate

# Installer les dépendances
pip install -r requirements.txt
```

### 5. Configuration

```powershell
# Copier le fichier d'environnement
cp .env.example .env

# Éditer .env avec vos paramètres
# Notamment:
# - DATABASE_URL
# - SECRET_KEY (générer une clé aléatoire sécurisée)
```

**Générer une SECRET_KEY sécurisée:**
```python
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

### 6. Lancer le serveur

```powershell
# Mode développement (avec rechargement automatique)
python main.py

# Ou avec uvicorn directement:
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Le serveur sera accessible sur:
- **API**: http://localhost:8000
- **Documentation Swagger**: http://localhost:8000/api/v1/docs
- **Documentation ReDoc**: http://localhost:8000/api/v1/redoc

## 📚 Documentation API

### Endpoints principaux

#### Authentification (`/api/v1/auth`)

```http
POST   /auth/register      # Inscription
POST   /auth/login         # Connexion
GET    /auth/me            # Profil utilisateur
PUT    /auth/me            # Modifier profil
GET    /auth/users/{id}    # Info utilisateur
```

#### Trajets (`/api/v1/trips`)

```http
POST   /trips/                            # Créer un trajet
GET    /trips/                            # Rechercher trajets
GET    /trips/{id}                        # Détails trajet
PUT    /trips/{id}                        # Modifier trajet
DELETE /trips/{id}                        # Supprimer trajet
GET    /trips/transporter/{transporter_id} # Trajets d'un transporteur
```

#### Réservations (`/api/v1/bookings`)

```http
POST   /bookings/                         # Créer réservation
GET    /bookings/                         # Mes réservations
GET    /bookings/{id}                     # Détails réservation
GET    /bookings/tracking/{tracking_number} # Tracking
PUT    /bookings/{id}                     # Modifier statut
DELETE /bookings/{id}                     # Annuler réservation
```

## 🔐 Authentification

L'API utilise JWT (JSON Web Tokens) pour l'authentification.

### Exemple d'utilisation:

```python
import requests

# 1. Inscription
response = requests.post("http://localhost:8000/api/v1/auth/register", json={
    "email": "client@example.com",
    "password": "securepassword123",
    "first_name": "Ahmed",
    "last_name": "Ben Ali",
    "role": "client",
    "phone": "+21612345678"
})

data = response.json()
token = data["access_token"]

# 2. Utiliser le token pour les requêtes authentifiées
headers = {"Authorization": f"Bearer {token}"}

response = requests.get("http://localhost:8000/api/v1/auth/me", headers=headers)
user = response.json()
```

## 🗃️ Modèles de données

### User
- Clients et Transporteurs
- Authentification sécurisée
- Ratings et statistiques

### Trip
- Trajets créés par les transporteurs
- Origine/Destination
- Capacité et tarification

### Booking
- Réservations des clients
- Tracking number unique
- Statuts multiples

### Review, Message, Notification
- Avis clients
- Messagerie entre utilisateurs
- Notifications en temps réel

## 🧪 Tests

```powershell
# Installer pytest
pip install pytest pytest-asyncio httpx

# Lancer les tests
pytest

# Avec couverture
pytest --cov=app tests/
```

## 📊 Base de données

### Migrations avec Alembic

```powershell
# Initialiser Alembic (déjà fait)
alembic init alembic

# Créer une migration
alembic revision --autogenerate -m "Description"

# Appliquer les migrations
alembic upgrade head

# Revenir en arrière
alembic downgrade -1
```

## 🔧 Variables d'environnement

```env
# Database
DATABASE_URL=postgresql://wassali_user:wassali_password@localhost:5432/wassali_db

# Security
SECRET_KEY=your-super-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# API
DEBUG=True
ALLOWED_ORIGINS=http://localhost:5173,http://localhost:3000

# File Upload
MAX_FILE_SIZE=10485760
UPLOAD_DIR=./uploads
```

## 📝 Exemples d'utilisation

### Créer un trajet (Transporteur)

```python
headers = {"Authorization": f"Bearer {token}"}

trip_data = {
    "origin_city": "Tunis",
    "origin_country": "Tunisia",
    "destination_city": "Paris",
    "destination_country": "France",
    "departure_date": "2025-01-15T10:00:00",
    "max_weight": 50.0,
    "price_per_kg": 15.0,
    "description": "Voyage régulier Tunis-Paris",
    "accepted_items": ["Documents", "Vêtements", "Électronique"]
}

response = requests.post(
    "http://localhost:8000/api/v1/trips/",
    json=trip_data,
    headers=headers
)
```

### Rechercher des trajets

```python
params = {
    "origin_city": "Tunis",
    "destination_city": "Paris",
    "min_weight": 5.0,
    "max_price_per_kg": 20.0
}

response = requests.get(
    "http://localhost:8000/api/v1/trips/",
    params=params
)
trips = response.json()
```

### Créer une réservation (Client)

```python
headers = {"Authorization": f"Bearer {client_token}"}

booking_data = {
    "trip_id": 1,
    "weight": 10.0,
    "item_type": "Documents",
    "description": "Dossiers importants",
    "pickup_address": "10 Avenue Habib Bourguiba",
    "pickup_city": "Tunis",
    "delivery_address": "25 Rue de Rivoli",
    "delivery_city": "Paris",
    "recipient_name": "Marie Dupont",
    "recipient_phone": "+33612345678"
}

response = requests.post(
    "http://localhost:8000/api/v1/bookings/",
    json=booking_data,
    headers=headers
)
booking = response.json()
tracking_number = booking["tracking_number"]
```

## 🚨 Gestion des erreurs

L'API retourne des codes HTTP standard:

- `200` - Success
- `201` - Created
- `204` - No Content
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Validation Error
- `500` - Internal Server Error

## 🔒 Sécurité

- ✅ Mots de passe hashés avec bcrypt
- ✅ JWT tokens avec expiration
- ✅ CORS configuré
- ✅ Validation des inputs avec Pydantic
- ✅ Protection SQL injection (SQLAlchemy ORM)
- ✅ Gestion des permissions par rôle

## 📈 Performance

- Connection pooling PostgreSQL
- Pagination sur tous les endpoints de liste
- Indexes sur les colonnes fréquemment recherchées
- Lazy loading des relations

## 🤝 Contribution

1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit vos changements (`git commit -m 'Add AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📞 Support

Pour toute question, contactez l'équipe de développement.

## 📜 Licence

MIT License - Voir le fichier LICENSE pour plus de détails.
