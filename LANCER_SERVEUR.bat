@echo off
chcp 65001 >nul
title Wassali - Serveur Backend pour Réseau
color 0A

echo ╔═══════════════════════════════════════════════════════════╗
echo ║           WASSALI - SERVEUR BACKEND RESEAU                ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

REM Vérifier si Python est installé
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ ERREUR: Python n'est pas installé!
    echo    Installez Python depuis: https://www.python.org
    pause
    exit /b 1
)

echo ✅ Python détecté
echo.

REM Aller dans le dossier backend
cd /d "%~dp0web_src\backend"
if errorlevel 1 (
    echo ❌ ERREUR: Dossier backend introuvable!
    pause
    exit /b 1
)

echo 📁 Dossier: %CD%
echo.

REM Installer les dépendances si nécessaire
if not exist "venv\" (
    echo 📦 Création de l'environnement virtuel...
    python -m venv venv
    echo.
)

REM Activer l'environnement virtuel
if exist "venv\Scripts\activate.bat" (
    echo 🔄 Activation de l'environnement virtuel...
    call venv\Scripts\activate.bat
    echo.
)

REM Installer les requirements
echo 📦 Installation des dépendances...
pip install -r requirements.txt --quiet
echo ✅ Dépendances installées
echo.

REM Afficher l'adresse IP
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                    VOTRE ADRESSE IP                       ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo 📍 Trouvez votre IP ci-dessous:
echo.
ipconfig | findstr /i "IPv4"
echo.
echo 💡 Utilisez cette IP dans lib/config/api_config.dart
echo    Exemple: static const String baseUrl = 'http://192.168.1.123:8000/api/v1';
echo.

REM Vérifier le firewall
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                    CONFIGURATION FIREWALL                 ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo ⚠️  Pour que vos amis puissent se connecter:
echo.
echo    1. Ouvrez PowerShell EN TANT QU'ADMINISTRATEUR
echo    2. Exécutez cette commande:
echo.
echo    netsh advfirewall firewall add rule name="Wassali Backend" dir=in action=allow protocol=TCP localport=8000
echo.
echo    3. Appuyez sur Entrée pour continuer ici
echo.
pause

echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                  DEMARRAGE DU SERVEUR                     ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo 🚀 Le serveur démarre sur: http://0.0.0.0:8000
echo 📚 Documentation API: http://localhost:8000/docs
echo.
echo ✅ Vos amis peuvent se connecter avec votre IP
echo ❌ NE FERMEZ PAS cette fenêtre!
echo.
echo ═══════════════════════════════════════════════════════════
echo.

REM Démarrer le serveur sur toutes les interfaces réseau (0.0.0.0)
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000

pause
