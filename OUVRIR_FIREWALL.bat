@echo off
chcp 65001 >nul
title Wassali - Configuration Firewall
color 0E

echo ╔═══════════════════════════════════════════════════════════╗
echo ║           WASSALI - CONFIGURATION FIREWALL                ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

REM Vérifier les privilèges administrateur
net session >nul 2>&1
if errorlevel 1 (
    echo ❌ ERREUR: Ce script nécessite des privilèges administrateur!
    echo.
    echo 💡 Solution:
    echo    1. Faites un clic droit sur ce fichier
    echo    2. Sélectionnez "Exécuter en tant qu'administrateur"
    echo.
    pause
    exit /b 1
)

echo ✅ Privilèges administrateur confirmés
echo.

echo 🔓 Ouverture du port 8000 dans le firewall...
echo.

REM Supprimer la règle existante si elle existe (pour éviter les doublons)
netsh advfirewall firewall delete rule name="Wassali Backend" >nul 2>&1

REM Ajouter la nouvelle règle
netsh advfirewall firewall add rule name="Wassali Backend" dir=in action=allow protocol=TCP localport=8000

if errorlevel 1 (
    echo ❌ ERREUR lors de la configuration du firewall
    pause
    exit /b 1
)

echo.
echo ✅ Firewall configuré avec succès!
echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                    CONFIGURATION TERMINEE                 ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo 📝 Règle créée: "Wassali Backend"
echo 🔓 Port ouvert: 8000 (TCP)
echo 🌐 Direction: Entrant
echo.
echo 💡 Vous pouvez maintenant:
echo    1. Lancer le serveur avec: LANCER_SERVEUR.bat
echo    2. Vos amis pourront se connecter depuis leur téléphone
echo.
echo ═══════════════════════════════════════════════════════════
echo.

pause
