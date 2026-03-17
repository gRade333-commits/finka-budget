# Скрипт для обновления всех ПУ файлов - замена select на кнопки

$files = @(
    'pu-income-pu.html',
    'pu-income-dt.html',
    'pu-income-dop.html',
    'pu-fot-almaty.html',
    'pu-grafik-almaty.html',
    'pu-kalkulyacia-almaty.html',
    'pu-plan-rk.html',
    'pu-plan-abroad.html',
    'pu-ss-almaty.html'
)

$cssToAdd = @'
        
        .branch-selector {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .branch-btn {
            padding: 10px 20px;
            border: 2px solid #e67e22;
            background: white;
            color: #e67e22;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s;
        }
        
        .branch-btn.active {
            background: #e67e22;
            color: white;
        }
        
        .branch-btn:hover {
            background: #f39c12;
            border-color: #f39c12;
            color: white;
        }
'@

$oldHtmlPattern = @'
            <div class="control-group">
                <label>Филиал:</label>
                <select id="branchSelect" onchange="switchBranch()">
                    <option value="almaty">Алматы</option>
                    <option value="uralsk">Уральск</option>
                    <option value="astana">Астана</option>
                    <option value="consolidated">Консолидировано</option>
                </select>
            </div>
'@

$newHtmlPattern = @'
            <div class="branch-selector">
                <button class="branch-btn active" onclick="switchBranch('almaty')">Алматы</button>
                <button class="branch-btn" onclick="switchBranch('uralsk')">Уральск</button>
                <button class="branch-btn" onclick="switchBranch('astana')">Астана</button>
                <button class="branch-btn" onclick="switchBranch('consolidated')">Консолидировано</button>
            </div>
'@

$oldJsPattern1 = @'
        function switchBranch() {
            const select = document.getElementById('branchSelect');
            currentBranch = select.value;
            if (currentBranch === 'consolidated') {
                loadConsolidatedData();
            } else {
                loadData();
            }
        }
'@

$newJsPattern1 = @'
        function switchBranch(newBranch) {
            if (currentBranch !== 'consolidated' && currentBranch !== newBranch) {
                saveData();
            }
            currentBranch = newBranch;
            document.querySelectorAll('.branch-btn').forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            if (currentBranch === 'consolidated') {
                loadConsolidatedData();
            } else {
                loadData();
            }
        }
'@

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Processing $file..."
        
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # Add CSS for buttons before .control-group
        if ($content -match '\.control-group') {
            $content = $content -replace '(\.control-group)', "$cssToAdd`r`n`r`n        `$1"
        }
        
        # Replace HTML select with buttons
        $content = $content -replace [regex]::Escape($oldHtmlPattern), $newHtmlPattern
        
        # Replace switchBranch function
        $content = $content -replace [regex]::Escape($oldJsPattern1), $newJsPattern1
        
        # Save
        $content | Set-Content $file -Encoding UTF8 -NoNewline
        
        Write-Host "OK: $file updated"
    } else {
        Write-Host "ERROR: $file not found"
    }
}

Write-Host "Done! Updated files: $($files.Count)"
