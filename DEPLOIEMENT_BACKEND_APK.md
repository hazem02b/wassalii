# 🚀 Guide Déploiement Backend + APK Android

## 🎯 Objectif : APK fonctionnel sur TOUS les téléphones

Ce guide vous permet de déployer le backend sur un serveur et créer un APK fonctionnel.

---

## 📋 Plan d'action

1. ✅ Déployer le backend sur un serveur (gratuit)
2. ✅ Configurer l'URL du serveur dans l'app
3. ✅ Compiler l'APK Android
4. ✅ Tester sur téléphone

---

## 🌐 Option 1 : Render.com (RECOMMANDÉ - Gratuit)

### Étape 1 : Préparer le backend

Créez `web_src/backend/render.yaml` :
```yaml
services:
  - type: web
    name: wassali-backend
    env: python
    buildCommand: pip install -r requirements.txt
    startCommand: uvicorn main:app --host 0.0.0.0 --port $PORT
    envVars:
      - key: DATABASE_URL
        sync: false
      - key: SECRET_KEY
        generateValue: true
```

### Étape 2 : Déployer sur Render

1. Allez sur https://render.com
2. Créez un compte (gratuit)
3. "New +" → "Blueprint"
4. Connectez votre repo GitHub
5. Sélectionnez `render.yaml`
6. Cliquez "Apply"

**Vous obtenez une URL** : `https://wassali-backend-xxxx.onrender.com`

### Étape 3 : Mettre à jour l'app

Dans `lib/config/api_config.dart` :
```dart
static const String _productionUrl = 'https://wassali-backend-xxxx.onrender.com/api/v1';
static const bool isDevelopmentMode = false;  // MODE PRODUCTION
```

### Étape 4 : Compiler l'APK

```powershell
flutter build apk --release
```

APK dans : `build/app/outputs/flutter-apk/app-release.apk`

---

## 🌐 Option 2 : Railway.app (Gratuit)

### Étape 1 : Fichier de config

Créez `web_src/backend/railway.json` :
```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "uvicorn main:app --host 0.0.0.0 --port $PORT",
    "restartPolicyType": "ON_FAILURE"
  }
}
```

### Étape 2 : Déployer

1. https://railway.app
2. "Start a New Project" → "Deploy from GitHub repo"
3. Sélectionnez votre repo
4. Root directory : `web_src/backend`

**URL** : `https://wassali-backend-production.up.railway.app`

---

## 🌐 Option 3 : Fly.io (Gratuit)

### Étape 1 : Installer Fly CLI

```powershell
powershell -Command "iwr https://fly.io/install.ps1 -useb | iex"
```

### Étape 2 : Créer app

```powershell
cd web_src\backend
fly launch
# Choisir un nom : wassali-backend
# Choisir région proche (Europe)
```

### Étape 3 : Déployer

```powershell
fly deploy
```

**URL** : `https://wassali-backend.fly.dev`

---

## 🌐 Option 4 : Heroku (Payant mais simple)

### Étape 1 : Créer Procfile

Dans `web_src/backend/Procfile` :
```
web: uvicorn main:app --host 0.0.0.0 --port $PORT
```

### Étape 2 : Déployer

```powershell
heroku login
cd web_src\backend
heroku create wassali-backend
git push heroku main
```

**URL** : `https://wassali-backend.herokuapp.com`

---

## 📱 Compilation de l'APK

### Méthode 1 : APK Simple (Recommandé)

```powershell
# 1. Configurer l'URL du serveur
# Modifier lib/config/api_config.dart :
# static const bool isDevelopmentMode = false;
# static const String _productionUrl = 'https://VOTRE_URL.com/api/v1';

# 2. Compiler
flutter build apk --release

# 3. Récupérer l'APK
# Fichier : build/app/outputs/flutter-apk/app-release.apk
```

### Méthode 2 : APK Split par architecture (Plus petit)

```powershell
flutter build apk --split-per-abi --release
```

Génère 3 APK (un par architecture) :
- `app-armeabi-v7a-release.apk` (32-bit)
- `app-arm64-v8a-release.apk` (64-bit) ← La plupart des téléphones
- `app-x86_64-release.apk` (Émulateurs)

### Méthode 3 : App Bundle (Pour Google Play)

```powershell
flutter build appbundle --release
```

---

## 🔧 Configuration complète

### 1. Variables d'environnement backend

