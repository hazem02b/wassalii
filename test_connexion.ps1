$body = @{
    email = "transporteur@wassali.com"
    password = "transporteur123"
    role = "transporter"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/api/v1/auth/login" `
        -Method POST `
        -ContentType "application/json" `
        -Body $body `
        -UseBasicParsing

    Write-Host "✅ SUCCÈS!" -ForegroundColor Green
    Write-Host "Status: $($response.StatusCode)"
    Write-Host "Réponse:"
    $response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 5
} catch {
    Write-Host "❌ ERREUR!" -ForegroundColor Red
    Write-Host $_.Exception.Message
}
