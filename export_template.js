// Универсальная функция экспорта для всех листов
function exportToExcel(filename = 'export') {
    const data = [];
    const table = document.querySelector('table');
    const rows = table.querySelectorAll('tr');
    
    rows.forEach(row => {
        const rowData = [];
        row.querySelectorAll('th, td').forEach(cell => {
            const input = cell.querySelector('input');
            if (input) {
                rowData.push(input.value || '');
            } else {
                rowData.push(cell.textContent.trim());
            }
        });
        data.push(rowData);
    });
    
    const csvContent = data.map(row => row.join('\t')).join('\n');
    const blob = new Blob(['\ufeff' + csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    
    const branchNames = {
        'almaty': 'Алматы',
        'uralsk': 'Уральск',
        'astana': 'Астана',
        'consolidated': 'Консолидировано'
    };
    
    const branch = window.currentBranch || 'almaty';
    const fullFilename = `${filename}_${branchNames[branch]}_${new Date().toISOString().slice(0,10)}.csv`;
    
    link.setAttribute('href', url);
    link.setAttribute('download', fullFilename);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}
