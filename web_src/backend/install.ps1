# Script PowerShell pour installer et démarrer le backend Wassali

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   Wassali Backend - Installation" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Vérifier si Python est installé
try {
    $pythonVersion = python --version
    Write-Host "✅ Python trouvé: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python n'est pas installé!" -ForegroundColor Red
    Write-Host "Téléchargez Python depuis: https://www.python.org/downloads/" -ForegroundColor Yellow
    exit 1
}

# Créer l'environnement virtuel
if (!(Test-Path "venv")) {
    Write-Host ""
    Write-Host "📦 Création de l'environnement virtuel..." -ForegroundColor Yellow
    python -m venv venv
    Write-Host "✅ Environnement virtuel créé" -ForegroundColor Green
}

# Activer l'environnement virtuel
Write-Host ""
Write-Host "🔄 Activation de l'environnement virtuel..." -ForegroundColor Yellow
& .\venv\Scripts\Activate.ps1

# Installer les dépendances
Write-Host ""
Write-Host "📥 Installation des dépendances..." -ForegroundColor Yellow
pip install -r requirements.txt

# Copier .env.example vers .env si nécessaire
if (!(Test-Path ".env")) {
    Write-Host ""
    Write-Host "📝 Création du fichier .env..." -ForegroundColor Yellow
    Copy-Item .env.example .env
    Write-Host "✅ Fichier .env créé" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  IMPORTANT: Éditez le fichier .env avec vos paramètres:" -ForegroundColor Yellow
    Write-Host "   - DATABASE_URL" -ForegroundColor White
    Write-Host "   - SECRET_KEY (générer avec: python -c 'import secrets; print(secrets.token_urlsafe(32))')" -ForegroundColor White
    Write-Host ""
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   ✅ Installation terminée!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Prochaines étapes:" -ForegroundColor Yellow
Write-Host "1. Installer PostgreSQL si pas déjà fait" -ForegroundColor White
Write-Host "2. Créer la base de données:" -ForegroundColor White
Write-Host "   psql -U postgres" -ForegroundColor Gray
Write-Host "   CREATE DATABASE wassali_db;" -ForegroundColor Gray
Write-Host "   CREATE USER wassali_user WITH PASSWORD 'wassali_password';" -ForegroundColor Gray
Write-Host "   GRANT ALL PRIVILEGES ON DATABASE wassali_db TO wassali_user;" -ForegroundColor Gray
Write-Host "3. Éditer le fichier .env" -ForegroundColor White
Write-Host "4. Lancer le serveur:" -ForegroundColor White
Write-Host "   .\start.bat   (ou: python main.py)" -ForegroundColor Gray
Write-Host ""

Read-Host "Appuyez sur Entrée pour continuer..."
