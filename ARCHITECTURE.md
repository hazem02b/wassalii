# 🏗️ Architecture du Projet Wassali

## 📊 Vue d'Ensemble

```
┌─────────────────────────────────────────────────┐
│         Application Mobile Flutter              │
│  (Android, iOS, Web)                           │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │  Client  │  │Transport.│  │  Shared  │     │
│  │  Screens │  │  Screens │  │  Widgets │     │
│  └──────────┘  └──────────┘  └──────────┘     │
│       │             │              │            │
│  ┌────▼─────────────▼──────────────▼────┐      │
│  │         Providers (State)            │      │
│  │  Auth | Language | Settings          │      │
│  └──────────────────┬───────────────────┘      │
│                     │                           │
│  ┌──────────────────▼───────────────────┐      │
│  │           Services Layer             │      │
│  │  API | Auth | Storage | User         │      │
│  └──────────────────┬───────────────────┘      │
└────────────────────┬────────────────────────────┘
                     │ HTTP/REST
                     │
┌────────────────────▼────────────────────────────┐
│            Backend API (FastAPI)                │
│  ┌──────────────────────────────────────┐       │
│  │         API Endpoints (v1)           │       │
│  │  Auth | Users | Trips | Reservations│       │
│  └──────────────┬───────────────────────┘       │
│                 │                               │
│  ┌──────────────▼───────────────────────┐       │
│  │        Business Logic Layer          │       │
│  │  Validation | Authorization | Rules  │       │
│  └──────────────┬───────────────────────┘       │
│                 │                               │
│  ┌──────────────▼───────────────────────┐       │
│  │      Data Access Layer (ORM)         │       │
│  │      SQLAlchemy Models               │       │
│  └──────────────┬───────────────────────┘       │
└─────────────────┬───────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────┐
│         Base de Données (SQLite)                │
│  Tables: users | trips | reservations | ...     │
└─────────────────────────────────────────────────┘
```

---

## 📱 Frontend - Architecture Flutter

### Couches de l'Application

#### 1. Presentation Layer (Screens & Widgets)

```
lib/screens/
├── auth/                   # Authentification
│   ├── login_screen.dart
│   ├── register_screen.dart
│   └── role_selection_screen.dart
│
├── client/                 # Interfaces Client
│   ├── home_client_screen.dart
│   ├── search_screen.dart
│   ├── reservations_screen.dart
│   └── profile_screen.dart
│
├── transporter/            # Interfaces Transporteur
│   ├── transporter_dashboard_screen.dart
│   ├── create_trip_screen.dart
│   ├── trips_screen.dart
│   └── transporter_profile_screen.dart
│
└── shared/                 # Écrans partagés
    ├── messages_screen.dart
    ├── settings_screen.dart
    └── notifications_screen.dart
```

**Responsabilités :**
- Affichage UI
- Gestion des interactions utilisateur
- Navigation
- Appels aux Providers

#### 2. State Management Layer (Providers)

```dart
// Pattern Provider pour la gestion d'état

┌─────────────────────────────────────┐
│        ChangeNotifier               │
│  ┌───────────┐  ┌────────────┐    │
│  │   Auth    │  │  Language  │    │
│  │ Provider  │  │  Provider  │    │
│  └─────┬─────┘  └──────┬─────┘    │
│        │                │           │
│    Notifies         Notifies       │
│        │                │           │
│  ┌─────▼─────┐  ┌──────▼─────┐    │
│  │  Widgets  │  │  Widgets   │    │
│  └───────────┘  └────────────┘    │
└─────────────────────────────────────┘
```

**Providers Principaux :**

```dart
// AuthProvider - Gestion authentification
class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool get isAuthenticated => _currentUser != null;
  
  Future<bool> login(String email, String password);
  Future<void> logout();
  Future<void> refreshCurrentUser();
}

// LanguageProvider - Gestion langues
class LanguageProvider with ChangeNotifier {
  Locale _locale = Locale('fr');
  
  void changeLanguage(String code);
  Locale get locale => _locale;
}

// SettingsProvider - Paramètres app
class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = false;
  
  void toggleDarkMode();
  bool get isDarkMode => _isDarkMode;
}
```

#### 3. Business Logic Layer (Services)

```
lib/services/
├── api_service.dart         # Client HTTP générique
├── auth_service.dart        # Logique authentification
├── user_service.dart        # Opérations utilisateurs
├── trip_service.dart        # Opérations trajets
├── reservation_service.dart # Opérations réservations
└── storage_service.dart     # Stockage local (SharedPreferences)
```