Créez `.env` sur votre serveur :
```env
DATABASE_URL=postgresql://user:pass@host/db
SECRET_KEY=votre_cle_secrete_super_longue_et_aleatoire
ALLOWED_ORIGINS=*
```

### 2. Base de données

Pour production, utilisez PostgreSQL :

**Render** : Base PostgreSQL gratuite incluse
**Railway** : Ajoutez PostgreSQL depuis le dashboard
**Fly.io** : `fly postgres create`

### 3. Migration SQLite → PostgreSQL

Si vous avez des données à migrer :
```powershell
pip install sqlite3-to-postgres
sqlite3-to-postgres wassali_test.db postgresql://user:pass@host/db
```

---

## ✅ Checklist de déploiement

### Backend :
- [ ] Backend déployé sur serveur
- [ ] URL fonctionnelle (teste avec `/health`)
- [ ] Base de données configurée
- [ ] Variables d'environnement définies
- [ ] CORS configuré pour autoriser l'app mobile

### Application :
- [ ] `isDevelopmentMode = false` dans api_config.dart
- [ ] URL de production correcte
- [ ] APK compilé en mode release
- [ ] APK testé sur téléphone réel
- [ ] Comptes de test créés sur le serveur

---

## 🧪 Tester le déploiement

### 1. Tester le backend

```powershell
# Health check
curl https://votre-url.com/health

# Documentation
# Ouvrir : https://votre-url.com/docs
```

### 2. Tester l'APK

1. Transférez l'APK sur votre téléphone
2. Installez (autorisez les sources inconnues)
3. Ouvrez l'app
4. Testez login avec `client@test.com` / `password123`

---

## 💰 Coûts

| Plateforme | Gratuit | Limites | Payant |
|------------|---------|---------|--------|
| **Render.com** | ✅ | 750h/mois | $7/mois |
| **Railway** | ✅ | $5 crédit/mois | $5/mois |
| **Fly.io** | ✅ | 3 VMs | $5-10/mois |
| **Heroku** | ❌ | - | $7/mois |

**Recommandation** : Render.com (gratuit illimité avec quelques limitations)

---

## 🔐 Sécurité Production

### 1. Changer le SECRET_KEY

```python
# Ne JAMAIS utiliser la même clé qu'en dev !
import secrets
print(secrets.token_urlsafe(32))
```

### 2. Activer HTTPS

Automatique sur Render/Railway/Fly/Heroku ✅

### 3. Configurer CORS

Dans `web_src/backend/app/core/config.py` :
```python
ALLOWED_ORIGINS = [
    "https://votre-domaine-frontend.com",
    # Pas "*" en production !
]
```

### 4. Rate Limiting

Installez :
```bash
pip install slowapi
```

---

## 📝 Script de déploiement automatique

Créez `deploy.ps1` :
```powershell
# Configuration
$SERVER_URL = "https://wassali-backend.onrender.com"

# 1. Mettre à jour la config
Write-Host "Configuration pour production..." -ForegroundColor Cyan
# Modifier api_config.dart automatiquement ici

# 2. Compiler l'APK
Write-Host "Compilation de l'APK..." -ForegroundColor Cyan
flutter build apk --release

# 3. Afficher le résultat
Write-Host "✅ APK prêt !" -ForegroundColor Green
Write-Host "Emplacement : build/app/outputs/flutter-apk/app-release.apk"
```

---

## 🆘 Dépannage

### Erreur CORS
Ajoutez dans main.py :
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En dev seulement !
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### Base de données non créée
```python
# Dans main.py, au démarrage
Base.metadata.create_all(bind=engine)
```

### Port déjà utilisé
Les services cloud gèrent le port automatiquement via `$PORT`

---

## 📚 Ressources

- **Render** : https://render.com/docs
- **Railway** : https://docs.railway.app
- **Fly.io** : https://fly.io/docs
- **Flutter Release** : https://docs.flutter.dev/deployment/android

---

## 🎯 Résumé Ultra-Rapide

```powershell
# 1. Déployer backend sur Render.com
# → Vous obtenez : https://wassali-backend-xxxx.onrender.com

# 2. Modifier lib/config/api_config.dart
# isDevelopmentMode = false
# _productionUrl = 'https://wassali-backend-xxxx.onrender.com/api/v1'

# 3. Compiler APK
flutter build apk --release

# 4. Récupérer et installer
# build/app/outputs/flutter-apk/app-release.apk
```

**L'APK fonctionne maintenant sur TOUS les téléphones Android !** ✅

---

**Dernière mise à jour** : 5 Janvier 2026
