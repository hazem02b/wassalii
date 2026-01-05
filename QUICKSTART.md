# ⚡ Guide de Démarrage Ultra-Rapide - Wassali

## 🚀 Lancement en 3 Minutes

### 1️⃣ Cloner le Projet (30 secondes)

```bash
git clone <URL_DU_REPO>
cd wassali_app
```

### 2️⃣ Lancer Automatiquement (2 minutes)

**Windows :**
```powershell
.\start_all.ps1
```

**Linux/Mac :**
```bash
chmod +x start_all.sh
./start_all.sh
```

**C'est tout ! 🎉** L'application s'ouvre automatiquement dans Chrome.

---

## 🔑 Se Connecter

### Comptes de Test

**Client :**
- Email : `client@test.com`
- Mot de passe : `password123`

**Transporteur :**
- Email : `transporteur@test.com`  
- Mot de passe : `password123`

---

## 📍 URLs Importantes

| Service | URL |
|---------|-----|
| **Application** | Ouvre automatiquement dans Chrome |
| **Backend API** | http://localhost:8000 |
| **Documentation API** | http://localhost:8000/docs |

---

## 🛠️ Lancement Manuel (si script automatique ne fonctionne pas)

### Terminal 1 - Backend

```bash
cd web_src/backend
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

### Terminal 2 - Frontend

```bash
flutter pub get
flutter run -d chrome
```

---

## ❓ Problèmes Courants

### Le backend ne démarre pas

**Solution :**
```bash
cd web_src/backend
pip install --upgrade pip
pip install -r requirements.txt --force-reinstall
```

### L'app Flutter ne se lance pas

**Solution :**
```bash
flutter clean
flutter pub get
flutter run -d chrome
```

### Erreur "No device found"

**Solution :**
```bash
# Voir les appareils disponibles
flutter devices

# Lancer sur Chrome
flutter run -d chrome
```

### Le backend ne répond pas depuis le mobile

Éditer `lib/config/api_config.dart` :

```dart
// Pour émulateur Android
static const String baseUrl = 'http://10.0.2.2:8000';

// Pour appareil physique (remplacer par votre IP)
static const String baseUrl = 'http://192.168.1.X:8000';
```

**Trouver votre IP :**
```bash
# Windows
ipconfig

# Linux/Mac
ifconfig
```

---

## 🎯 Fonctionnalités à Tester

### En tant que Client
1. ✅ Créer un compte client
2. ✅ Rechercher des transporteurs
3. ✅ Créer une demande de livraison
4. ✅ Envoyer des messages
5. ✅ Upload photo de profil
6. ✅ Changer la langue (FR/EN/AR)
7. ✅ Activer le mode sombre

### En tant que Transporteur
1. ✅ Créer un compte transporteur
2. ✅ Créer un trajet
3. ✅ Voir le tableau de bord
4. ✅ Accepter des demandes
5. ✅ Gérer les livraisons
6. ✅ Upload photo de profil

---

## 📚 Documentation Complète

- **README complet** : [README.md](README.md)
- **Guide de contribution** : [CONTRIBUTING.md](CONTRIBUTING.md)
- **Guide des widgets** : [GUIDE_WIDGETS.md](GUIDE_WIDGETS.md)

---

## 💡 Astuces

### Hot Reload Rapide

Pendant le développement :
- Modifiez le code
- Sauvegardez (Ctrl+S)
- Les changements apparaissent instantanément ! 🔥

### Déboguer l'API

Utilisez Swagger UI : http://localhost:8000/docs
- Testez les endpoints directement
- Voyez les schémas de données
- Pas besoin de Postman !

### Tester sur Mobile

```bash
# Lancer l'émulateur Android
flutter emulators --launch <emulator_id>

# Voir les émulateurs
flutter emulators

# Lancer l'app
flutter run
```

---

## 🆘 Support

### Problème persistant ?

1. Vérifiez [CONTRIBUTING.md](CONTRIBUTING.md#-besoin-daide-)
2. Consultez les issues GitHub
3. Créez une nouvelle issue avec :
   - Description du problème
   - Message d'erreur complet
   - Étapes pour reproduire

---

## 🎉 Prêt à Contribuer ?

Consultez [CONTRIBUTING.md](CONTRIBUTING.md) pour :
- Standards de code
- Workflow Git
- Checklist Pull Request

---

**Bon développement ! 🚚💙**
