# Script to add mobile styles to remaining HTML files
# Encoding: UTF-8 with BOM

$mobileStyles = @'

        /* Mobile adaptation - Tablets */
        @media (max-width: 1200px) {
            .container {
                max-width: 100%;
            }
            
            .table-container {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
            }
        }

        /* Mobile adaptation - Medium screens */
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }

            .header, .container {
                padding: 15px 20px;
                margin-bottom: 15px;
            }

            h1 {
                font-size: 20px;
                margin-bottom: 8px;
            }

            h2 {
                font-size: 16px;
            }

            .subtitle {
                font-size: 12px;
            }

            .branch-selector, .btn-group, .controls {
                gap: 8px;
                margin-top: 10px;
            }

            .btn, button, .branch-btn {
                padding: 10px 16px;
                font-size: 12px;
            }

            .info-bar, .status-bar {
                padding: 12px 15px;
                gap: 10px;
            }
            
            table {
                font-size: 11px;
            }

            th, td {
                padding: 6px 4px;
            }

            .section-footer {
                padding: 12px;
                gap: 8px;
            }

            input, select, textarea {
                padding: 6px;
                font-size: 12px;
            }
        }

        /* Mobile adaptation - Small screens */
        @media (max-width: 480px) {
            body {
                padding: 5px;
            }

            .header, .container {
                padding: 12px 15px;
                border-radius: 10px;
            }

            h1 {
                font-size: 18px;
            }

            h2 {
                font-size: 14px;
            }

            .subtitle {
                font-size: 11px;
                margin-bottom: 10px;
            }

            .branch-selector, .btn-group, .controls {
                flex-direction: column;
                gap: 6px;
            }

            .btn, button, .branch-btn {
                width: 100%;
                padding: 10px;
                font-size: 13px;
            }

            .info-bar, .status-bar {
                flex-direction: column;
                padding: 10px;
                gap: 8px;
            }

            table {
                font-size: 10px;
            }

            th, td {
                padding: 4px 2px;
            }

            .section-footer {
                flex-direction: column;
                padding: 10px;
            }

            input, select, textarea {
                font-size: 11px;
                padding: 5px;
            }
        }
'@

function Add-MobileStyles {
    param(
        [string]$FilePath
    )
    
    $content = Get-Content $FilePath -Raw -Encoding UTF8
    
    # Check if mobile styles already exist
    if ($content -match "Mobile adaptation") {
        Write-Host "Skip $FilePath - already has mobile styles" -ForegroundColor Yellow
        return
    }
    
    # Find closing </style> tag
    if ($content -match '</style>') {
        # Insert mobile styles before </style>
        $newContent = $content -replace '</style>', "$mobileStyles`n    </style>"
        
        # Save file
        $newContent | Out-File -FilePath $FilePath -Encoding UTF8 -NoNewline
        Write-Host "Updated: $FilePath" -ForegroundColor Green
    } else {
        Write-Host "Skipped: $FilePath (no </style> tag found)" -ForegroundColor Red
    }
}

# Get remaining HTML files (exclude rb- and pu- files, index.html)
$files = Get-ChildItem -Filter "*.html" | Where-Object { 
    $_.Name -notmatch '^(rb-|pu-)' -and 
    $_.Name -ne 'index.html' -and
    $_.Name -ne 'business-process.html'
}

Write-Host "`nAdding mobile styles to remaining HTML files:`n" -ForegroundColor Cyan

foreach ($file in $files) {
    Add-MobileStyles -FilePath $file.FullName
}

Write-Host "`nProcessing completed!" -ForegroundColor Green
Write-Host "Files processed: $($files.Count)" -ForegroundColor Cyan
