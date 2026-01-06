#!/usr/bin/env pwsh
# Script de démarrage du serveur backend Wassali

Write-Host "Demarrage du serveur backend Wassali..." -ForegroundColor Cyan

# Aller dans le répertoire backend
Set-Location $PSScriptRoot

Write-Host "Repertoire: $PWD" -ForegroundColor Yellow

# Démarrer uvicorn
Write-Host "Lancement d'uvicorn..." -ForegroundColor Green

C:\Users\HAZEM\AppData\Local\Programs\Python\Python310\python.exe -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
