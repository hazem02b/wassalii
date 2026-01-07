# 📱 Partager l'Application Wassali avec vos Amis

## ✅ Configuration Simple en 3 Étapes

### Étape 1️⃣: Trouver votre adresse IP

Ouvrez PowerShell et tapez:
```powershell
ipconfig
```

Cherchez la ligne **"Adresse IPv4"**, exemple: `192.168.1.123`

---

### Étape 2️⃣: Configurer l'Application

Ouvrez le fichier: `lib/config/api_config.dart`

Changez cette ligne:
```dart
static const String baseUrl = 'http://localhost:8000/api/v1';
```

Par (remplacez avec VOTRE IP):
```dart
static const String baseUrl = 'http://192.168.1.123:8000/api/v1';
```

Sauvegardez le fichier.

---

### Étape 3️⃣: Générer l'APK pour Android

Dans le terminal:
```bash
flutter build apk --release
```

Le fichier APK sera créé ici:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 📤 Partager avec vos Amis

### Option A: Partage Direct
1. Copiez le fichier `app-release.apk` sur une clé USB
2. Transférez-le aux téléphones de vos amis
3. Ils doivent installer l'APK (autoriser "Sources inconnues" dans les paramètres)

### Option B: Partage via Cloud
1. Uploadez `app-release.apk` sur Google Drive, Dropbox, etc.
2. Partagez le lien de téléchargement
3. Vos amis téléchargent et installent

---

## 🖥️ Démarrer le Serveur (IMPORTANT!)

**Avant que vos amis utilisent l'app**, vous devez lancer le serveur:

1. Ouvrez le fichier: `web_src/backend/run_server.bat`

2. Assurez-vous qu'il contient:
```bat
@echo off
cd /d C:\Wassaliparceldeliveryapp\backend
set PYTHONPATH=C:\Wassaliparceldeliveryapp\backend
echo Starting Wassali Backend Server...
C:\Users\HAZEM\AppData\Local\Programs\Python\Python310\python.exe -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
pause
```

3. Double-cliquez sur `run_server.bat` pour lancer le serveur

4. **Ouvrir le Firewall Windows:**
```powershell
netsh advfirewall firewall add rule name="Wassali Backend" dir=in action=allow protocol=TCP localport=8000
```

---

## 📋 Checklist pour vos Amis

- [ ] Même réseau WiFi que vous
- [ ] APK installé sur leur téléphone
- [ ] Votre serveur est lancé (run_server.bat)
- [ ] Votre ordinateur est allumé et connecté au WiFi

---

## ❓ Problèmes Courants

### L'app ne se connecte pas?

**Vérifiez:**
1. ✅ Vous êtes tous sur le **même réseau WiFi**
2. ✅ Le serveur est **lancé** (terminal ouvert)
3. ✅ L'adresse IP dans `api_config.dart` est **correcte**
4. ✅ Le firewall est **ouvert** pour le port 8000

**Test rapide:**
Demandez à votre ami d'ouvrir le navigateur de son téléphone et d'aller à:
```
http://VOTRE_IP:8000/docs
```
(Remplacez VOTRE_IP par votre vraie IP, ex: 192.168.1.123)

S'il voit la documentation Swagger, ça fonctionne! ✅

---

## 🎯 Résumé Ultra-Rapide

1. **Vous**: Trouvez votre IP avec `ipconfig`
2. **Vous**: Changez l'IP dans `api_config.dart`
3. **Vous**: Générez l'APK avec `flutter build apk --release`
4. **Vous**: Partagez le fichier APK avec vos amis
5. **Vous**: Lancez le serveur avec `run_server.bat`
6. **Vous**: Ouvrez le firewall
7. **Amis**: Installent l'APK
8. **Amis**: Se connectent au même WiFi
9. **Tous**: Utilisez l'app ensemble! 🎉

---

**Note:** Tant que votre ordinateur est allumé avec le serveur lancé, vos amis peuvent utiliser l'app!
