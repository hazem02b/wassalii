# Script de lancement complet - Wassali App
# Lance le backend et le frontend automatiquement

Write-Host "🚀 Démarrage de Wassali App..." -ForegroundColor Cyan
Write-Host ""

# Vérifier si Python est installé
Write-Host "📋 Vérification des prérequis..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ Python: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python n'est pas installé!" -ForegroundColor Red
    Write-Host "Téléchargez Python depuis: https://www.python.org/downloads/" -ForegroundColor Yellow
    exit 1
}

# Vérifier si Flutter est installé
try {
    $flutterVersion = flutter --version 2>&1 | Select-Object -First 1
    Write-Host "✅ Flutter installé" -ForegroundColor Green
} catch {
    Write-Host "❌ Flutter n'est pas installé!" -ForegroundColor Red
    Write-Host "Téléchargez Flutter depuis: https://flutter.dev/docs/get-started/install" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "🔧 Installation des dépendances..." -ForegroundColor Yellow

# Installer les dépendances backend
Write-Host "📦 Installation des dépendances backend..." -ForegroundColor Cyan
Set-Location web_src\backend
pip install -r requirements.txt --quiet
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erreur lors de l'installation des dépendances backend" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Dépendances backend installées" -ForegroundColor Green

# Retour à la racine
Set-Location ..\..

# Installer les dépendances frontend
Write-Host "📦 Installation des dépendances frontend..." -ForegroundColor Cyan
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erreur lors de l'installation des dépendances frontend" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Dépendances frontend installées" -ForegroundColor Green

Write-Host ""
Write-Host "🚀 Lancement des serveurs..." -ForegroundColor Yellow
Write-Host ""

# Lancer le backend dans un nouveau terminal
Write-Host "🔌 Démarrage du backend sur http://localhost:8000..." -ForegroundColor Cyan
$backendPath = Join-Path $PSScriptRoot "web_src\backend"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$backendPath'; Write-Host '🔌 Backend API - Port 8000' -ForegroundColor Green; Write-Host 'Documentation: http://localhost:8000/docs' -ForegroundColor Cyan; Write-Host ''; uvicorn app.main:app --reload --host 0.0.0.0 --port 8000"

# Attendre que le backend démarre
Write-Host "⏳ Attente du démarrage du backend..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Tester si le backend répond
$backendReady = $false
$maxAttempts = 10
$attempt = 0

while (-not $backendReady -and $attempt -lt $maxAttempts) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8000/health" -TimeoutSec 2 -ErrorAction SilentlyContinue
        if ($response.StatusCode -eq 200) {
            $backendReady = $true
            Write-Host "✅ Backend démarré avec succès!" -ForegroundColor Green
        }
    } catch {
        $attempt++
        Write-Host "⏳ Tentative $attempt/$maxAttempts..." -ForegroundColor Yellow
        Start-Sleep -Seconds 2
    }
}

if (-not $backendReady) {
    Write-Host "⚠️  Le backend met du temps à démarrer, mais on continue..." -ForegroundColor Yellow
}

Write-Host ""

# Lancer le frontend dans un nouveau terminal
Write-Host "📱 Démarrage du frontend Flutter..." -ForegroundColor Cyan
$frontendPath = $PSScriptRoot
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$frontendPath'; Write-Host '📱 Application Mobile Flutter' -ForegroundColor Green; Write-Host ''; flutter run -d chrome"

Write-Host ""
Write-Host "✅ Tous les serveurs sont lancés!" -ForegroundColor Green
Write-Host ""
Write-Host "📍 URLs importantes:" -ForegroundColor Cyan
Write-Host "   🔌 Backend API:     http://localhost:8000" -ForegroundColor White
Write-Host "   📚 Documentation:   http://localhost:8000/docs" -ForegroundColor White
Write-Host "   📱 Application:     Chrome (démarrage automatique)" -ForegroundColor White
Write-Host ""
Write-Host "🔑 Comptes de test:" -ForegroundColor Cyan
Write-Host "   Client:        client@test.com / password123" -ForegroundColor White
Write-Host "   Transporteur:  transporteur@test.com / password123" -ForegroundColor White
Write-Host ""
Write-Host "💡 Conseil: Gardez cette fenêtre ouverte pour voir les logs" -ForegroundColor Yellow
Write-Host ""
Write-Host "Pour arrêter les serveurs, fermez les terminaux ou appuyez sur Ctrl+C" -ForegroundColor Gray
Write-Host ""

# Garder le terminal ouvert
Read-Host "Appuyez sur Entrée pour quitter ce script..."
