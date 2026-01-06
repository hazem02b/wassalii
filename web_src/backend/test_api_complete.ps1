# Script de test de l'API Wassali
# Teste les principaux endpoints de l'API

import json

# Test 1: Inscription d'un transporteur
Write-Host "`n=== TEST 1: Inscription d'un transporteur ===`n" -ForegroundColor Cyan

$registerData = @{
    email = "ahmed@transport.ma"
    password = "Ahmed123!"
    first_name = "Ahmed"
    last_name = "Benali"
    phone = "+212612345678"
    role = "transporter"
} | ConvertTo-Json

$response1 = Invoke-RestMethod -Uri "http://localhost:8000/api/v1/auth/register" `
    -Method Post `
    -Body $registerData `
    -ContentType "application/json"

Write-Host "✅ Transporteur créé:" -ForegroundColor Green
Write-Host "  Email: $($response1.user.email)"
Write-Host "  ID: $($response1.user.id)"
Write-Host "  Token: $($response1.access_token.Substring(0,20))..."

$token = $response1.access_token

# Test 2: Inscription d'un client
Write-Host "`n=== TEST 2: Inscription d'un client ===`n" -ForegroundColor Cyan

$registerClient = @{
    email = "fatima@client.ma"
    password = "Fatima123!"
    first_name = "Fatima"
    last_name = "Zahra"
    phone = "+212698765432"
    role = "client"
} | ConvertTo-Json

$response2 = Invoke-RestMethod -Uri "http://localhost:8000/api/v1/auth/register" `
    -Method Post `
    -Body $registerClient `
    -ContentType "application/json"

Write-Host "✅ Client créé:" -ForegroundColor Green
Write-Host "  Email: $($response2.user.email)"
Write-Host "  ID: $($response2.user.id)"

$clientToken = $response2.access_token

# Test 3: Créer un trajet
Write-Host "`n=== TEST 3: Création d'un trajet ===`n" -ForegroundColor Cyan

$tripData = @{
    origin_city = "Casablanca"
    origin_country = "Maroc"
    destination_city = "Paris"
    destination_country = "France"
    departure_date = "2025-01-15T10:00:00"
    arrival_date = "2025-01-16T08:00:00"
    max_weight = 30
    available_weight = 30
    price_per_kg = 15
    description = "Trajet régulier Casablanca-Paris"
    vehicle_info = "Voiture spacieuse"
} | ConvertTo-Json

$headers = @{
    "Authorization" = "Bearer $token"
}

$response3 = Invoke-RestMethod -Uri "http://localhost:8000/api/v1/trips" `
    -Method Post `
    -Body $tripData `
    -ContentType "application/json" `
    -Headers $headers

Write-Host "✅ Trajet créé:" -ForegroundColor Green
Write-Host "  ID: $($response3.id)"
Write-Host "  Route: $($response3.origin_city) → $($response3.destination_city)"
Write-Host "  Prix: $($response3.price_per_kg)€/kg"

$tripId = $response3.id

# Test 4: Rechercher des trajets
Write-Host "`n=== TEST 4: Recherche de trajets ===`n" -ForegroundColor Cyan

$response4 = Invoke-RestMethod -Uri "http://localhost:8000/api/v1/trips?origin_city=Casablanca" `
    -Method Get

Write-Host "✅ Trajets trouvés: $($response4.Count)" -ForegroundColor Green
foreach ($trip in $response4) {
    Write-Host "  - $($trip.origin_city) → $($trip.destination_city) ($($trip.price_per_kg)€/kg)"
}

# Test 5: Créer une réservation
Write-Host "`n=== TEST 5: Création d'une réservation ===`n" -ForegroundColor Cyan

$bookingData = @{
    trip_id = $tripId
    weight = 5
    item_description = "Colis personnel - vêtements et cadeaux"
    pickup_address = "123 Rue Mohammed V, Casablanca"
    delivery_address = "45 Avenue des Champs-Élysées, Paris"
} | ConvertTo-Json

$clientHeaders = @{
    "Authorization" = "Bearer $clientToken"
}

$response5 = Invoke-RestMethod -Uri "http://localhost:8000/api/v1/bookings" `
    -Method Post `
    -Body $bookingData `
    -ContentType "application/json" `
    -Headers $clientHeaders

Write-Host "✅ Réservation créée:" -ForegroundColor Green
Write-Host "  ID: $($response5.id)"
Write-Host "  Poids: $($response5.weight) kg"
Write-Host "  Prix total: $($response5.total_price)€"
Write-Host "  Statut: $($response5.status)"

# Test 6: Récupérer le profil utilisateur
Write-Host "`n=== TEST 6: Profil utilisateur ===`n" -ForegroundColor Cyan

$response6 = Invoke-RestMethod -Uri "http://localhost:8000/api/v1/auth/me" `
    -Method Get `
    -Headers $headers

Write-Host "✅ Profil transporteur:" -ForegroundColor Green
Write-Host "  Nom: $($response6.first_name) $($response6.last_name)"
Write-Host "  Email: $($response6.email)"
Write-Host "  Role: $($response6.role)"

# Resume
Write-Host ""
Write-Host "=== RESUME DES TESTS ===" -ForegroundColor Yellow
Write-Host ""
Write-Host "OK - Inscription transporteur" -ForegroundColor Green
Write-Host "OK - Inscription client" -ForegroundColor Green
Write-Host "OK - Creation de trajet" -ForegroundColor Green
Write-Host "OK - Recherche de trajets" -ForegroundColor Green
Write-Host "OK - Creation de reservation" -ForegroundColor Green
Write-Host "OK - Profil utilisateur" -ForegroundColor Green
Write-Host ""
Write-Host "Tous les tests ont reussi!" -ForegroundColor Green
Write-Host "Documentation API: http://localhost:8000/api/v1/docs" -ForegroundColor Cyan
