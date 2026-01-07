@echo off
chcp 65001 >nul
title Wassali - Initialisation Base de Données
color 0B

echo ╔═══════════════════════════════════════════════════════════╗
echo ║        WASSALI - INITIALISATION BASE DE DONNEES          ║
echo ╚═══════════════════════════════════════════════════════════╝
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

REM Activer l'environnement virtuel si il existe
if exist "venv\Scripts\activate.bat" (
    echo 🔄 Activation de l'environnement virtuel...
    call venv\Scripts\activate.bat
    echo.
)

echo ╔═══════════════════════════════════════════════════════════╗
echo ║              CREATION DE LA BASE DE DONNEES              ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

REM Vérifier si la base existe déjà
if exist "wassali.db" (
    echo ⚠️  Une base de données existe déjà!
    echo.
    set /p choix="Voulez-vous la supprimer et créer une nouvelle base? (O/N): "
    if /i "%choix%"=="O" (
        echo 🗑️  Suppression de l'ancienne base...
        del wassali.db
        echo ✅ Ancienne base supprimée
        echo.
    ) else (
        echo 📝 Conservation de la base existante
        echo.
        goto CREATE_ACCOUNTS
    )
)

echo 🔨 Création de la base de données...
echo.

REM La base sera créée automatiquement au démarrage du serveur
echo ✅ La base de données sera créée au premier démarrage du serveur
echo.

:CREATE_ACCOUNTS
echo ╔═══════════════════════════════════════════════════════════╗
echo ║              CREATION DES COMPTES DE TEST                 ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo ⚠️  Assurez-vous que le serveur est lancé dans une autre fenêtre!
echo.
set /p continuer="Le serveur est-il lancé? (O/N): "

if /i not "%continuer%"=="O" (
    echo.
    echo 💡 Lancez d'abord le serveur avec: LANCER_SERVEUR.bat
    echo    Puis relancez ce script.
    echo.
    pause
    exit /b 0
)

echo.
echo 📝 Création des comptes de test...
echo.

REM Compte Client
echo [1/2] Création du compte CLIENT...
curl -X POST http://localhost:8000/api/v1/auth/register ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"client@wassali.com\",\"password\":\"ClientTest123!\",\"name\":\"Client Test\",\"phone\":\"0600000001\",\"role\":\"client\"}"

if errorlevel 1 (
    echo ❌ Erreur lors de la création du compte client
) else (
    echo ✅ Compte client créé
)
echo.

REM Compte Transporteur
echo [2/2] Création du compte TRANSPORTEUR...
curl -X POST http://localhost:8000/api/v1/auth/register ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"transporteur@wassali.com\",\"password\":\"TransportTest123!\",\"name\":\"Transporteur Test\",\"phone\":\"0600000002\",\"role\":\"transporter\"}"

if errorlevel 1 (
    echo ❌ Erreur lors de la création du compte transporteur
) else (
    echo ✅ Compte transporteur créé
)
echo.

echo ╔═══════════════════════════════════════════════════════════╗
echo ║                  INITIALISATION TERMINEE                  ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo ✅ Base de données prête!
echo ✅ Comptes de test créés:
echo.
echo 📱 COMPTE CLIENT:
echo    Email    : client@wassali.com
echo    Password : ClientTest123!
echo.
echo 🚛 COMPTE TRANSPORTEUR:
echo    Email    : transporteur@wassali.com
echo    Password : TransportTest123!
echo.
echo 💡 Utilisez ces comptes pour tester l'application!
echo.
echo ═══════════════════════════════════════════════════════════
echo.

pause
