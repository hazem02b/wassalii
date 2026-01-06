$headers = @{
    "Content-Type" = "application/json"
}

$body = @{
    email = "test@transport.ma"
    password = "Test123!"
    first_name = "Ahmed"
    last_name = "Benali"
    phone = "+212612345678"
    role = "transporter"
} | ConvertTo-Json

Write-Host "`n🔄 Création d'un utilisateur transporteur..." -ForegroundColor Yellow

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/v1/auth/register" -Method Post -Headers $headers -Body $body
    
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host "✅ TRANSPORTEUR CRÉÉ !" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Green
    Write-Host "📧 Email : test@transport.ma" -ForegroundColor Cyan
    Write-Host "🔐 Password : Test123!" -ForegroundColor Cyan
    Write-Host "`n🔑 Token (copiez pour Swagger UI) :" -ForegroundColor Yellow
    Write-Host $response.access_token -ForegroundColor Gray
    
    # Sauvegarder le token
    $response.access_token | Out-File -FilePath "test_token.txt" -Encoding UTF8
    Write-Host "`n💾 Token sauvegardé dans test_token.txt" -ForegroundColor Green
    
} catch {
    if ($_.Exception.Response.StatusCode -eq 400) {
        Write-Host "`n⚠️ Utilisateur déjà existant" -ForegroundColor Yellow
        Write-Host "`n📝 Connexion avec les identifiants existants..." -ForegroundColor Yellow
        
        $loginBody = @{
            username = "test@transport.ma"
            password = "Test123!"
        }
        
        $loginResponse = Invoke-RestMethod -Uri "http://localhost:8000/api/v1/auth/login" -Method Post -Body $loginBody
        
        Write-Host "`n========================================" -ForegroundColor Green
        Write-Host "✅ CONNECTÉ !" -ForegroundColor Green
        Write-Host "========================================`n" -ForegroundColor Green
        Write-Host "📧 Email : test@transport.ma" -ForegroundColor Cyan
        Write-Host "`n🔑 Token (copiez pour Swagger UI) :" -ForegroundColor Yellow
        Write-Host $loginResponse.access_token -ForegroundColor Gray
        
        $loginResponse.access_token | Out-File -FilePath "test_token.txt" -Encoding UTF8
        Write-Host "`n💾 Token sauvegardé dans test_token.txt" -ForegroundColor Green
    } else {
        Write-Host "`n❌ Erreur : $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "📖 UTILISATION DANS SWAGGER UI" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`n1. Ouvrez : http://localhost:8000/api/v1/docs" -ForegroundColor White
Write-Host "2. Cliquez sur 'Authorize' (🔓)" -ForegroundColor White
Write-Host "3. Collez le token ci-dessus" -ForegroundColor White
Write-Host "4. Testez les endpoints !" -ForegroundColor White
Write-Host "`n========================================`n" -ForegroundColor Cyan
