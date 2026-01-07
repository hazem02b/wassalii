# Conversion simple Markdown vers PDF
Write-Host "Conversion du script en PDF..." -ForegroundColor Cyan

$mdFile = "SCRIPT_PRESENTATION_PROFESSEUR.md"
$htmlFile = "SCRIPT_PRESENTATION_PROFESSEUR.html"

# Lire le contenu markdown
$mdContent = Get-Content $mdFile -Raw -Encoding UTF8

# Creer HTML
$html = @"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Script Presentation Wassali</title>
    <style>
        body { font-family: Arial; line-height: 1.6; max-width: 800px; margin: 40px auto; padding: 20px; }
        h1 { color: #2196F3; border-bottom: 2px solid #2196F3; }
        h2 { color: #1976D2; margin-top: 30px; }
        h3 { color: #0D47A1; }
        code { background: #f5f5f5; padding: 2px 6px; }
        pre { background: #f5f5f5; padding: 15px; border-left: 4px solid #2196F3; }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
</head>
<body>
    <div id="content"></div>
    <script>
        document.getElementById('content').innerHTML = marked.parse(`$($mdContent -replace '`', '\`')`);
    </script>
</body>
</html>
"@

$html | Out-File -FilePath $htmlFile -Encoding UTF8

Write-Host "HTML cree avec succes!" -ForegroundColor Green
Write-Host ""
Write-Host "ETAPES:" -ForegroundColor Yellow
Write-Host "1. Ouverture du navigateur..." -ForegroundColor White
Write-Host "2. Appuyez sur Ctrl+P" -ForegroundColor White
Write-Host "3. Selectionnez 'Microsoft Print to PDF'" -ForegroundColor White
Write-Host "4. Cliquez sur Enregistrer" -ForegroundColor White

Start-Process $htmlFile
