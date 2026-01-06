# Script pour réinitialiser le mot de passe PostgreSQL
# Ce script modifie temporairement la configuration pour permettre la connexion sans mot de passe

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   Réinitialisation PostgreSQL" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$pgData = "C:\Program Files\PostgreSQL\18\data"
$pgHbaPath = "$pgData\pg_hba.conf"
$pgHbaBackup = "$pgData\pg_hba.conf.backup"

Write-Host "1. Sauvegarde de la configuration..." -ForegroundColor Yellow
Copy-Item $pgHbaPath $pgHbaBackup -Force
Write-Host "   ✅ Sauvegarde créée" -ForegroundColor Green

Write-Host "2. Modification de pg_hba.conf pour permettre l'accès local..." -ForegroundColor Yellow

# Lire le fichier
$content = Get-Content $pgHbaPath

# Remplacer les lignes md5/scram-sha-256 par trust pour IPv4 et IPv6
$newContent = $content | ForEach-Object {
    if ($_ -match "^host\s+all\s+all\s+127\.0\.0\.1/32\s+(md5|scram-sha-256)") {
        "host    all             all             127.0.0.1/32            trust"
    }
    elseif ($_ -match "^host\s+all\s+all\s+::1/128\s+(md5|scram-sha-256)") {
        "host    all             all             ::1/128                 trust"
    }
    else {
        $_
    }
}

$newContent | Set-Content $pgHbaPath
Write-Host "   ✅ Configuration modifiée" -ForegroundColor Green

Write-Host "3. Redémarrage du service PostgreSQL..." -ForegroundColor Yellow
$serviceName = Get-Service | Where-Object { $_.Name -like "postgresql*" } | Select-Object -First 1 -ExpandProperty Name

if ($serviceName) {
    Restart-Service $serviceName -Force
    Start-Sleep -Seconds 3
    Write-Host "   ✅ Service redémarré" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Service non trouvé. Redémarrez manuellement PostgreSQL" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "4. Réinitialisation du mot de passe postgres..." -ForegroundColor Yellow
$PSQL = "C:\Program Files\PostgreSQL\18\bin\psql.exe"

# Maintenant on peut se connecter sans mot de passe
& $PSQL -U postgres -h localhost -c "ALTER USER postgres WITH PASSWORD 'postgres123';"
Write-Host "   ✅ Mot de passe postgres défini: postgres123" -ForegroundColor Green

Write-Host "5. Réinitialisation du mot de passe wassali_user..." -ForegroundColor Yellow
& $PSQL -U postgres -h localhost -c "ALTER USER wassali_user WITH PASSWORD 'wassali_password';"
Write-Host "   ✅ Mot de passe wassali_user défini: wassali_password" -ForegroundColor Green

Write-Host "6. Restauration de la configuration sécurisée..." -ForegroundColor Yellow
$secureContent = $newContent | ForEach-Object {
    if ($_ -match "^host\s+all\s+all\s+127\.0\.0\.1/32\s+trust") {
        "host    all             all             127.0.0.1/32            scram-sha-256"
    }
    elseif ($_ -match "^host\s+all\s+all\s+::1/128\s+trust") {
        "host    all             all             ::1/128                 scram-sha-256"
    }
    else {
        $_
    }
}
$secureContent | Set-Content $pgHbaPath
Write-Host "   ✅ Configuration sécurisée restaurée" -ForegroundColor Green

Write-Host "7. Redémarrage final..." -ForegroundColor Yellow
Restart-Service $serviceName -Force
Start-Sleep -Seconds 3
Write-Host "   ✅ Service redémarré" -ForegroundColor Green

Write-Host ""
Write-Host "8. Test de connexion..." -ForegroundColor Yellow
$env:PGPASSWORD = "wassali_password"
$result = & $PSQL -U wassali_user -d wassali_db -h localhost -c "SELECT 'Connexion réussie!' as status;" 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "   ✅ SUCCÈS!" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "PostgreSQL configuré avec:" -ForegroundColor Green
    Write-Host "  - Utilisateur postgres: postgres123" -ForegroundColor White
    Write-Host "  - Utilisateur wassali_user: wassali_password" -ForegroundColor White
    Write-Host ""
    Write-Host "Prochaine étape:" -ForegroundColor Yellow
    Write-Host "  .\install.ps1" -ForegroundColor White
} else {
    Write-Host "   ❌ Erreur persistante" -ForegroundColor Red
    Write-Host $result
}

Remove-Item Env:\PGPASSWORD -ErrorAction SilentlyContinue
