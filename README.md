# 🚚 Wassali - Application de Livraison de Colis

Application complète de livraison de colis avec **Frontend Mobile Flutter** et **Backend FastAPI**.

## 📋 Table des Matières

- [Fonctionnalités](#-fonctionnalités)
- [Architecture](#-architecture)
- [Prérequis](#-prérequis)
- [Installation Rapide](#-installation-rapide)
- [Lancement du Projet](#-lancement-du-projet)
- [Frontend Mobile](#-frontend-mobile-flutter)
- [Backend API](#-backend-api-fastapi)
- [Configuration](#-configuration)
- [Tests](#-tests)
- [Déploiement](#-déploiement)

---

## 🎯 Fonctionnalités

### 👥 Pour les Clients
- ✅ Inscription et connexion sécurisée
- ✅ Recherche de transporteurs disponibles
- ✅ Création de demandes de livraison
- ✅ Suivi des livraisons en temps réel
- ✅ Messagerie instantanée avec transporteurs
- ✅ Paiements sécurisés
- ✅ Système d'avis et notes
- ✅ Upload de photo de profil
- ✅ Multi-langues (FR/EN/AR)
- ✅ Mode sombre

### 🚛 Pour les Transporteurs
- ✅ Inscription et connexion sécurisée
- ✅ Création et gestion de trajets
- ✅ Tableau de bord avec statistiques
- ✅ Acceptation/refus de demandes
- ✅ Messagerie avec clients
- ✅ Gestion des revenus
- ✅ Upload de photo de profil
- ✅ Multi-langues (FR/EN/AR)
- ✅ Mode sombre

---

## 🏗️ Architecture

```
wassali_app/
├── lib/                    # Code source Flutter
│   ├── config/            # Configuration (API, routes)
│   ├── constants/         # Constantes (couleurs, textes)
│   ├── models/            # Modèles de données
│   ├── providers/         # Gestion d'état (Provider)
│   ├── screens/           # Écrans de l'application
│   ├── services/          # Services (API, Auth, Storage)
│   ├── utils/             # Utilitaires et helpers
│   └── widgets/           # Widgets réutilisables
│
├── web_src/
│   └── backend/           # Backend FastAPI
│       ├── app/
│       │   ├── api/       # Endpoints API
│       │   ├── core/      # Configuration core
│       │   ├── models/    # Modèles SQLAlchemy
│       │   └── schemas/   # Schémas Pydantic
│       └── requirements.txt
│
├── android/               # Configuration Android
├── ios/                   # Configuration iOS
├── web/                   # Configuration Web
└── README.md
```

---

## 💻 Prérequis

### Frontend Mobile
- **Flutter SDK** ≥ 3.10.4 - [Installer Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (inclus avec Flutter)
- **Android Studio** ou **Xcode** (pour émulateurs)
- **VS Code** avec extensions Flutter/Dart (recommandé)

### Backend API
- **Python** ≥ 3.9 - [Installer Python](https://www.python.org/downloads/)
- **pip** (gestionnaire de packages Python)
- **SQLite** (inclus avec Python)

### Outils
- **Git** - [Installer Git](https://git-scm.com/)
- Un éditeur de code (VS Code recommandé)

---

## ⚡ Installation Rapide

### 1️⃣ Cloner le Projet

```bash
git clone <URL_DU_REPO>
cd wassali_app
```

### 2️⃣ Installer le Backend

```bash
cd web_src/backend
pip install -r requirements.txt
```

### 3️⃣ Installer le Frontend

```bash
cd ../..  # Retour à la racine
flutter pub get
```

---

## 🚀 Lancement du Projet

### Option 1 : Lancement Automatique (Recommandé)

**Windows :**
```powershell
.\start_all.ps1
```

**Linux/Mac :**
```bash
chmod +x start_all.sh
./start_all.sh
```

### Option 2 : Lancement Manuel

#### Étape 1 : Démarrer le Backend

**Terminal 1 - Backend API :**
```bash
cd web_src/backend
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

✅ **Backend disponible sur :** `http://localhost:8000`  
📚 **Documentation Swagger :** `http://localhost:8000/docs`

#### Étape 2 : Démarrer le Frontend

**Terminal 2 - Application Mobile :**
```bash
# Depuis la racine du projet
flutter run -d chrome  # Pour navigateur web
# OU
flutter run -d <device_id>  # Pour émulateur/appareil
```

🔍 **Voir les appareils disponibles :**
```bash
flutter devices
```

---

## 📱 Frontend Mobile (Flutter)

### Structure du Code

```
lib/
├── main.dart                 # Point d'entrée
├── config/
│   ├── api_config.dart      # Configuration API
│   └── routes.dart          # Routes de navigation
├── constants/
│   └── app_colors.dart      # Palette de couleurs
├── models/
│   ├── user.dart            # Modèle utilisateur
│   ├── trip.dart            # Modèle trajet
│   └── reservation.dart     # Modèle réservation
├── providers/
│   ├── auth_provider.dart   # Authentification
│   ├── language_provider.dart  # Gestion langues
│   └── settings_provider.dart  # Paramètres
├── screens/
│   ├── auth/                # Écrans connexion/inscription
│   ├── client/              # Écrans client
│   ├── transporter/         # Écrans transporteur
│   └── shared/              # Écrans partagés
├── services/
│   ├── api_service.dart     # Client HTTP
│   ├── auth_service.dart    # Service auth
│   └── storage_service.dart # Stockage local
├── utils/
│   ├── app_localizations.dart  # Traductions
│   └── theme_extension.dart    # Extensions thème
└── widgets/                 # Composants réutilisables
```

### Commandes Utiles

```bash
# Lancer sur navigateur (développement)
flutter run -d chrome

# Lancer sur Android
flutter run -d <android_device_id>

# Lancer sur iOS
flutter run -d <ios_device_id>

# Build pour production Android
flutter build apk --release

# Build pour production iOS
flutter build ios --release

# Build pour web
flutter build web --release

# Nettoyer le cache
flutter clean
flutter pub get

# Analyser le code
flutter analyze

# Tests
flutter test
```

### Configuration API

Éditer `lib/config/api_config.dart` :

```dart
class ApiConfig {
  // Pour émulateur Android
  static const String baseUrl = 'http://10.0.2.2:8000';
  
  // Pour appareil physique (remplacer par votre IP)
  // static const String baseUrl = 'http://192.168.1.X:8000';
  
  // Pour web/navigateur
  // static const String baseUrl = 'http://localhost:8000';
}
```

### Langues Supportées

- 🇫🇷 Français (FR)
- 🇬🇧 Anglais (EN)
- 🇸🇦 Arabe (AR)

Changer de langue depuis : **Paramètres → Langue**

---

## 🔧 Backend API (FastAPI)

### Structure du Backend

```
web_src/backend/
├── app/
│   ├── main.py              # Application principale
│   ├── api/
│   │   └── v1/
│   │       └── endpoints/   # Endpoints API
│   │           ├── auth.py       # Authentification
│   │           ├── trips.py      # Trajets
│   │           ├── reservations.py  # Réservations
│   │           ├── users.py      # Utilisateurs
│   │           └── messages.py   # Messagerie
│   ├── core/
│   │   ├── config.py        # Configuration
│   │   ├── security.py      # Sécurité/JWT
│   │   └── database.py      # Base de données
│   ├── models/              # Modèles SQLAlchemy
│   │   ├── user.py
│   │   ├── trip.py
│   │   └── reservation.py
│   └── schemas/             # Schémas Pydantic
│       ├── user.py
│       ├── trip.py
│       └── reservation.py
├── wassali_test.db          # Base de données SQLite
└── requirements.txt         # Dépendances Python
```

### Endpoints Principaux

#### 🔐 Authentification
```http
POST   /api/v1/auth/login          # Connexion
POST   /api/v1/auth/register       # Inscription
POST   /api/v1/auth/logout         # Déconnexion
GET    /api/v1/auth/me             # Profil actuel
```

#### 👥 Utilisateurs
```http
GET    /api/v1/users/me            # Mon profil
PUT    /api/v1/users/me            # Modifier profil
PUT    /api/v1/users/me/profile-picture  # Upload photo
GET    /api/v1/users/stats         # Statistiques
```

#### 🚛 Trajets (Transporteurs)
```http
GET    /api/v1/trips               # Liste trajets
POST   /api/v1/trips               # Créer trajet
GET    /api/v1/trips/{id}          # Détails trajet
PUT    /api/v1/trips/{id}          # Modifier trajet
DELETE /api/v1/trips/{id}          # Supprimer trajet
```

#### 📦 Réservations
```http
GET    /api/v1/reservations        # Mes réservations
POST   /api/v1/reservations        # Créer réservation
PUT    /api/v1/reservations/{id}/status  # Changer statut
```

#### 💬 Messages
```http
GET    /api/v1/messages/conversations  # Liste conversations
GET    /api/v1/messages/{user_id}      # Messages avec utilisateur
POST   /api/v1/messages/{user_id}      # Envoyer message
```

### Documentation Interactive

Une fois le backend lancé, accéder à :

- **Swagger UI :** http://localhost:8000/docs
- **ReDoc :** http://localhost:8000/redoc

### Variables d'Environnement

Créer un fichier `.env` dans `web_src/backend/` :

```env
# Base de données
DATABASE_URL=sqlite:///./wassali_test.db

# Sécurité
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# CORS
BACKEND_CORS_ORIGINS=["http://localhost:3000","http://localhost:8080"]

# Email (optionnel)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password
```

### Commandes Backend

```bash
# Lancer le serveur
uvicorn app.main:app --reload --port 8000

# Lancer avec logs détaillés
uvicorn app.main:app --reload --log-level debug

# Créer des comptes de test
python create_test_user.py

# Réinitialiser les mots de passe
python reset_passwords.py
```

---

## ⚙️ Configuration

### URLs API selon l'environnement

| Environnement | URL Backend |
|---------------|-------------|
| **Web (Chrome)** | `http://localhost:8000` |
| **Émulateur Android** | `http://10.0.2.2:8000` |
| **Émulateur iOS** | `http://localhost:8000` |
| **Appareil physique** | `http://<VOTRE_IP>:8000` |

💡 **Trouver votre IP locale :**

**Windows :**
```powershell
ipconfig  # Chercher "IPv4 Address"
```

**Linux/Mac :**
```bash
ifconfig  # Chercher "inet"
# OU
ip addr show
```

---

## 🧪 Tests

### Comptes de Test

Après avoir lancé le backend, créer des comptes de test :

```bash
cd web_src/backend
python create_test_user.py
```

**Client :**
- Email : `client@test.com`
- Mot de passe : `password123`

**Transporteur :**
- Email : `transporteur@test.com`
- Mot de passe : `password123`

### Tester l'API

```bash
# Tester l'endpoint health
curl http://localhost:8000/health

# Tester la connexion
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"client@test.com","password":"password123"}'
```

---

## 📦 Déploiement

### Frontend Mobile

#### Android (Google Play)
```bash
flutter build appbundle --release
# Fichier généré : build/app/outputs/bundle/release/app-release.aab
```

#### iOS (App Store)
```bash
flutter build ios --release
# Ouvrir avec Xcode pour distribution
```

#### Web
```bash
flutter build web --release
# Déployer le dossier build/web/
```

### Backend API

#### Docker (Recommandé)

Créer `Dockerfile` dans `web_src/backend/` :

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

```bash
docker build -t wassali-backend .
docker run -p 8000:8000 wassali-backend
```

#### Serveur Linux (VPS)

```bash
# Installer dépendances
pip install -r requirements.txt

# Lancer avec Gunicorn
pip install gunicorn
gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000
```

---

## 🐛 Dépannage

### Problème : Backend inaccessible depuis le mobile

**Solution :** Vérifier l'URL dans `api_config.dart` et le firewall

### Problème : Hot reload ne fonctionne pas

**Solution :**
```bash
flutter clean
flutter pub get
flutter run
```

### Problème : Erreurs de dépendances Python

**Solution :**
```bash
pip install --upgrade pip
pip install -r requirements.txt --force-reinstall
```

### Problème : Image de profil ne se met pas à jour

**Solution :** Vider le cache de l'app ou redémarrer

---

## 📚 Documentation Supplémentaire

- [Guide de démarrage rapide](DEMARRAGE_RAPIDE.md)
- [Guide des widgets](GUIDE_WIDGETS.md)
- [Documentation backend](web_src/DOCUMENTATION.md)
- [Guide des tests](GUIDE_TEST.txt)

---

## 👥 Contribution

1. Fork le projet
2. Créer une branche (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Commit les changements (`git commit -m 'Ajout nouvelle fonctionnalité'`)
4. Push vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Ouvrir une Pull Request

---

## 📄 Licence

Ce projet est sous licence MIT.

---

## 📞 Support

Pour toute question ou problème, ouvrir une issue sur GitHub.

---

## 🎉 Changelog

### Version 1.0.0 (Janvier 2025)
- ✅ Application mobile complète (Flutter)
- ✅ Backend API complet (FastAPI)
- ✅ Multi-langues (FR/EN/AR)
- ✅ Mode sombre
- ✅ Upload de photos de profil
- ✅ Messagerie en temps réel
- ✅ Système de paiement
- ✅ Notifications
- ✅ Système d'avis

---

**Développé avec ❤️ pour Wassali**

2. **Configurer l'API Backend**
   - Ouvrez `lib/config/api_config.dart`
   - Modifiez `baseUrl` avec l'URL de votre backend

3. **Lancer l'application**
```bash
flutter run
```

## 📦 Dépendances Principales

- **provider**: Gestion d'état
- **dio**: Client HTTP
- **go_router**: Navigation
- **google_fonts**: Polices
- **google_maps_flutter**: Cartes
- **firebase**: Authentification et base de données
- **flutter_stripe**: Paiements

## 🎨 Design

- Material Design 3
- Palette de couleurs moderne (bleu, vert, orange)
- Typographie Google Fonts (Inter)
- Interface responsive

## 🔧 Configuration Backend

Modifiez `lib/config/api_config.dart`:
```dart
static const String baseUrl = 'http://localhost:3000/api';
```

## 📱 Build

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 📝 Version

**v1.0.0** - Version initiale - Copie conforme du frontend web

---

Copyright © 2026 Wassali. Tous droits réservés.
