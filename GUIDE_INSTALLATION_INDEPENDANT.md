# 🚀 Guide d'Installation Indépendant - Wassali App

## 📋 Pour TOUS (Étudiants + Professeur)

Chaque personne lance **son propre backend** sur **son ordinateur**.  
**Pas besoin d'être sur le même réseau !** ✅

---

## ✅ Prérequis

### 1. Python (version 3.8+)
```powershell
# Vérifier
python --version
```
Si pas installé : https://www.python.org/downloads/

### 2. Flutter (dernière version)
```powershell
# Vérifier
flutter --version
```
Si pas installé : https://flutter.dev/docs/get-started/install

---

## 🚀 Installation - 3 ÉTAPES SIMPLES

### ÉTAPE 1️⃣ : Télécharger le projet

```powershell
# Si vous avez reçu le projet par email/USB/GitHub
cd chemin/vers/wassali_app
```

---

### ÉTAPE 2️⃣ : Installer les dépendances

#### Backend (Python)
```powershell
cd web_src\backend
pip install -r requirements.txt
cd ..\..
```

#### Frontend (Flutter)
```powershell
flutter pub get
```

---

### ÉTAPE 3️⃣ : Lancer l'application

#### Option A : Script automatique (RECOMMANDÉ)
```powershell
.\start_all.ps1
```

#### Option B : Lancement manuel

**Terminal 1 - Backend :**
```powershell
cd web_src\backend
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

**Terminal 2 - Frontend :**
```powershell
flutter run -d chrome
```

---

## 🔐 Comptes de test

Une fois l'application lancée :

**Client :**
- Email : `client@test.com`
- Mot de passe : `password123`

**Transporteur :**
- Email : `transporteur@test.com`
- Mot de passe : `password123`

---

## 📊 Vérification rapide

### Backend opérationnel ?
```powershell
curl http://localhost:8000/health
```
Réponse attendue : `{"status":"healthy","service":"Wassali API","version":"1.0.0"}`

### Documentation API
Ouvrir dans le navigateur : http://localhost:8000/docs

---

## ❓ Problèmes courants

### ❌ "Port 8000 already in use"
```powershell
# Trouver le processus qui utilise le port
netstat -ano | findstr :8000

# Arrêter le processus (remplacer PID par le numéro trouvé)
taskkill /PID <PID> /F
```

### ❌ "Python not found"
Installez Python depuis : https://www.python.org/downloads/  
⚠️ Cochez "Add Python to PATH" lors de l'installation

### ❌ "Flutter not found"
Installez Flutter : https://flutter.dev/docs/get-started/install  
Ajoutez Flutter au PATH système

### ❌ "Module 'uvicorn' not found"
```powershell
pip install uvicorn
```

### ❌ "Database locked" ou erreur SQLite
```powershell
# Supprimer et recréer la base de données
cd web_src\backend
del wassali_test.db
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

---

## 🔄 Arrêter l'application

- **Backend** : `Ctrl + C` dans le terminal uvicorn
- **Frontend** : `Ctrl + C` dans le terminal Flutter ou fermer le navigateur

---

## 📁 Structure du projet

```
wassali_app/
├── web_src/
│   └── backend/          # Backend FastAPI (Python)
│       ├── main.py
│       ├── requirements.txt
│       └── app/
├── lib/                  # Code Flutter (Dart)
│   ├── main.dart
│   └── config/
│       └── api_config.dart
├── start_all.ps1         # Script de lancement automatique
└── README.md
```

---

## 🎓 Pour le Professeur

### Évaluation locale
1. Télécharger le projet
2. Lancer `.\start_all.ps1`
3. Ouvrir http://localhost:8000/docs pour voir l'API
4. Tester l'application dans Chrome

### Base de données
- Type : SQLite (fichier `web_src/backend/wassali_test.db`)
- Réinitialisable : Supprimer le fichier `.db` pour repartir de zéro
- Tables créées automatiquement au démarrage

### Tests
```powershell
# Tester l'API directement
cd web_src\backend
python test_api.py
```

---

## 💡 Notes importantes

1. **Chacun sur son PC** : Pas besoin de réseau commun
2. **Base de données locale** : Chaque personne a sa propre base SQLite
3. **Port 8000** : Doit être libre sur votre machine
4. **Navigateur** : Chrome recommandé pour le développement

---

## 📞 Support

En cas de problème :
1. Vérifiez les prérequis (Python + Flutter installés)
2. Relancez les installations de dépendances
3. Consultez les logs d'erreur dans les terminaux

---

## ✅ Checklist de vérification

Avant de rendre le projet, vérifiez :

- [ ] `python --version` fonctionne
- [ ] `flutter --version` fonctionne
- [ ] `pip install -r web_src\backend\requirements.txt` sans erreur
- [ ] `flutter pub get` sans erreur
- [ ] `.\start_all.ps1` lance backend + frontend
- [ ] http://localhost:8000/health retourne "healthy"
- [ ] L'application s'ouvre dans Chrome
- [ ] Connexion avec `client@test.com` / `password123` fonctionne

---

**Tout devrait fonctionner en 5 minutes ! 🎉**

Date de création : 5 Janvier 2026
