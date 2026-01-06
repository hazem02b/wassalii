# Script PowerShell pour créer la base de données Wassali
# Remplacez VOTRE_MOT_DE_PASSE par le mot de passe que vous avez choisi lors de l'installation

$POSTGRES_PASSWORD = "postgres123"  # <-- CHANGEZ ICI avec votre mot de passe

# Chemin vers psql
$PSQL = "C:\Program Files\PostgreSQL\18\bin\psql.exe"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   Création de la base de données Wassali" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Définir le mot de passe dans l'environnement
$env:PGPASSWORD = $POSTGRES_PASSWORD

try {
    Write-Host "1. Création de la base de données 'wassali_db'..." -ForegroundColor Yellow
    & $PSQL -U postgres -h localhost -c "CREATE DATABASE wassali_db;" 2>&1 | Out-Null
    Write-Host "   ✅ Base de données créée" -ForegroundColor Green
} catch {
    Write-Host "   ⚠️  La base de données existe peut-être déjà" -ForegroundColor Yellow
}

try {
    Write-Host "2. Création de l'utilisateur 'wassali_user'..." -ForegroundColor Yellow
    & $PSQL -U postgres -h localhost -c "CREATE USER wassali_user WITH PASSWORD 'wassali_password';" 2>&1 | Out-Null
    Write-Host "   ✅ Utilisateur créé" -ForegroundColor Green
} catch {
    Write-Host "   ⚠️  L'utilisateur existe peut-être déjà" -ForegroundColor Yellow
}

Write-Host "3. Attribution des privilèges..." -ForegroundColor Yellow
& $PSQL -U postgres -h localhost -c "GRANT ALL PRIVILEGES ON DATABASE wassali_db TO wassali_user;"
& $PSQL -U postgres -d wassali_db -c "GRANT ALL ON SCHEMA public TO wassali_user;"
Write-Host "   ✅ Privilèges accordés" -ForegroundColor Green

Write-Host ""
Write-Host "4. Vérification de la connexion..." -ForegroundColor Yellow
$env:PGPASSWORD = "wassali_password"
$result = & $PSQL -U wassali_user -d wassali_db -h localhost -c "SELECT version();" 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ Connexion réussie!" -ForegroundColor Green
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "   ✅ Configuration terminée!" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Base de données prête:" -ForegroundColor Green
    Write-Host "  - Nom: wassali_db" -ForegroundColor White
    Write-Host "  - Utilisateur: wassali_user" -ForegroundColor White
    Write-Host "  - Mot de passe: wassali_password" -ForegroundColor White
    Write-Host "  - Host: localhost" -ForegroundColor White
    Write-Host "  - Port: 5432" -ForegroundColor White
    Write-Host ""
    Write-Host "Prochaine étape:" -ForegroundColor Yellow
    Write-Host "  cd backend" -ForegroundColor White
    Write-Host "  .\install.ps1" -ForegroundColor White
} else {
    Write-Host "   ❌ Erreur de connexion" -ForegroundColor Red
    Write-Host $result
}

# Nettoyer
Remove-Item Env:\PGPASSWORD
