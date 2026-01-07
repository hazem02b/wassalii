# Conversion Markdown vers PDF amelioree
Write-Host "Conversion du script en PDF..." -ForegroundColor Cyan

$mdFile = "SCRIPT_PRESENTATION_PROFESSEUR.md"
$htmlFile = "SCRIPT_PRESENTATION_PROFESSEUR_fixed.html"

# Lire le contenu markdown
$mdContent = Get-Content $mdFile -Raw -Encoding UTF8

# Echapper correctement pour JavaScript
$mdContentEscaped = $mdContent -replace '\\', '\\' -replace '`', '\`' -replace '\$', '\$' -replace '"', '\"'

# Creer HTML avec le contenu en base64 pour eviter les problemes d'echappement
$mdBase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($mdContent))

$html = @"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Script Presentation Wassali</title>
    <style>
        @page { margin: 2cm; }
        body { 
            font-family: 'Segoe UI', Arial, sans-serif; 
            line-height: 1.6; 
            max-width: 900px; 
            margin: 20px auto; 
            padding: 20px;
            color: #333;
        }
        h1 { 
            color: #2196F3; 
            border-bottom: 3px solid #2196F3; 
            padding-bottom: 10px;
            margin-top: 30px;
        }
        h2 { 
            color: #1976D2; 
            margin-top: 25px;
            border-left: 4px solid #2196F3;
            padding-left: 10px;
        }
        h3 { 
            color: #0D47A1; 
            margin-top: 20px;
        }
        h4 {
            color: #1565C0;
            margin-top: 15px;
        }
        code { 
            background: #f5f5f5; 
            padding: 2px 6px; 
            border-radius: 3px;
            font-family: Consolas, monospace;
            color: #d63384;
        }
        pre { 
            background: #f8f9fa; 
            padding: 15px; 
            border-left: 4px solid #2196F3;
            overflow-x: auto;
            border-radius: 4px;
        }
        pre code {
            background: none;
            color: #333;
            padding: 0;
        }
        ul, ol { 
            margin: 15px 0; 
            padding-left: 30px; 
        }
        li { 
            margin: 8px 0; 
        }
        blockquote {
            border-left: 4px solid #FF9800;
            padding-left: 15px;
            margin: 15px 0;
            color: #666;
            background: #fff3e0;
            padding: 10px 15px;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            margin: 20px 0;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        th {
            background: #2196F3;
            color: white;
        }
        tr:nth-child(even) {
            background: #f9f9f9;
        }
        strong {
            color: #1976D2;
        }
        em {
            color: #666;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/marked@4.0.0/marked.min.js"></script>
</head>
<body>
    <div id="content">Chargement...</div>
    <script>
        try {
            // Decoder le contenu depuis base64
            const base64Content = '$mdBase64';
            const decodedContent = atob(base64Content);
            const markdownContent = decodeURIComponent(escape(decodedContent));
            
            // Configurer marked
            marked.setOptions({
                breaks: true,
                gfm: true
            });
            
            // Convertir et afficher
            document.getElementById('content').innerHTML = marked.parse(markdownContent);
            console.log('Document charge avec succes');
        } catch (error) {
            document.getElementById('content').innerHTML = '<h1>Erreur</h1><p>' + error.message + '</p>';
            console.error('Erreur:', error);
        }
    </script>
</body>
</html>
"@

$html | Out-File -FilePath $htmlFile -Encoding UTF8

Write-Host "HTML cree: $htmlFile" -ForegroundColor Green
Write-Host ""
Write-Host "Ouverture du navigateur..." -ForegroundColor Cyan
Write-Host ""
Write-Host "Pour creer le PDF:" -ForegroundColor Yellow
Write-Host "  1. Appuyez sur Ctrl+P" -ForegroundColor White
Write-Host "  2. Selectionnez 'Microsoft Print to PDF'" -ForegroundColor White
Write-Host "  3. Cliquez sur Enregistrer" -ForegroundColor White

Start-Process $htmlFile
