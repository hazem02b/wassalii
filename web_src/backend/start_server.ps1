#!/usr/bin/env pwsh
# Script de démarrage du serveur backend Wassali

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   Wassali Backend Server" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Se placer dans le répertoire backend
Set-Location $PSScriptRoot

# Démarrer le serveur avec uvicorn
Write-Host "Démarrage du serveur sur http://localhost:8000..." -ForegroundColor Green
Write-Host "Documentation API: http://localhost:8000/api/v1/docs" -ForegroundColor Yellow
Write-Host ""

$env:PYTHONPATH = $PSScriptRoot

C:\Users\HAZEM\AppData\Local\Programs\Python\Python310\python.exe -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload
