# Script de préparation pour Git
# Nettoie le projet et prépare pour le push

Write-Host "🧹 Préparation du projet pour Git..." -ForegroundColor Cyan
Write-Host ""

# Nettoyer Flutter
Write-Host "🗑️  Nettoyage des fichiers Flutter..." -ForegroundColor Yellow
flutter clean
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Flutter nettoyé" -ForegroundColor Green
}

# Nettoyer les fichiers Python
Write-Host "🗑️  Nettoyage des fichiers Python..." -ForegroundColor Yellow
Get-ChildItem -Path . -Filter "__pycache__" -Recurse -Directory | Remove-Item -Recurse -Force
Get-ChildItem -Path . -Filter "*.pyc" -Recurse | Remove-Item -Force
Get-ChildItem -Path . -Filter "*.pyo" -Recurse | Remove-Item -Force
Write-Host "✅ Python nettoyé" -ForegroundColor Green

# Supprimer les bases de données de test (garder la structure)
Write-Host "🗑️  Nettoyage des bases de données de test..." -ForegroundColor Yellow
if (Test-Path "web_src\backend\wassali_test.db") {
    Write-Host "⚠️  Base de données de test trouvée (wassali_test.db)" -ForegroundColor Yellow
    $response = Read-Host "Voulez-vous la supprimer ? (o/N)"
    if ($response -eq "o" -or $response -eq "O") {
        Remove-Item "web_src\backend\wassali_test.db" -Force
        Write-Host "✅ Base de données supprimée" -ForegroundColor Green
    } else {
        Write-Host "⏭️  Base de données conservée" -ForegroundColor Cyan
    }
}

# Supprimer les logs
Write-Host "🗑️  Nettoyage des logs..." -ForegroundColor Yellow
Get-ChildItem -Path . -Filter "*.log" -Recurse | Remove-Item -Force
Write-Host "✅ Logs supprimés" -ForegroundColor Green

# Vérifier le .gitignore
Write-Host ""
Write-Host "📋 Vérification du .gitignore..." -ForegroundColor Yellow
if (Test-Path ".gitignore") {
    Write-Host "✅ .gitignore présent" -ForegroundColor Green
} else {
    Write-Host "❌ .gitignore manquant!" -ForegroundColor Red
}

# Afficher les fichiers qui seront trackés
Write-Host ""
Write-Host "📁 Fichiers qui seront commités:" -ForegroundColor Cyan
git status --short 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  Git n'est pas initialisé" -ForegroundColor Yellow
    $initGit = Read-Host "Voulez-vous initialiser Git ? (o/N)"
    if ($initGit -eq "o" -or $initGit -eq "O") {
        git init
        Write-Host "✅ Git initialisé" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "📊 Statistiques du projet:" -ForegroundColor Cyan

# Compter les lignes de code
$dartFiles = (Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse | Measure-Object).Count
$pythonFiles = (Get-ChildItem -Path "web_src/backend" -Filter "*.py" -Recurse | Measure-Object).Count

Write-Host "   📱 Fichiers Dart:   $dartFiles" -ForegroundColor White
Write-Host "   🐍 Fichiers Python: $pythonFiles" -ForegroundColor White

Write-Host ""
Write-Host "✅ Projet prêt pour Git!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Prochaines étapes suggérées:" -ForegroundColor Cyan
Write-Host "   1. git add ." -ForegroundColor White
Write-Host "   2. git commit -m 'feat: complete mobile app with backend'" -ForegroundColor White
Write-Host "   3. git remote add origin <URL_REPO>" -ForegroundColor White
Write-Host "   4. git push -u origin main" -ForegroundColor White
Write-Host ""
Write-Host "💡 Ou créer un tag de version:" -ForegroundColor Yellow
Write-Host "   git tag -a v1.0.0 -m 'Version 1.0.0'" -ForegroundColor White
Write-Host "   git push origin v1.0.0" -ForegroundColor White
Write-Host ""

Read-Host "Appuyez sur Entrée pour terminer"
