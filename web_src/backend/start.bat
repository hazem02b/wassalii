@echo off
echo ============================================
echo    Wassali Backend - Lancement Rapide
echo ============================================
echo.

REM Activer l'environnement virtuel
if exist venv\Scripts\activate.bat (
    echo Activation de l'environnement virtuel...
    call venv\Scripts\activate.bat
) else (
    echo ERREUR: Environnement virtuel non trouve!
    echo Veuillez executer: python -m venv venv
    pause
    exit /b 1
)

REM Vérifier si .env existe
if not exist .env (
    echo ATTENTION: Fichier .env non trouve!
    echo Copie de .env.example vers .env...
    copy .env.example .env
    echo.
    echo IMPORTANT: Editez le fichier .env avec vos parametres!
    echo Notamment DATABASE_URL et SECRET_KEY
    pause
)

echo.
echo Demarrage du serveur FastAPI...
echo API: http://localhost:8000
echo Docs: http://localhost:8000/api/v1/docs
echo.

python main.py

pause
