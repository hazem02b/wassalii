# 📱 GUIDE RAPIDE : Tester l'APK Android Wassali

## 🎯 Pour le professeur et les camarades

Ce guide permet de tester l'application Wassali directement sur un téléphone Android.

---

## ⚠️ **ÉTAPE OBLIGATOIRE AVANT DE TESTER** ⚠️

Le backend est hébergé **gratuitement** sur Render.com et **s'endort après inactivité**.

### 🔥 Activation du serveur (30-60 secondes)

**Option A - Sur PC (RECOMMANDÉ)** :
1. Ouvrez ce fichier dans votre navigateur : `web/activer_serveur.html`
2. Cliquez sur **"Activer le serveur"**
3. Attendez 30-60 secondes
4. Quand vous voyez **"✅ Serveur actif !"**, lancez l'app mobile

**Option B - Directement sur téléphone** :
1. Ouvrez le navigateur de votre téléphone
2. Allez sur : https://wassali-backend.onrender.com/health
3. Attendez que la page charge (30-60 secondes)
4. Lancez l'app mobile

**💡 Note** : Une fois activé, le serveur reste éveillé 15 minutes. Profitez-en pour tester !

---

## ✅ Prérequis

- Un téléphone Android (version 6.0 ou supérieur)
- Un câble USB ou accès à internet

---

## 📥 Méthode 1 : Compiler l'APK soi-même

### Étape 1 : Cloner le projet

```bash
git clone https://github.com/hazem02b/wassalii.git
cd wassalii
```

### Étape 2 : Installer les dépendances

```bash
flutter pub get
```

### Étape 3 : Compiler l'APK

```bash
flutter build apk --release
```

**Résultat** : `build/app/outputs/flutter-apk/app-release.apk` (54.6 MB)

---

## 📱 Méthode 2 : Utiliser l'APK pré-compilé

Si un APK a été partagé avec vous (via Google Drive, WeTransfer, etc.) :

### Installation sur Android :

1. **Transférez l'APK** sur votre téléphone
2. Ouvrez l'application **"Fichiers"**
3. Naviguez vers **"Téléchargements"**
4. Touchez **`app-release.apk`**
5. Si demandé : **Autorisez l'installation** depuis cette source
6. Touchez **"Installer"**
7. Attendez l'installation (5-10 secondes)
8. Touchez **"Ouvrir"**

---

## 🔐 Comptes de test

### Compte Client :
- **Email** : `client@test.com`
- **Mot de passe** : `password123`

### Compte Transporteur :
- **Email** : `transporteur@test.com`
- **Mot de passe** : `password123`

### Ou créez votre propre compte :
- Touchez **"Créer un compte"** sur l'écran de connexion
- Remplissez le formulaire
- Choisissez votre type : Client ou Transporteur

---

## ⚠️ IMPORTANT - Limitations du serveur gratuit

**Le serveur backend est hébergé gratuitement sur Render.com**

### 🕐 Temps de démarrage :
- La **PREMIÈRE connexion** prend **30-60 secondes** (le serveur se réveille)
- Vous verrez un indicateur de chargement
- **Attendez patiemment** - c'est normal !
- Les connexions suivantes seront **rapides** (2-3 secondes) ⚡

### 💾 Persistance des données :
- ⚠️ **Les comptes créés sont TEMPORAIRES**
- Quand le serveur s'endort/redémarre → **La base de données SQLite est réinitialisée**
- **Tous les nouveaux comptes sont perdus** après inactivité
- **Solution** : Utilisez les **comptes de test permanents** ci-dessous :
  - Client : `client@test.com` / `password123`
  - Transporteur : `transporteur@test.com` / `password123`

**Note technique** : C'est une limitation connue de l'hébergement gratuit Render (système de fichiers éphémère). Pour une vraie production, il faudrait utiliser PostgreSQL avec un plan payant.

---

## 🌐 Backend

- **URL** : https://wassali-backend.onrender.com
- **Documentation API** : https://wassali-backend.onrender.com/api/v1/docs
- **Status** : https://wassali-backend.onrender.com/health

---

## 🧪 Fonctionnalités à tester

### Côté Client :
- ✅ Inscription / Connexion
- ✅ Création de réservation de colis
- ✅ Recherche de transporteurs
- ✅ Consultation des réservations
- ✅ Messagerie avec transporteurs
- ✅ Système de paiement
- ✅ Notifications

### Côté Transporteur :
- ✅ Inscription / Connexion
- ✅ Création d'annonces de voyage
- ✅ Consultation des réservations reçues
- ✅ Acceptation/Refus de colis
- ✅ Gestion du profil
- ✅ Messagerie avec clients
- ✅ Historique des trajets

---

## 🔧 Configuration technique

### Backend :
- **Framework** : FastAPI (Python)
- **Base de données** : SQLite (production) / PostgreSQL (option)
- **Hébergement** : Render.com (free tier)
- **API** : REST avec documentation Swagger

### Frontend Mobile :
- **Framework** : Flutter 3.38.5
- **Langages** : Dart
- **Mode** : Production (connexion au serveur distant)
- **Timeout** : 90 secondes (première connexion)

---

## 📊 Architecture

```
┌─────────────────┐
│  App Android    │
│  (Flutter)      │ ← Vous testez ici
└────────┬────────┘
         │ HTTPS
         ↓
┌─────────────────┐
│  Backend API    │
│  (FastAPI)      │ ← Hébergé sur Render
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  Base de        │
│  données SQLite │
└─────────────────┘
```

---

## 🆘 Dépannage

### Erreur "Connexion échouée" ?
- Vérifiez votre connexion internet
- Attendez 60 secondes (le serveur démarre)
- Réessayez la connexion

### Erreur "Timeout" ?
- Vérifiez que vous avez le **dernier APK** (avec timeout 90s)
- Le serveur gratuit peut être lent au premier démarrage
- Attendez et réessayez

### APK ne s'installe pas ?
- Allez dans **Paramètres** → **Sécurité**
- Activez **"Sources inconnues"** ou **"Installer des apps inconnues"**

---

## 📝 Notes pour l'évaluation

### Points forts :
- ✅ Application **100% fonctionnelle** sur Android
- ✅ Backend **déployé en production** (accessible 24/7)
- ✅ APK **indépendant** (fonctionne sur n'importe quel téléphone)
- ✅ Pas besoin de configuration locale
- ✅ Interface utilisateur moderne et responsive
- ✅ Système complet de réservation et messagerie

### Technologies modernes :
- Flutter pour cross-platform
- FastAPI pour l'API REST
- JWT pour l'authentification
- SQLite/PostgreSQL pour la persistance
- Render.com pour l'hébergement cloud

---

## 📞 Contact

Pour toute question ou problème :
- Repository GitHub : https://github.com/hazem02b/wassalii
- Consultez les fichiers README dans le projet

---

**Dernière mise à jour** : 5 Janvier 2026  
**Version APK** : 1.0.0 (Production)  
**Backend** : Live sur Render.com
