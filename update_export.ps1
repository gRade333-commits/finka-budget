$files = @(
    "rb-income.html",
    "rb-fzp.html",
    "rb-kalkulyacia.html",
    "rb-svodnaya.html",
    "rb-plan-komandir.html",
    "pu-ss-almaty.html"
)

foreach ($file in $files) {
    Write-Host "Обновляю $file..." -ForegroundColor Cyan
    
    $content = Get-Content $file -Raw -Encoding UTF8
    
    # Добавляем SheetJS в head если его нет
    if ($content -notmatch 'xlsx.full.min.js') {
        $content = $content -replace '<title>', '<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>`n    <title>'
    }
    
    # Обновляем функцию exportToExcel на новую версию
    $oldFunc = 'function exportToExcel\(\) \{[^}]+const csvContent[^}]+document\.body\.removeChild\(link\);[\s\S]+?\}'
    
    $newFunc = @'
function exportToExcel() {
            const data = [];
            const table = document.querySelector('table');
            const rows = table.querySelectorAll('tr');
            
            rows.forEach(row => {
                const rowData = [];
                row.querySelectorAll('th, td').forEach(cell => {
                    const input = cell.querySelector('input');
                    if (input) {
                        const val = parseFloat(input.value) || 0;
                        rowData.push(val);
                    } else {
                        rowData.push(cell.textContent.trim());
                    }
                });
                data.push(rowData);
            });
            
            const wb = XLSX.utils.book_new();
            const ws = XLSX.utils.aoa_to_sheet(data);
            
            const colWidths = [];
            data.forEach(row => {
                row.forEach((cell, i) => {
                    const cellLen = String(cell).length;
                    if (!colWidths[i] || colWidths[i] < cellLen) {
                        colWidths[i] = cellLen;
                    }
                });
            });
            ws['!cols'] = colWidths.map(w => ({ wch: Math.min(w + 2, 50) }));
            
            XLSX.utils.book_append_sheet(wb, ws, "Данные");
            
            const branchNames = {'almaty': 'Алматы', 'uralsk': 'Уральск', 'astana': 'Астана', 'consolidated': 'Консолидировано'};
            const branch = window.currentBranch || 'almaty';
            const filename = `Export_${branchNames[branch]}_${new Date().toISOString().slice(0,10)}.xlsx`;
            
            XLSX.writeFile(wb, filename);
        }
'@
    
    $content = $content -replace $oldFunc, $newFunc
    
    Set-Content $file -Value $content -Encoding UTF8 -NoNewline
    Write-Host "  ✅ $file обновлен" -ForegroundColor Green
}

Write-Host "`n✅ Все файлы обновлены! Теперь экспорт в .xlsx" -ForegroundColor Green
