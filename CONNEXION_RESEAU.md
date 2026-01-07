# 🌐 Guide de Connexion Réseau - Wassali App

## ✅ Solution pour l'erreur "Network Layer"

### Pour HAZEM (hébergeur du serveur)

**1. Vérifiez votre adresse IP :**
```powershell
ipconfig
```
Votre IP actuelle : **192.168.1.18**

**2. Autorisez le port 8000 dans le pare-feu Windows :**
```powershell
# Exécutez ces commandes en tant qu'Administrateur
New-NetFirewallRule -DisplayName "Wassali Backend" -Direction Inbound -Protocol TCP -LocalPort 8000 -Action Allow
```

**3. Lancez le serveur :**
```powershell
.\start_all.ps1
```

Le backend sera accessible à :
- Vous : http://localhost:8000
- Vos camarades : http://192.168.1.18:8000

**4. Partagez ces informations avec vos camarades :**
- Votre IP : 192.168.1.18
- Port : 8000
- Assurez-vous d'être sur le même réseau Wi-Fi !

---

### Pour vos CAMARADES (qui veulent se connecter)

**⚠️ IMPORTANT : Vous devez être sur le même réseau Wi-Fi que HAZEM !**

**Étape 1 : Vérifier la connexion**
```powershell
# Testez si vous pouvez atteindre le serveur
curl http://192.168.1.18:8000/health
```

Si vous recevez une réponse, c'est bon ! Sinon :
- Vérifiez que vous êtes sur le même Wi-Fi
- Demandez à HAZEM d'autoriser le port 8000 dans son pare-feu

**Étape 2 : Configurer votre application**

Modifiez le fichier : `lib/config/api_config.dart`
```dart
static const String baseUrl = 'http://192.168.1.18:8000/api/v1';
```

**Étape 3 : Lancer l'application**
```bash
flutter pub get
flutter run -d chrome
```

---

## 🔍 Résolution des problèmes

### Erreur : "Connection refused" ou "Network error"

**Causes possibles :**
1. ❌ Pas sur le même réseau Wi-Fi
2. ❌ Pare-feu bloque le port 8000
3. ❌ Backend non démarré
4. ❌ Mauvaise adresse IP

**Solutions :**

**1. Vérifier le réseau :**
```powershell
# HAZEM et camarades doivent avoir des IPs similaires
ipconfig
# Exemple : 192.168.1.18 et 192.168.1.25 = ✅ même réseau
# Exemple : 192.168.1.18 et 192.168.2.25 = ❌ réseaux différents
```

**2. Ouvrir le pare-feu (HAZEM) :**
```powershell
# Méthode 1 : PowerShell (Administrateur)
New-NetFirewallRule -DisplayName "Wassali Backend" -Direction Inbound -Protocol TCP -LocalPort 8000 -Action Allow

# Méthode 2 : Interface graphique
# 1. Ouvrir "Pare-feu Windows Defender"
# 2. "Paramètres avancés"
# 3. "Règles de trafic entrant" > "Nouvelle règle"
# 4. Port > TCP > 8000 > Autoriser
```

**3. Tester la connexion :**
```powershell
# De la machine d'un camarade
Test-NetConnection -ComputerName 192.168.1.18 -Port 8000
```

**4. Vérifier que le backend écoute sur toutes les interfaces :**
```powershell
# Le backend doit être lancé avec --host 0.0.0.0 (déjà configuré dans start_all.ps1)
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

---

## 📱 Configurations selon l'appareil

### Chrome / Web
```dart
static const String baseUrl = 'http://192.168.1.18:8000/api/v1';
```

### Android Emulator
```dart
// Sur la machine de HAZEM (localhost)
static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

// Sur une autre machine (réseau)
static const String baseUrl = 'http://192.168.1.18:8000/api/v1';
```

### Android Physique
```dart
static const String baseUrl = 'http://192.168.1.18:8000/api/v1';
```

### iOS Simulator / Physique
```dart
static const String baseUrl = 'http://192.168.1.18:8000/api/v1';
```

---

## 🔐 Comptes de test

Une fois connectés, utilisez ces comptes :

**Client :**
- Email : `client@test.com`
- Mot de passe : `password123`

**Transporteur :**
- Email : `transporteur@test.com`
- Mot de passe : `password123`

---

## 📊 Vérification de l'état du serveur

### Pour HAZEM (sur sa machine)
```bash
# Vérifier que le backend fonctionne
curl http://localhost:8000/health

# Voir la documentation API
# Ouvrir dans le navigateur : http://localhost:8000/docs
```

### Pour les camarades
```bash
# Vérifier la connexion au serveur
curl http://192.168.1.18:8000/health

# Voir la documentation API
# Ouvrir dans le navigateur : http://192.168.1.18:8000/docs
```

---

## 💡 Notes importantes

1. **Même réseau Wi-Fi obligatoire** : HAZEM et tous les camarades doivent être connectés au même réseau Wi-Fi

2. **IP dynamique** : L'adresse IP de HAZEM peut changer après un redémarrage du routeur. Si l'erreur revient, refaites `ipconfig` et mettez à jour l'IP

3. **Pare-feu** : C'est la cause #1 des erreurs de connexion. Assurez-vous que le port 8000 est autorisé

4. **VPN** : Désactivez les VPN qui peuvent bloquer les connexions locales

5. **Antivirus** : Certains antivirus bloquent les serveurs locaux. Ajoutez une exception si nécessaire

---

## ✅ Checklist de démarrage

### Pour HAZEM :
- [ ] Vérifier l'IP avec `ipconfig`
- [ ] Ouvrir le port 8000 dans le pare-feu
- [ ] Lancer le backend avec `start_all.ps1`
- [ ] Vérifier que le backend fonctionne : `curl http://localhost:8000/health`
- [ ] Partager l'IP avec les camarades

### Pour les camarades :
- [ ] Être sur le même Wi-Fi que HAZEM
- [ ] Mettre à jour `api_config.dart` avec l'IP de HAZEM
- [ ] Tester la connexion : `curl http://192.168.1.18:8000/health`
- [ ] Lancer l'app : `flutter run -d chrome`
- [ ] Se connecter avec les comptes de test

---

## 🆘 Aide supplémentaire

Si le problème persiste :
1. Vérifiez les logs du backend (terminal où tourne uvicorn)
2. Vérifiez les logs du frontend (console du navigateur F12)
3. Essayez de ping l'IP : `ping 192.168.1.18`
4. Vérifiez que le pare-feu n'est pas en mode "Public" (il doit être en "Privé")

---

**Bonne chance ! 🚀**
