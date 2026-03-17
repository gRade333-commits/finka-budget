# Скрипт для добавления детализации консолидации во все файлы
# Дата: 30.12.2025

$files = @(
    "rb-fzp.html",
    "rb-income.html", 
    "rb-kalkulyacia.html",
    "rb-plan-komandir.html",
    "rb-svodnaya.html",
    "pu-svod-2026.html",
    "pu-income-pu.html",
    "pu-income-dt.html",
    "pu-income-dop.html",
    "pu-fot-almaty.html",
    "pu-grafik-almaty.html",
    "pu-kalkulyacia-almaty.html",
    "pu-plan-rk.html",
    "pu-plan-abroad.html",
    "pu-ss-dotacia.html",
    "pu-ss-almaty.html"
)

$cssToAdd = @'
        .detail-row {
            background: #f8f9fa;
            display: none;
        }

        .detail-row.show {
            display: table-row;
        }

        .detail-cell {
            padding: 8px 8px 8px 40px;
            font-size: 13px;
            color: #6c757d;
            border-left: 3px solid #3498db;
        }

        .toggle-detail {
            cursor: pointer;
            user-select: none;
            display: inline-block;
            width: 20px;
            text-align: center;
            margin-right: 5px;
            font-weight: bold;
            color: #3498db;
            transition: transform 0.2s;
        }

        .toggle-detail.expanded {
            transform: rotate(90deg);
        }

        .label-cell.expandable {
            cursor: pointer;
        }

        .label-cell.expandable:hover {
            background: #e9ecef;
        }
'@

$functionsToAdd = @'

        function addDetailToggles() {
            // Удаляем существующие детальные строки и иконки
            document.querySelectorAll('.detail-row').forEach(row => row.remove());
            document.querySelectorAll('.toggle-detail').forEach(toggle => toggle.remove());
            document.querySelectorAll('.expandable').forEach(cell => cell.classList.remove('expandable'));
            
            const dataRows = document.querySelectorAll('tbody tr');
            const branches = ['almaty', 'uralsk', 'astana'];
            const branchNames = {
                'almaty': 'Алматы',
                'uralsk': 'Уральск',
                'astana': 'Астана'
            };
            
            let processedCount = 0;
            
            dataRows.forEach((row, index) => {
                const labelCell = row.querySelector('td.label-cell:nth-child(2)') || row.querySelector('td:nth-child(2)');
                const firstInput = row.querySelector('input[data-cell]');
                
                const isTotalRow = row.classList.contains('total-row') || 
                                   row.textContent.includes('Итого') ||
                                   row.textContent.includes('ИТОГО');
                
                if (labelCell && firstInput && !isTotalRow) {
                    const rowNum = firstInput.dataset.row || index;
                    
                    labelCell.classList.add('expandable');
                    const toggle = document.createElement('span');
                    toggle.className = 'toggle-detail';
                    toggle.textContent = '▶';
                    toggle.dataset.row = rowNum;
                    
                    labelCell.insertBefore(toggle, labelCell.firstChild);
                    
                    const detailRow = document.createElement('tr');
                    detailRow.className = 'detail-row';
                    detailRow.dataset.row = rowNum;
                    
                    const emptyCell = document.createElement('td');
                    emptyCell.style.background = '#f8f9fa';
                    detailRow.appendChild(emptyCell);
                    
                    const branchListCell = document.createElement('td');
                    branchListCell.className = 'detail-cell';
                    branchListCell.style.verticalAlign = 'top';
                    
                    let branchList = '<div style="padding: 5px 0;">';
                    branches.forEach(b => {
                        branchList += `<div style="margin: 5px 0; line-height: 22px;"><strong style="color: #3498db;">${branchNames[b]}:</strong></div>`;
                    });
                    branchList += '</div>';
                    branchListCell.innerHTML = branchList;
                    detailRow.appendChild(branchListCell);
                    
                    const inputs = row.querySelectorAll('input[data-cell]');
                    inputs.forEach(input => {
                        const yearCell = document.createElement('td');
                        yearCell.className = 'detail-cell';
                        yearCell.style.verticalAlign = 'top';
                        yearCell.style.textAlign = 'right';
                        
                        let yearData = '<div style="padding: 5px 0;">';
                        branches.forEach(b => {
                            const cellId = input.dataset.cell;
                            const value = window.branchDetailsData && window.branchDetailsData[b] && window.branchDetailsData[b][cellId] 
                                ? parseFloat(window.branchDetailsData[b][cellId]) 
                                : 0;
                            yearData += `<div style="margin: 5px 0; line-height: 22px; color: #555;">${value.toLocaleString('ru-RU', {minimumFractionDigits: 2, maximumFractionDigits: 2})}</div>`;
                        });
                        yearData += '</div>';
                        yearCell.innerHTML = yearData;
                        detailRow.appendChild(yearCell);
                    });
                    
                    row.parentNode.insertBefore(detailRow, row.nextSibling);
                    
                    labelCell.addEventListener('click', function(e) {
                        const toggle = this.querySelector('.toggle-detail');
                        const detailRow = this.parentElement.nextElementSibling;
                        
                        if (detailRow && detailRow.classList.contains('detail-row')) {
                            detailRow.classList.toggle('show');
                            toggle.classList.toggle('expanded');
                        }
                    });
                    
                    processedCount++;
                }
            });
            
            console.log(`✅ Добавлено ${processedCount} раскрывающихся блоков с детализацией`);
        }

        function removeDetailToggles() {
            document.querySelectorAll('.toggle-detail').forEach(el => el.remove());
            document.querySelectorAll('.detail-row').forEach(row => row.remove());
            document.querySelectorAll('.expandable').forEach(cell => {
                cell.classList.remove('expandable');
            });
        }
