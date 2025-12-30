# Universal script for adding mobile adaptation to all HTML files
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

            .header {
                padding: 15px 20px;
                margin-bottom: 15px;
            }

            .header h1 {
                font-size: 20px;
                margin-bottom: 8px;
            }

            .header .subtitle {
                font-size: 12px;
            }

            .branch-selector {
                gap: 8px;
                margin-top: 10px;
            }

            .branch-btn {
                padding: 10px 16px;
                font-size: 12px;
            }

            .info-bar {
                padding: 12px 15px;
                gap: 10px;
            }

            .auto-save-status {
                padding: 6px 14px;
                font-size: 11px;
            }

            .import-notice {
                padding: 10px 15px;
                font-size: 11px;
            }

            .sections-nav {
                padding: 15px;
                margin-bottom: 15px;
            }

            .section-header h2 {
                font-size: 16px;
            }
            
            table {
                font-size: 11px;
            }

            th, td {
                padding: 6px 4px;
            }

            .btn-add-row {
                padding: 8px 16px;
                font-size: 12px;
            }

            .section-footer {
                padding: 12px;
                gap: 8px;
            }

            .editable-cell {
                padding: 6px;
                font-size: 12px;
            }

            .row-actions {
                gap: 3px;
                margin-left: 5px;
            }

            .btn-delete-row {
                padding: 2px 6px;
                font-size: 10px;
            }
        }

        /* Mobile adaptation - Small screens */
        @media (max-width: 480px) {
            body {
                padding: 5px;
            }

            .header {
                padding: 12px 15px;
                border-radius: 10px;
            }

            .header h1 {
                font-size: 18px;
            }

            .header .subtitle {
                font-size: 11px;
                margin-bottom: 10px;
            }

            .branch-selector {
                flex-direction: column;
                gap: 6px;
            }

            .branch-btn {
                width: 100%;
                padding: 10px;
                font-size: 13px;
            }

            .info-bar {
                flex-direction: column;
                padding: 10px;
                gap: 8px;
            }

            .sections-nav {
                padding: 10px;
            }

            .section-header {
                padding: 10px;
            }

            .section-header h2 {
                font-size: 14px;
            }

            table {
                font-size: 10px;
            }

            th, td {
                padding: 4px 2px;
            }

            .label-cell {
                min-width: 120px;
            }

            .btn-add-row {
                width: 100%;
                padding: 10px;
                font-size: 13px;
            }

            .section-footer {
                flex-direction: column;
                padding: 10px;
            }

            .editable-cell {
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

# Get all HTML files
$files = Get-ChildItem -Filter "*.html" | Where-Object { 
    $_.Name -match '^(rb-|pu-)' -and $_.Name -ne 'rb-svodnaya.html'
}

Write-Host "`nAdding mobile styles to files:`n" -ForegroundColor Cyan

foreach ($file in $files) {
    Add-MobileStyles -FilePath $file.FullName
}

Write-Host "`nProcessing completed!" -ForegroundColor Green
Write-Host "Files processed: $($files.Count)" -ForegroundColor Cyan