**Architecture Service :**

```dart
class ApiService {
  final Dio _dio;
  
  // Méthodes génériques
  Future<ApiResponse> get(String endpoint);
  Future<ApiResponse> post(String endpoint, {dynamic data});
  Future<ApiResponse> put(String endpoint, {dynamic data});
  Future<ApiResponse> delete(String endpoint);
}

class UserService {
  final ApiService _apiService;
  
  // Méthodes métier
  Future<User> getCurrentUser();
  Future<void> updateProfile(Map<String, dynamic> data);
  Future<void> updateProfilePicture(String base64Image);
}
```

#### 4. Data Layer (Models)

```dart
// Modèles de données immutables

class User {
  final String id;
  final String email;
  final String name;
  final UserType userType;
  final String? avatar;
  
  // Factory constructor depuis JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      userType: UserType.fromString(json['user_type']),
      avatar: json['avatar'],
    );
  }
  
  // Conversion vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'user_type': userType.toString(),
      'avatar': avatar,
    };
  }
}
```

### Flux de Données

```
User Action
    ↓
Widget (onPressed, onChanged, etc.)
    ↓
Provider Method
    ↓
Service Method
    ↓
API Service (HTTP Request)
    ↓
Backend API
    ↓
Response
    ↓
Service (Parse & Transform)
    ↓
Provider (Update State)
    ↓
notifyListeners()
    ↓
Widgets Rebuild
```

**Exemple Complet :**

```dart
// 1. User clicks login button
ElevatedButton(
  onPressed: () async {
    // 2. Call Provider
    final success = await authProvider.login(email, password);
    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  },
  child: Text('Connexion'),
)

// 3. Provider calls Service
class AuthProvider {
  Future<bool> login(String email, String password) async {
    _currentUser = await _authService.login(email, password);
    notifyListeners(); // 6. Notify listeners
    return true;
  }
}

// 4. Service makes API call
class AuthService {
  Future<User> login(String email, String password) async {
    final response = await _apiService.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    // 5. Parse response
    return User.fromJson(response.data);
  }
}
```

---

## 🔧 Backend - Architecture FastAPI

### Layered Architecture

#### 1. API Layer (Routes/Endpoints)

```python
# app/api/v1/endpoints/users.py

@router.get("/me", response_model=UserResponse)
async def get_current_user(
    current_user: User = Depends(get_current_user),
) -> User:
    """Get current user profile."""
    return current_user

@router.put("/me", response_model=UserResponse)
async def update_user(
    user_update: UserUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> User:
    """Update user profile."""
    return user_service.update(db, current_user.id, user_update)
```

**Responsabilités :**
- Définir les routes HTTP
- Valider les requêtes (Pydantic)
- Gérer les dépendances (auth, db)
- Retourner les réponses

#### 2. Business Logic Layer (Services)

```python
# app/services/user_service.py

class UserService:
    def get_by_id(self, db: Session, user_id: str) -> User:
        """Get user by ID."""
        user = db.query(User).filter(User.id == user_id).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        return user
    
    def update(self, db: Session, user_id: str, data: UserUpdate) -> User:
        """Update user."""
        user = self.get_by_id(db, user_id)
        
        # Business rules
        if data.email and data.email != user.email:
            if self.email_exists(db, data.email):
                raise HTTPException(400, "Email already exists")
        
        # Update fields
        for field, value in data.dict(exclude_unset=True).items():
            setattr(user, field, value)
        
        db.commit()
        db.refresh(user)
        return user
```

**Responsabilités :**
- Logique métier
- Validation complexe
- Règles de gestion
- Orchestration

#### 3. Data Access Layer (Models & Schemas)

```python
# app/models/user.py (SQLAlchemy)

class User(Base):
    __tablename__ = "users"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid4()))
    email = Column(String, unique=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    name = Column(String)
    user_type = Column(String, nullable=False)  # client, transporter
    avatar = Column(Text, nullable=True)
    
    # Relations
    trips = relationship("Trip", back_populates="transporter")
    reservations = relationship("Reservation", back_populates="client")
```

```python
# app/schemas/user.py (Pydantic)

class UserBase(BaseModel):
    email: EmailStr
    name: str
    user_type: str

class UserCreate(UserBase):
    password: str

class UserUpdate(BaseModel):
    name: Optional[str]
    phone: Optional[str]
    avatar: Optional[str]

class UserResponse(UserBase):
    id: str
    avatar: Optional[str]
    
    class Config:
        orm_mode = True
```

### Request Flow

