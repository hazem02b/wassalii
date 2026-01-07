# Script de conversion Markdown vers PDF
# Convertit SCRIPT_PRESENTATION_PROFESSEUR.md en PDF

Write-Host "🔄 Conversion du script de présentation en PDF..." -ForegroundColor Cyan
Write-Host ""

$scriptDir = $PSScriptRoot
$mdFile = Join-Path $scriptDir "SCRIPT_PRESENTATION_PROFESSEUR.md"
$htmlFile = Join-Path $scriptDir "SCRIPT_PRESENTATION_PROFESSEUR.html"
$pdfFile = Join-Path $scriptDir "SCRIPT_PRESENTATION_PROFESSEUR.pdf"

# Vérifier que le fichier markdown existe
if (-not (Test-Path $mdFile)) {
    Write-Host "❌ Erreur: Fichier SCRIPT_PRESENTATION_PROFESSEUR.md non trouvé" -ForegroundColor Red
    exit 1
}

Write-Host "📄 Fichier trouvé: $mdFile" -ForegroundColor Green
Write-Host ""

# Méthode 1 : Utiliser Pandoc si installé
$pandocPath = Get-Command pandoc -ErrorAction SilentlyContinue

if ($pandocPath) {
    Write-Host "✅ Pandoc détecté, conversion en cours..." -ForegroundColor Green
    
    try {
        & pandoc $mdFile -o $pdfFile `
            --pdf-engine=wkhtmltopdf `
            -V geometry:margin=1in `
            --toc `
            --toc-depth=2 `
            --metadata title="Script de Présentation - Projet Wassali"
        
        if (Test-Path $pdfFile) {
            Write-Host "✅ PDF créé avec succès!" -ForegroundColor Green
            Write-Host "📍 Emplacement: $pdfFile" -ForegroundColor Cyan
            
            # Ouvrir le PDF
            Start-Process $pdfFile
            exit 0
        }
    } catch {
        Write-Host "⚠️ Erreur avec Pandoc, tentative méthode alternative..." -ForegroundColor Yellow
    }
}

# Méthode 2 : Convertir en HTML puis ouvrir dans le navigateur pour impression PDF
Write-Host "📝 Conversion en HTML..." -ForegroundColor Cyan

# Lire le contenu markdown
$mdContent = Get-Content $mdFile -Raw -Encoding UTF8

# Créer un HTML avec style
$htmlContent = @"
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Script de Présentation - Projet Wassali</title>
    <style>
        @page {
            margin: 2cm;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 210mm;
            margin: 0 auto;
            padding: 20px;
            background: white;
        }
        
        h1 {
            color: #2196F3;
            border-bottom: 3px solid #2196F3;
            padding-bottom: 10px;
            page-break-after: avoid;
        }
        
        h2 {
            color: #1976D2;
            margin-top: 30px;
            page-break-after: avoid;
        }
        
        h3 {
            color: #0D47A1;
            margin-top: 20px;
            page-break-after: avoid;
        }
        
        h4 {
            color: #1565C0;
            page-break-after: avoid;
        }
        
        code {
            background: #f5f5f5;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Consolas', 'Monaco', monospace;
            font-size: 0.9em;
        }
        
        pre {
            background: #f5f5f5;
            padding: 15px;
            border-left: 4px solid #2196F3;
            overflow-x: auto;
            page-break-inside: avoid;
        }
        
        pre code {
            background: none;
            padding: 0;
        }
        
        blockquote {
            border-left: 4px solid #FF9800;
            padding-left: 20px;
            margin-left: 0;
            color: #555;
            background: #FFF3E0;
            padding: 10px 20px;
            page-break-inside: avoid;
        }
        
        table {
            border-collapse: collapse;
            width: 100%;
            margin: 20px 0;
            page-break-inside: avoid;
        }
        
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        
        th {
            background: #2196F3;
            color: white;
        }
        
        tr:nth-child(even) {
            background: #f5f5f5;
        }
        
        ul, ol {
            margin: 15px 0;
            padding-left: 30px;
        }
        
        li {
            margin: 8px 0;
        }
        
        .page-break {
            page-break-after: always;
        }
        
        @media print {
            body {
                padding: 0;
            }
            
            h1, h2, h3, h4 {
                page-break-after: avoid;
            }
            
            pre, blockquote, table {
                page-break-inside: avoid;
            }
        }
    </style>
    <!-- Marked.js pour le rendu Markdown -->
    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
</head>
<body>
    <div id="content"></div>
    
    <script>
        // Contenu Markdown
        const markdownContent = `$($mdContent -replace '`', '\`')`;
        
        // Configuration de marked
        marked.setOptions({
            breaks: true,
            gfm: true,
            headerIds: true,
            mangle: false
        });
        
        // Convertir et afficher
        document.getElementById('content').innerHTML = marked.parse(markdownContent);
        
        // Message pour l'impression
        window.onload = function() {
            console.log('✅ Document chargé. Utilisez Ctrl+P pour imprimer en PDF');
        };
    </script>
</body>
</html>
"@

# Sauvegarder le HTML
$htmlContent | Out-File -FilePath $htmlFile -Encoding UTF8

Write-Host "✅ HTML créé: $htmlFile" -ForegroundColor Green
Write-Host ""
Write-Host "📌 INSTRUCTIONS:" -ForegroundColor Yellow
Write-Host "   1. Le navigateur va s'ouvrir avec le document" -ForegroundColor White
Write-Host "   2. Appuyez sur Ctrl+P (ou Cmd+P sur Mac)" -ForegroundColor White
Write-Host "   3. Choisissez 'Microsoft Print to PDF' ou 'Save as PDF'" -ForegroundColor White
Write-Host "   4. Cliquez sur 'Enregistrer'" -ForegroundColor White
Write-Host "   5. Nommez le fichier: SCRIPT_PRESENTATION_PROFESSEUR.pdf" -ForegroundColor White
Write-Host ""
Write-Host "💡 Astuce: Activez 'Graphiques d'arrière-plan' dans les options d'impression" -ForegroundColor Cyan
Write-Host ""

# Ouvrir le HTML dans le navigateur par défaut
Start-Process $htmlFile

Write-Host "✅ Ouverture du navigateur..." -ForegroundColor Green
Write-Host ""
Write-Host "⏳ Attendez que la page se charge completement avant d'imprimer" -ForegroundColor Yellow
