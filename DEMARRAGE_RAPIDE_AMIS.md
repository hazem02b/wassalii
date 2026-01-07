# 🚀 DEMARRAGE ULTRA-RAPIDE - WASSALI

## 📱 Pour que vos amis utilisent l'app sur leur téléphone

### ⚡ Démarrage en 4 clics (Méthode Rapide)

1. **Double-cliquez sur:** `OUVRIR_FIREWALL.bat` *(Clic droit → Exécuter en tant qu'administrateur)*
2. **Double-cliquez sur:** `LANCER_SERVEUR.bat`
3. **Notez votre IP** affichée dans la fenêtre (exemple: 192.168.1.123)
4. **Modifiez** `lib/config/api_config.dart` avec votre IP

---

## 📂 Fichiers Créés Pour Vous

### 🟢 Fichiers Principaux

| Fichier | Description |
|---------|-------------|
| **LANCER_SERVEUR.bat** | Lance le serveur backend pour vos amis |
| **OUVRIR_FIREWALL.bat** | Configure Windows Firewall automatiquement |
| **CREER_BASE_DONNEES.bat** | Initialise la base de données et comptes test |
| **INSTRUCTIONS_SIMPLES.txt** | Guide complet étape par étape |
| **PARTAGE_APP.md** | Documentation détaillée |

### 📱 Pour Créer l'APK Android

```bash
flutter build apk --release
```

Le fichier sera ici: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🎯 Guide Complet en 7 Étapes

### 1️⃣ Trouver Votre IP
```powershell
ipconfig
```
Cherchez "Adresse IPv4" → notez-la (ex: 192.168.1.123)

### 2️⃣ Modifier la Configuration
Ouvrez: `lib/config/api_config.dart`

Changez:
```dart
static const String baseUrl = 'http://localhost:8000/api/v1';
```

En (avec VOTRE IP):
```dart
static const String baseUrl = 'http://192.168.1.123:8000/api/v1';
```

### 3️⃣ Ouvrir le Firewall
Clic droit sur `OUVRIR_FIREWALL.bat` → "Exécuter en tant qu'administrateur"

OU manuellement dans PowerShell (admin):
```powershell
netsh advfirewall firewall add rule name="Wassali Backend" dir=in action=allow protocol=TCP localport=8000
```

### 4️⃣ Initialiser la Base de Données
Double-cliquez sur: `CREER_BASE_DONNEES.bat`

Comptes créés:
- **Client:** client@wassali.com / ClientTest123!
- **Transporteur:** transporteur@wassali.com / TransportTest123!

### 5️⃣ Lancer le Serveur
Double-cliquez sur: `LANCER_SERVEUR.bat`

**NE FERMEZ PAS** la fenêtre!

### 6️⃣ Créer l'APK
```bash
flutter build apk --release
```

### 7️⃣ Partager avec Vos Amis
- Envoyez `app-release.apk` via USB, Bluetooth, Google Drive, etc.
- Ils l'installent sur leur téléphone
- Ils se connectent au **même WiFi** que vous
- L'app fonctionne! 🎉

---

## ✅ Checklist

### Pour Vous:
- [ ] IP trouvée avec `ipconfig`
- [ ] IP changée dans `lib/config/api_config.dart`
- [ ] Firewall ouvert avec `OUVRIR_FIREWALL.bat`
- [ ] Base de données créée avec `CREER_BASE_DONNEES.bat`
- [ ] Serveur lancé avec `LANCER_SERVEUR.bat`
- [ ] APK créé avec `flutter build apk --release`
- [ ] APK partagé avec vos amis

### Pour Vos Amis:
- [ ] APK installé (autoriser "Sources inconnues")
- [ ] Connectés au **même WiFi** que vous
- [ ] App Wassali ouverte

---

## 🧪 Test Rapide

Sur le téléphone de votre ami, ouvrez le navigateur et allez à:
```
http://VOTRE_IP:8000/docs
```
(Exemple: http://192.168.1.123:8000/docs)

S'il voit la documentation Swagger → **✅ Ça marche!**

---

## ❓ Problèmes Courants

### ❌ "Impossible de se connecter"
- Vérifiez que vous êtes sur le **même WiFi**
- Vérifiez que le serveur est **lancé** (fenêtre ouverte)
- Vérifiez l'IP dans `api_config.dart`

### ❌ "Le serveur ne démarre pas"
- Installez Python: https://www.python.org
- Vérifiez que le port 8000 est libre

### ❌ "L'app ne s'installe pas"
- Activez "Sources inconnues" dans Paramètres → Sécurité
- Essayez de réinstaller l'APK

---

## 📚 Documentation

- **Guide Complet:** [INSTRUCTIONS_SIMPLES.txt](INSTRUCTIONS_SIMPLES.txt)
- **Guide Détaillé:** [PARTAGE_APP.md](PARTAGE_APP.md)
- **README Principal:** [README.md](README.md)

---

## 🎉 C'est Tout!

Vos amis peuvent maintenant utiliser Wassali sur leurs téléphones!

**Note:** Votre ordinateur doit rester allumé avec le serveur lancé.

---

**Dernière mise à jour:** 7 janvier 2026
