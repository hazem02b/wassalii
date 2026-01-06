# 📱 Installation de l'Application Wassali (APK Android)

Guide d'installation et d'utilisation du fichier APK de l'application mobile Wassali.

---

## 📋 Table des Matières

- [Prérequis](#-prérequis)
- [Téléchargement](#-téléchargement)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Utilisation](#-utilisation)
- [Dépannage](#-dépannage)

---

## 📦 Prérequis

### Appareil Android
- **Android** version 5.0 (Lollipop) ou supérieure
- **Espace de stockage** : Au moins 50 MB disponibles
- **Connexion Internet** : Requise pour les fonctionnalités

### Backend API
- Le backend doit être lancé et accessible
- URL par défaut : `http://10.0.2.2:8000` (pour émulateur)
- URL personnalisée possible selon votre configuration

---

## 📥 Téléchargement

### Option 1 : Depuis GitHub Releases
1. Aller sur la page des [Releases](https://github.com/hazem02b/wassalii/releases)
2. Télécharger le fichier `wassali-app.apk` de la dernière version

### Option 2 : Depuis le Build Local
Le fichier APK se trouve dans :
```
wassali_app/build/app/outputs/flutter-apk/app-release.apk
```

### Option 3 : Générer l'APK
```bash
cd wassali_app
flutter build apk --release
```
L'APK sera généré dans : `build/app/outputs/flutter-apk/app-release.apk`

---

## 🔧 Installation

### Étape 1 : Autoriser les Sources Inconnues

Avant d'installer l'APK, vous devez autoriser l'installation d'applications depuis des sources inconnues :

**Android 8.0 et supérieur :**
1. Allez dans **Paramètres** → **Sécurité et confidentialité**
2. Activez **Installer des applications inconnues**
3. Sélectionnez l'application que vous utiliserez pour installer l'APK (ex: Chrome, Gestionnaire de fichiers)
4. Activez **Autoriser cette source**

**Android 7.1 et inférieur :**
1. Allez dans **Paramètres** → **Sécurité**
2. Activez **Sources inconnues**
3. Confirmez en appuyant sur **OK**

### Étape 2 : Transférer l'APK sur votre Appareil

**Méthode 1 - Via USB :**
1. Connectez votre téléphone à l'ordinateur via USB
2. Copiez le fichier `app-release.apk` vers le stockage de votre téléphone
3. Débranchez le téléphone

**Méthode 2 - Via Email :**
1. Envoyez-vous l'APK par email
2. Ouvrez l'email sur votre téléphone
3. Téléchargez la pièce jointe

**Méthode 3 - Via Cloud (Google Drive, Dropbox, etc.) :**
1. Uploadez l'APK sur votre service cloud
2. Téléchargez-le depuis votre téléphone

**Méthode 4 - Via ADB (Pour développeurs) :**
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Étape 3 : Installer l'APK

1. Ouvrez le **Gestionnaire de fichiers** sur votre téléphone
2. Naviguez vers le dossier où vous avez copié l'APK (généralement **Téléchargements**)
3. Appuyez sur le fichier **app-release.apk** ou **wassali-app.apk**
4. Appuyez sur **Installer**
5. Attendez la fin de l'installation
6. Appuyez sur **Ouvrir** pour lancer l'application

---

## ⚙️ Configuration

### Configuration du Backend

L'application doit se connecter au backend FastAPI. Selon votre configuration :

#### Pour Émulateur Android
L'URL par défaut est : `http://10.0.2.2:8000`

#### Pour Appareil Physique
Vous devez modifier l'URL dans le code avant de générer l'APK :

1. Ouvrir `lib/config/api_config.dart`
2. Remplacer l'URL :
```dart
class ApiConfig {
  // Remplacer par l'IP de votre ordinateur
  static const String baseUrl = 'http://192.168.1.X:8000';
}
```

3. Trouver votre IP locale :
   - **Windows** : `ipconfig` (cherchez IPv4)
   - **Linux/Mac** : `ifconfig` ou `ip addr`

4. Régénérer l'APK :
```bash
flutter build apk --release
```

### Démarrer le Backend

Avant d'utiliser l'application, assurez-vous que le backend est lancé :

```bash
cd wassali_app/web_src/backend
python -m uvicorn main:app --host 0.0.0.0 --port 8000
```

---

## 🎯 Utilisation

### Première Utilisation

1. **Ouvrir l'application** Wassali sur votre téléphone
2. **Choisir la langue** : Français, Anglais ou Arabe
3. **S'inscrire** ou **Se connecter**

### Compte de Test

Pour tester rapidement l'application, utilisez ces comptes :

**Client :**
- Email : `client@test.com`
- Mot de passe : `password123`

**Transporteur :**
- Email : `transporteur@test.com`
- Mot de passe : `password123`

### Fonctionnalités Principales

#### Pour les Clients 👥
- ✅ Rechercher des transporteurs disponibles
- ✅ Créer une demande de livraison
- ✅ Suivre les livraisons en temps réel
- ✅ Messagerie avec les transporteurs
- ✅ Système de paiement
- ✅ Noter et commenter les transporteurs

#### Pour les Transporteurs 🚛
- ✅ Créer et gérer des trajets
- ✅ Voir les demandes de livraison
- ✅ Accepter/refuser des demandes
- ✅ Messagerie avec les clients
- ✅ Tableau de bord avec statistiques
- ✅ Gérer les revenus

### Paramètres

Accédez aux paramètres depuis le menu pour :
- Changer de langue (FR/EN/AR)
- Activer/désactiver le mode sombre
- Modifier votre profil
- Changer votre photo de profil
- Gérer les notifications

---

## 🐛 Dépannage

### L'application ne s'installe pas

**Problème :** "Application non installée"

**Solutions :**
1. Vérifiez que les **Sources inconnues** sont activées
2. Vérifiez que vous avez assez d'**espace de stockage**
3. Désinstallez l'ancienne version si elle existe
4. Redémarrez votre téléphone
5. Essayez de réinstaller

### L'application ne se connecte pas au backend

**Problème :** "Erreur de connexion" ou "Impossible de se connecter"

**Solutions :**

1. **Vérifiez que le backend est lancé** :
   ```bash
   cd web_src/backend
   python -m uvicorn main:app --host 0.0.0.0 --port 8000
   ```

2. **Vérifiez l'URL de l'API** :
   - Pour appareil physique, l'URL doit pointer vers l'IP de votre ordinateur
   - Votre téléphone et ordinateur doivent être sur le **même réseau WiFi**

3. **Vérifiez le pare-feu** :
   - Autorisez le port 8000 dans le pare-feu Windows/Linux
   - Windows : `netsh advfirewall firewall add rule name="Wassali API" dir=in action=allow protocol=TCP localport=8000`

4. **Testez la connexion** :
   - Depuis le navigateur de votre téléphone, accédez à : `http://192.168.1.X:8000/docs`
   - Remplacez X par votre IP
   - Si ça fonctionne, le problème vient de la configuration de l'app

### L'application crash au démarrage

**Solutions :**
1. Effacez les données de l'application :
   - Paramètres → Applications → Wassali → Stockage → Effacer les données
2. Réinstallez l'application
3. Vérifiez que votre version Android est compatible (≥ 5.0)

### Les images ne se chargent pas

**Solutions :**
1. Vérifiez votre connexion Internet
2. Vérifiez que le backend est accessible
3. Effacez le cache de l'application

### La géolocalisation ne fonctionne pas

**Solutions :**
1. Activez la localisation dans les paramètres Android
2. Autorisez l'application à accéder à la localisation :
   - Paramètres → Applications → Wassali → Autorisations → Localisation → Toujours autoriser

---

## 📊 Informations sur l'APK

### Taille de l'Application
- **APK** : ~30-50 MB
- **Installée** : ~70-100 MB

### Permissions Requises
- 📍 **Localisation** : Pour trouver des transporteurs à proximité
- 📷 **Caméra** : Pour prendre une photo de profil
- 🖼️ **Stockage** : Pour sélectionner une photo depuis la galerie
- 🌐 **Internet** : Pour communiquer avec le backend
- 📱 **Notifications** : Pour recevoir les mises à jour

### Compatibilité
- **Android** : 5.0 (API 21) et supérieur
- **Architecture** : ARM, ARM64, x86, x86_64

---

## 🔄 Mise à Jour

Pour mettre à jour l'application :

1. Téléchargez la nouvelle version de l'APK
2. Installez-la par-dessus l'ancienne version
3. Vos données seront conservées

Ou désinstallez l'ancienne version avant d'installer la nouvelle (perte de données).

---

## 🔒 Sécurité

### Signature de l'Application

L'APK de production doit être signé avec une clé de signature :

```bash
# Générer une clé de signature
keytool -genkey -v -keystore wassali-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias wassali

# Configurer dans android/key.properties
storePassword=<votre-mot-de-passe>
keyPassword=<votre-mot-de-passe>
keyAlias=wassali
storeFile=<chemin-vers-wassali-key.jks>

# Build APK signé
flutter build apk --release
```

### Vérification de l'Intégrité

Pour vérifier que l'APK n'a pas été modifié :

```bash
# Afficher la signature
keytool -printcert -jarfile app-release.apk
```

---

## 📞 Support

### Problèmes Connus

1. **Latence réseau** : L'application peut être lente si le backend est distant
2. **Notifications** : Peuvent ne pas fonctionner sur certains appareils avec économie d'énergie agressive

### Obtenir de l'Aide

- **Issues GitHub** : [Ouvrir une issue](https://github.com/hazem02b/wassalii/issues)
- **Email** : support@wassali.com (si configuré)
- **Documentation** : [README.md](README.md)

---

## 📝 Changelog

### Version 1.0.0 (Janvier 2026)
- ✅ Version initiale
- ✅ Authentification complète
- ✅ Gestion des trajets
- ✅ Système de réservation
- ✅ Messagerie intégrée
- ✅ Multi-langues (FR/EN/AR)
- ✅ Mode sombre
- ✅ Upload photos de profil

---

## 📄 Licence

Ce projet est sous licence MIT.

---

## 🎉 Profitez de Wassali !

L'application mobile de livraison de colis la plus simple et efficace !

**Développé avec ❤️ par l'équipe Wassali**
