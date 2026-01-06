# Test de l'API users/available
$token = (Invoke-RestMethod -Uri "http://127.0.0.1:8888/api/v1/auth/login" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"email":"hazembellili800@gmail.com","password":"123456","role":"client"}').access_token

Write-Host "Token obtenu: $($token.Substring(0,20))..." -ForegroundColor Green

$users = Invoke-RestMethod -Uri "http://127.0.0.1:8888/api/v1/users/available" -Headers @{"Authorization"="Bearer $token"}

Write-Host "`nNombre total d'utilisateurs: $($users.Count)" -ForegroundColor Yellow

Write-Host "`nRecherche 'oussema bellili':" -ForegroundColor Cyan
$users | Where-Object { $_.name -like "*oussema*" } | Select-Object id, name, email, role | Format-Table -AutoSize

Write-Host "`nTous les utilisateurs:" -ForegroundColor Cyan
$users | Select-Object id, name, email, role | Format-Table -AutoSize