'@

Write-Host "Начинаем добавление детализации консолидации..." -ForegroundColor Cyan
$count = 0

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "`nОбработка $file..." -ForegroundColor Yellow
        
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # Проверяем, есть ли уже детализация
        if ($content -match 'addDetailToggles') {
            Write-Host "  ⏭️  Пропуск - детализация уже добавлена" -ForegroundColor Gray
            continue
        }
        
        # Добавляем CSS стили перед </style>
        if ($content -match '</style>') {
            $content = $content -replace '(\s*)</style>', "$cssToAdd`n`$1</style>"
            Write-Host "  ✅ CSS стили добавлены" -ForegroundColor Green
        }
        
        # Находим функцию loadConsolidatedData и добавляем window.branchDetailsData
        if ($content -match 'function loadConsolidatedData\(\)') {
            $content = $content -replace '(const allData = \{\};)', "`$1`n`n            // Сохраняем данные для детализации`n            window.branchDetailsData = {};"
            $content = $content -replace '(allData\[b\] = data\.cells)', "`$1;`n                window.branchDetailsData[b] = data.cells"
            
            # Добавляем вызов addDetailToggles()
            $content = $content -replace '(calculateTotals\(\);[^\n]*\n[^\n]*// Показываем информацию)', "addDetailToggles();`n            `n            `$1"
            
            Write-Host "  ✅ loadConsolidatedData обновлена" -ForegroundColor Green
        }
        
        # Обновляем switchBranch для удаления деталей
        if ($content -match 'function switchBranch\(') {
            $content = $content -replace '(currentBranch = branch;)', "// Удаляем детали при переключении с консолидации`n            if (currentBranch === 'consolidated' && branch !== 'consolidated') {`n                removeDetailToggles();`n            }`n            `n            `$1"
            
            # Добавляем disable input в режиме консолидации
            if ($content -notmatch 'input\.disabled = true') {
                $content = $content -replace "(if \(branch === 'consolidated'\) \{)", "`$1`n                document.querySelectorAll('input').forEach(input => {`n                    input.disabled = true;`n                });"
                $content = $content -replace '(\} else \{[^\n]*\n[^\n]*loadData)', "} else {`n                document.querySelectorAll('input').forEach(input => {`n                    input.disabled = false;`n                });`n                loadData"
            }
            
            Write-Host "  ✅ switchBranch обновлена" -ForegroundColor Green
        }
        
        # Добавляем функции перед последним </script>
        $content = $content -replace '(\s*)(</script>\s*</body>)', "$functionsToAdd`n`$1`$2"
        
        # Сохраняем файл
        Set-Content -Path $file -Value $content -Encoding UTF8
        Write-Host "  💾 Файл сохранён" -ForegroundColor Green
        $count++
    } else {
        Write-Host "  ⚠️  Файл $file не найден" -ForegroundColor Red
    }
}

Write-Host "`n✅ Обработано файлов: $count" -ForegroundColor Cyan
Write-Host "Готово! Детализация консолидации добавлена." -ForegroundColor Green
