# 📱 GUIDE D'UTILISATION - APPLICATION MOBILE WASSALI

## 🎯 POUR VOS AMIS - INSTALLATION ET UTILISATION SUR TÉLÉPHONE ANDROID

---

## 📥 ÉTAPE 1 : TÉLÉCHARGER L'APPLICATION

### Option 1 : Depuis GitHub Releases (Recommandé)
1. Ouvrez le navigateur de votre téléphone
2. Allez sur : **github.com/hazem02b/wassalii/releases**
3. Cliquez sur la dernière version (Release)
4. Téléchargez le fichier **app-release.apk**

### Option 2 : Lien Direct
Si votre ami vous a envoyé un lien direct vers l'APK, téléchargez-le directement.

---

## 🔧 ÉTAPE 2 : INSTALLER L'APPLICATION

### ⚠️ Autoriser l'installation depuis des sources inconnues

1. Après le téléchargement, cliquez sur le fichier APK
2. Android vous demandera d'autoriser l'installation
3. Allez dans **Paramètres** → **Sécurité** → **Sources inconnues**
4. Activez l'option pour votre navigateur (Chrome, Firefox, etc.)
5. Revenez et cliquez à nouveau sur l'APK
6. Cliquez sur **Installer**

### 📱 Étapes d'installation:
- ✅ Acceptez les autorisations demandées
- ✅ Attendez la fin de l'installation
- ✅ Cliquez sur **Ouvrir** ou trouvez l'icône Wassali sur votre écran d'accueil

---

## 🌐 ÉTAPE 3 : ACTIVER LE SERVEUR RENDER (OBLIGATOIRE AVANT UTILISATION)

### ⚠️ TRÈS IMPORTANT : À FAIRE AVANT D'UTILISER L'APP

Le serveur backend est hébergé sur Render (gratuit) et **se met en veille après 15 minutes d'inactivité**. 

### 🔄 Comment activer le serveur :

#### Méthode 1 : Via le navigateur (Recommandé)
1. Ouvrez votre navigateur web
2. Allez sur : **github.com/hazem02b/wassalii**
3. Ouvrez le fichier **web/activer_serveur.html**
4. Cliquez sur **Raw** ou téléchargez le fichier
5. Ouvrez-le dans votre navigateur
6. Cliquez sur **"Activer le Serveur"**
7. Attendez **30 à 60 secondes** que le serveur se réveille
8. Vous verrez un message de confirmation ✅

#### Méthode 2 : Lien Direct
Visitez directement : **https://wassali-backend.onrender.com/health**
- Si vous voyez un message (même une erreur), le serveur est en train de démarrer
- Attendez 30-60 secondes avant d'utiliser l'app

---

## 📲 ÉTAPE 4 : UTILISER L'APPLICATION

### 🔐 Première Utilisation - Connexion

L'application s'ouvrira sur la page de connexion.

#### 📋 Comptes de Test Disponibles :

**LIVREUR :**
- Email : `livreur1@test.com`
- Mot de passe : `password123`

**CLIENT :**
- Email : `client1@test.com`
- Mot de passe : `password123`

**ADMINISTRATEUR :**
- Email : `admin@test.com`
- Mot de passe : `adminpass`

### ✅ Connexion :
1. Entrez l'email du compte test
2. Entrez le mot de passe
3. Cliquez sur **Connexion**
4. Attendez quelques secondes (le serveur peut être lent au premier démarrage)

---

## 🎮 UTILISATION DE L'APPLICATION

### 👤 Mode Client
- **Commander une livraison** : Créer une nouvelle demande de livraison
- **Suivre mes colis** : Voir l'état de vos livraisons
- **Historique** : Consulter vos commandes passées

### 🚚 Mode Livreur
- **Voir les livraisons disponibles** : Liste des commandes à prendre en charge
- **Accepter une livraison** : Prendre en charge une commande
- **Mettre à jour le statut** : Indiquer où en est la livraison
- **Livraison terminée** : Marquer une livraison comme effectuée

### 👨‍💼 Mode Admin
- **Gérer les utilisateurs** : Voir et modifier les comptes
- **Gérer les livraisons** : Vue complète de toutes les livraisons
- **Statistiques** : Voir les performances de la plateforme

---

## ⚠️ RÉSOLUTION DES PROBLÈMES

### ❌ Problème : "Impossible de se connecter au serveur"

**Solutions :**
1. ✅ **Vérifiez votre connexion Internet** (WiFi ou données mobiles)
2. ✅ **Activez le serveur Render** (voir Étape 3)
3. ✅ **Attendez 30-60 secondes** après l'activation
4. ✅ **Réessayez** de vous connecter
5. ✅ **Redémarrez l'application**

### ❌ Problème : "Connexion très lente"

**Explication :**
Le serveur Render (gratuit) se met en veille automatiquement. Au premier accès :
- Le réveil prend **30 à 60 secondes**
- Les requêtes suivantes seront **beaucoup plus rapides**

**Solution :**
- Activez le serveur AVANT d'utiliser l'app (voir Étape 3)
- Soyez patient lors de la première connexion
- Si rien ne se passe après 2 minutes, réactivez le serveur

### ❌ Problème : "Installation bloquée"

**Solutions :**
1. Allez dans **Paramètres** → **Applications**
2. Trouvez l'ancienne version de Wassali (si elle existe)
3. Désinstallez-la
4. Réinstallez la nouvelle version

### ❌ Problème : "L'application se ferme toute seule"

**Solutions :**
1. Effacez le cache : **Paramètres** → **Applications** → **Wassali** → **Effacer le cache**
2. Réinstallez l'application
3. Vérifiez que vous avez assez d'espace de stockage (minimum 100 MB)

---

## 📞 SUPPORT ET CONTACT

### 🐛 Signaler un Bug
- Contactez l'administrateur du projet
- Décrivez précisément le problème rencontré
- Indiquez le type de téléphone et la version Android

### 💡 Suggestions d'Amélioration
N'hésitez pas à proposer des nouvelles fonctionnalités !

---

## 📊 INFORMATIONS TECHNIQUES

### Configuration Backend
- **URL du serveur** : https://wassali-backend.onrender.com
- **Hébergement** : Render.com (Plan gratuit)
- **Base de données** : SQLite (gérée par Render)
- **Disponibilité** : 24/7 (avec temps de réveil de 30-60s après inactivité)

### Configuration Mobile
- **Plateforme** : Android
- **Framework** : Flutter
- **Version minimum Android** : 5.0 (Lollipop)
- **Autorisations requises** : Internet, Stockage

### ⏰ Temps de Réponse
- **Premier accès après veille** : 30-60 secondes
- **Accès suivants** : 1-3 secondes
- **Mise en veille du serveur** : Après 15 minutes d'inactivité

---

## ✅ CHECKLIST RAPIDE POUR UTILISER L'APP

- [ ] 1. Télécharger l'APK depuis GitHub Releases
- [ ] 2. Installer l'APK (autoriser sources inconnues)
- [ ] 3. Activer le serveur Render (attendre 30-60 secondes)
- [ ] 4. Ouvrir l'application Wassali
- [ ] 5. Se connecter avec un compte test
- [ ] 6. Commencer à utiliser l'application ! 🎉

---

## 🎉 PROFITEZ DE L'APPLICATION !

Vous êtes maintenant prêt à utiliser Wassali pour gérer vos livraisons de colis !

**🚀 Bon usage !**

---

**Dernière mise à jour** : Janvier 2026  
**Version** : 1.0.0  
**Développé par** : L'équipe Wassali