```
HTTP Request
    ↓
FastAPI Router
    ↓
Dependency Injection
│   ├── get_db() → Database Session
│   └── get_current_user() → User Authentication
    ↓
Endpoint Function
    ↓
Pydantic Validation
    ↓
Service Layer (Business Logic)
    ↓
SQLAlchemy ORM
    ↓
Database (SQLite)
    ↓
Response (via Pydantic)
    ↓
HTTP Response (JSON)
```

### Security Architecture

```python
# JWT Token Flow

1. Login
   POST /api/v1/auth/login
   { email, password }
        ↓
   Verify password (bcrypt)
        ↓
   Generate JWT Token
   {
     "sub": user_id,
     "exp": timestamp,
     "type": "access"
   }
        ↓
   Return { access_token, token_type }

2. Protected Endpoint
   GET /api/v1/users/me
   Headers: { Authorization: "Bearer <token>" }
        ↓
   Extract token from header
        ↓
   Decode & verify JWT
        ↓
   Get user from database
        ↓
   Return user data
```

---

## 🗄️ Base de Données

### Schéma SQLite

```sql
-- Users Table
CREATE TABLE users (
    id TEXT PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    hashed_password TEXT NOT NULL,
    name TEXT,
    phone TEXT,
    user_type TEXT NOT NULL,  -- 'client' or 'transporter'
    avatar TEXT,  -- base64 encoded image
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trips Table (Transporteur)
CREATE TABLE trips (
    id TEXT PRIMARY KEY,
    transporter_id TEXT REFERENCES users(id),
    departure TEXT NOT NULL,
    destination TEXT NOT NULL,
    departure_date DATE NOT NULL,
    available_weight FLOAT NOT NULL,
    price_per_kg FLOAT NOT NULL,
    status TEXT DEFAULT 'available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reservations Table (Client)
CREATE TABLE reservations (
    id TEXT PRIMARY KEY,
    client_id TEXT REFERENCES users(id),
    trip_id TEXT REFERENCES trips(id),
    package_weight FLOAT NOT NULL,
    total_price FLOAT NOT NULL,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Messages Table
CREATE TABLE messages (
    id TEXT PRIMARY KEY,
    sender_id TEXT REFERENCES users(id),
    receiver_id TEXT REFERENCES users(id),
    content TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Relations

```
users (1) ──< trips (N)
  │
  └──< reservations (N)
  │
  └──< messages (N)

trips (1) ──< reservations (N)
```

---

## 🔐 Sécurité

### Authentication Flow

1. **Inscription** : Mot de passe hashé avec bcrypt
2. **Connexion** : Vérification hash + génération JWT
3. **Requêtes protégées** : Validation JWT à chaque requête
4. **Refresh** : Régénération token si expiré

### Protection des Données

- Mots de passe : **bcrypt hash** (jamais en clair)
- Tokens : **JWT avec expiration**
- API : **CORS configuré**
- Upload : **Validation taille et type de fichiers**

---

## 🌍 Internationalisation

### Structure i18n

```dart
class AppLocalizations {
  final Locale _locale;
  
  String get hello {
    switch (_locale.languageCode) {
      case 'fr': return 'Bonjour';
      case 'en': return 'Hello';
      case 'ar': return 'مرحبا';
      default: return 'Bonjour';
    }
  }
}
```

### Langues Supportées

- 🇫🇷 Français (FR) - Par défaut
- 🇬🇧 Anglais (EN)
- 🇸🇦 Arabe (AR) - RTL supporté

---

## 🎨 Theming

### Dark Mode Implementation

```dart
// Theme Extension
extension ContextExtension on BuildContext {
  bool get isDarkMode => 
      Theme.of(this).brightness == Brightness.dark;
  
  Color get backgroundColor => 
      isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
}

// Usage
Container(
  color: context.backgroundColor,
  child: Text(
    'Hello',
    style: TextStyle(
      color: context.isDarkMode ? Colors.white : Colors.black,
    ),
  ),
)
```

---

## 🚀 Performance

### Optimisations Frontend

1. **Lazy Loading** : Chargement différé des écrans
2. **Image Caching** : Cache avec ValueKey
3. **State Management** : Provider pour éviter rebuilds inutiles
4. **Pagination** : Listes infinies pour grandes données

### Optimisations Backend

1. **Connection Pooling** : Réutilisation connexions DB
2. **Lazy Loading** : Relations chargées à la demande
3. **Indexation** : Index sur colonnes fréquemment requêtées
4. **Caching** : Peut ajouter Redis pour cache distribué

---

**Documentation maintenue par l'équipe Wassali 🚚💙**
