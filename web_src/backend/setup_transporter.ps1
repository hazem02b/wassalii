Write-Host "🚛 Création d'un compte transporteur de test..." -ForegroundColor Cyan

cd C:\Wassaliparceldeliveryapp\backend

# Activer l'environnement virtuel
if (Test-Path "venv\Scripts\Activate.ps1") {
    . .\venv\Scripts\Activate.ps1
    Write-Host "✅ Environnement virtuel activé" -ForegroundColor Green
} else {
    Write-Host "❌ Environnement virtuel non trouvé" -ForegroundColor Red
    exit 1
}

# Créer le transporteur
Write-Host "`n📝 Exécution du script de création..." -ForegroundColor Yellow
python create_transporter.py

Write-Host "`n✨ Compte transporteur créé!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "📧 Email: transporter@test.com" -ForegroundColor White
Write-Host "🔑 Mot de passe: Test123!" -ForegroundColor White
Write-Host "👤 Rôle: Transporteur" -ForegroundColor White
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "`n💡 Utilisez ces identifiants pour vous connecter en tant que transporteur" -ForegroundColor Yellow
