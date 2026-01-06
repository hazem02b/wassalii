# 🐘 Guide d'Installation PostgreSQL pour Wassali

## Option 1: Installation avec l'installateur officiel (Recommandé)

### Téléchargement
1. Allez sur: https://www.postgresql.org/download/windows/
2. Cliquez sur "Download the installer"
3. Téléchargez la version **PostgreSQL 16.x** (dernière version)

### Installation
1. **Lancez l'installateur téléchargé**
2. **Installation Directory**: Laissez par défaut `C:\Program Files\PostgreSQL\16`
3. **Components à installer**: Cochez tout (PostgreSQL Server, pgAdmin 4, Stack Builder, Command Line Tools)
4. **Data Directory**: Laissez par défaut `C:\Program Files\PostgreSQL\16\data`
5. **Password**: Choisissez un mot de passe pour l'utilisateur `postgres` (NOTEZ-LE!)
   - Par exemple: `postgres123`
6. **Port**: Laissez `5432` (port par défaut)
7. **Locale**: Sélectionnez votre langue ou laissez "Default locale"
8. **Cliquez sur Next** puis **Finish**

### Vérification
Après installation, ouvrez PowerShell et testez:
```powershell
psql --version
```

Vous devriez voir quelque chose comme: `psql (PostgreSQL) 16.x`

---

## Option 2: Installation avec Chocolatey (Plus rapide si vous avez Chocolatey)

### Installer Chocolatey d'abord (si pas déjà fait)
Ouvrez PowerShell en **mode Administrateur** et exécutez:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### Installer PostgreSQL
```powershell
choco install postgresql -y
```

---

## Après l'installation

### 1. Démarrer le service PostgreSQL (si pas déjà démarré)
```powershell
# Vérifier le statut
Get-Service postgresql*

# Si pas démarré:
Start-Service postgresql-x64-16  # ou le nom du service affiché
```

### 2. Créer la base de données Wassali

Ouvrez une nouvelle fenêtre PowerShell et exécutez:

```powershell
# Se connecter à PostgreSQL (mot de passe demandé)
psql -U postgres

# Dans psql, exécutez ces commandes:
CREATE DATABASE wassali_db;
CREATE USER wassali_user WITH PASSWORD 'wassali_password';
GRANT ALL PRIVILEGES ON DATABASE wassali_db TO wassali_user;

# Pour PostgreSQL 15+, exécutez aussi:
\c wassali_db
GRANT ALL ON SCHEMA public TO wassali_user;

# Quitter psql:
\q
```

### 3. Tester la connexion
```powershell
psql -U wassali_user -d wassali_db -h localhost
# Mot de passe: wassali_password
```

Si ça fonctionne, vous êtes prêt! Tapez `\q` pour quitter.

---

## Problèmes courants

### "psql n'est pas reconnu"
Ajoutez PostgreSQL au PATH:
1. Cherchez "Variables d'environnement" dans Windows
2. Variables système → Path → Modifier
3. Ajouter: `C:\Program Files\PostgreSQL\16\bin`
4. Redémarrez PowerShell

### "Connexion refusée"
Le service n'est pas démarré:
```powershell
Start-Service postgresql-x64-16
```

### "Authentification échouée"
Vérifiez le fichier `pg_hba.conf` dans `C:\Program Files\PostgreSQL\16\data\`
Assurez-vous qu'il contient:
```
host    all             all             127.0.0.1/32            md5
```

Redémarrez le service après modification:
```powershell
Restart-Service postgresql-x64-16
```

---

## Prochaine étape

Une fois PostgreSQL installé et la base de données créée:

```powershell
cd C:\Wassaliparceldeliveryapp\backend
.\install.ps1
```

Cela installera toutes les dépendances Python et préparera le backend!
