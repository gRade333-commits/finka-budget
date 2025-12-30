/**
 * Универсальный модуль для редактируемых таблиц
 * Версия: 1.0
 * Дата: 27.12.2025
 */

// Глобальные стили для редактируемых таблиц
const EDITABLE_TABLE_STYLES = `
    .editable-cell {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 3px;
        font-size: 13px;
        transition: all 0.2s;
        background: white;
    }
    
    .editable-cell:focus {
        outline: 2px solid #3498db;
        background: #f0f9ff;
        border-color: #3498db;
    }
    
    .btn-delete-row {
        padding: 4px 10px;
        background: #e74c3c;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 11px;
        transition: all 0.2s;
        white-space: nowrap;
    }
    
    .btn-delete-row:hover {
        background: #c0392b;
        transform: scale(1.05);
    }
    
    .btn-add-row {
        padding: 10px 20px;
        background: linear-gradient(135deg, #27ae60, #229954);
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: 600;
        font-size: 14px;
        transition: all 0.3s;
        box-shadow: 0 2px 8px rgba(39, 174, 96, 0.3);
        margin: 15px 0;
    }
    
    .btn-add-row:hover {
        background: linear-gradient(135deg, #229954, #1e8449);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(39, 174, 96, 0.4);
    }
    
    .table-footer {
        padding: 15px;
        text-align: center;
        background: #f8f9fa;
        border-top: 2px solid #e0e0e0;
    }
`;

/**
 * Инициализация стилей редактируемых таблиц
 */
function initEditableTableStyles() {
    if (!document.getElementById('editable-table-styles')) {
        const styleSheet = document.createElement('style');
        styleSheet.id = 'editable-table-styles';
        styleSheet.textContent = EDITABLE_TABLE_STYLES;
        document.head.appendChild(styleSheet);
    }
}

/**
 * Делает все ячейки таблицы редактируемыми
 * @param {HTMLTableElement} table - Таблица для обработки
 * @param {string} tableId - Уникальный идентификатор таблицы
 * @param {function} onInputCallback - Callback при изменении данных
 */
function makeTableEditable(table, tableId = 'table', onInputCallback = null) {
    if (!table) return;
    
    const rows = table.querySelectorAll('tr');
    
    rows.forEach((row, rowIndex) => {
        // Проверяем, является ли строка заголовком
        const isHeader = rowIndex === 0 || row.querySelector('th') !== null;
        
        if (isHeader) {
            // Добавляем столбец "Действия" в заголовок
            const hasActionColumn = Array.from(row.cells).some(cell => 
                cell.textContent.trim() === 'Действия'
            );
            
            if (!hasActionColumn) {
                const th = document.createElement('th');
                th.textContent = 'Действия';
                th.style.width = '80px';
                th.style.textAlign = 'center';
                row.appendChild(th);
            }
        } else {
            // Обрабатываем обычные строки
            const cells = row.querySelectorAll('td');
            
            // Проверяем, является ли это строкой итогов
            const rowText = row.textContent.trim().toLowerCase();
            const isTotalRow = /итого|всего|total/i.test(rowText);
            
            if (isTotalRow) {
                // Строки с итогами не делаем редактируемыми, добавляем визуальное выделение
                row.style.backgroundColor = '#f0f0f0';
                row.style.fontWeight = 'bold';
                row.title = 'Итоговая строка не редактируется';
                return; // Пропускаем эту строку
            }
            
            cells.forEach((cell, colIndex) => {
                // Пропускаем уже редактируемые ячейки
                if (cell.querySelector('input')) return;
                
                const cellValue = cell.textContent.trim();
                const cellId = `${tableId}_row${rowIndex}_col${colIndex}`;
                
                // Заменяем содержимое на input
                cell.innerHTML = `<input 
                    type="text" 
                    class="editable-cell" 
                    id="${cellId}" 
                    value="${cellValue}" 
                    oninput="${onInputCallback ? `${onInputCallback.name}('${cellId}')` : ''}" 
                    placeholder="${colIndex === 0 ? '№' : colIndex === 1 ? 'Наименование' : '-'}">`;
            });
            
            // Добавляем кнопку удаления, если её ещё нет
            const hasDeleteBtn = row.querySelector('.btn-delete-row');
            if (!hasDeleteBtn) {
                const actionCell = document.createElement('td');
                actionCell.style.width = '80px';
                actionCell.style.textAlign = 'center';
                actionCell.innerHTML = `<button 
                    class="btn-delete-row" 
                    onclick="deleteTableRow('${row.id || 'row_' + rowIndex}', '${tableId}')" 
                    title="Удалить строку">🗑️</button>`;
                row.appendChild(actionCell);
                
                // Устанавливаем ID строки, если его нет
                if (!row.id) {
                    row.id = `${tableId}_row_${rowIndex}`;
                }
            }
        }
    });
    
    console.log(`✅ Таблица ${tableId} стала полностью редактируемой`);
}

/**
 * Добавляет новую строку в таблицу
 * @param {string} tableId - ID таблицы
 * @param {function} onInputCallback - Callback при изменении данных
 */
function addTableRow(tableId, onInputCallback = null) {
    const table = document.getElementById(tableId) || document.querySelector(`[data-table-id="${tableId}"]`);
    if (!table) {
        console.error(`Таблица ${tableId} не найдена`);
        return;
    }
    
    const tbody = table.querySelector('tbody') || table;
    const rows = tbody.querySelectorAll('tr');
    
    if (rows.length === 0) {
        console.error('Нет строк в таблице для копирования структуры');
        return;
    }
    
    // Ищем первую строку с итогами
    let insertBeforeRow = null;
    let referenceRow = null;
    
    rows.forEach(row => {
        const rowText = row.textContent.trim().toLowerCase();
        const isTotal = /итого|всего|total/i.test(rowText);
        
        // Находим строку с итогами для вставки перед ней
        if (!insertBeforeRow && isTotal) {
            insertBeforeRow = row;
        }
        
        // Находим обычную строку (не итоговую) для копирования структуры
        if (!referenceRow && !isTotal) {
            const cells = row.querySelectorAll('th, td');
            // Пропускаем заголовочные строки (где все ячейки - th)
            const hasDataCells = Array.from(cells).some(cell => cell.tagName === 'TD');
            if (hasDataCells) {
                referenceRow = row;
            }
        }
    });
    
    // Если не нашли обычную строку, используем первую строку
    if (!referenceRow) {
        referenceRow = rows[0];
    }
    
    const newRowIndex = insertBeforeRow ? 
        Array.from(rows).indexOf(insertBeforeRow) : 
        rows.length;
    const rowId = `${tableId}_row_${Date.now()}`; // Используем timestamp для уникальности
    
    // Создаем новую строку, копируя структуру референсной строки
    const newRow = document.createElement('tr');
    newRow.id = rowId;
    
    // Копируем все атрибуты строки (кроме id)
    Array.from(referenceRow.attributes).forEach(attr => {
        if (attr.name !== 'id') {
            newRow.setAttribute(attr.name, attr.value);
        }
    });
    
    // Копируем ячейки из референсной строки
    const referenceCells = referenceRow.querySelectorAll('td');
    referenceCells.forEach((refCell, i) => {
        const td = document.createElement('td');
        
        // Копируем все атрибуты ячейки (style, class, colspan, rowspan и т.д.)
        Array.from(refCell.attributes).forEach(attr => {
            td.setAttribute(attr.name, attr.value);
        });
        
        // Проверяем, есть ли в ячейке input
        const refInput = refCell.querySelector('input');
        if (refInput) {
            // Копируем input с его атрибутами
            const cellId = `${tableId}_row${newRowIndex}_col${i}`;
            const newInput = document.createElement('input');
            
            Array.from(refInput.attributes).forEach(attr => {
                if (attr.name === 'id') {
                    newInput.setAttribute('id', cellId);
                } else if (attr.name === 'value') {
                    newInput.setAttribute('value', ''); // Очищаем значение
                } else if (attr.name === 'oninput' && onInputCallback) {
                    newInput.setAttribute('oninput', `${onInputCallback.name}('${cellId}')`);
                } else {
                    newInput.setAttribute(attr.name, attr.value);
                }
            });
            
            // Если не было id, добавляем
            if (!refInput.hasAttribute('id')) {
                newInput.setAttribute('id', cellId);
            }
            
            // Если не было класса editable-cell, добавляем
            if (!newInput.classList.contains('editable-cell')) {
                newInput.classList.add('editable-cell');
            }
            
            td.appendChild(newInput);
        } else {
            // Если в референсной ячейке нет input, создаём его
            const cellId = `${tableId}_row${newRowIndex}_col${i}`;
            td.innerHTML = `<input 
                type="text" 
                class="editable-cell" 
                id="${cellId}" 
                value="" 
                ${onInputCallback ? `oninput="${onInputCallback.name}('${cellId}')"` : ''}>`;
        }
        
        newRow.appendChild(td);
    });
    
    // Добавляем кнопку удаления в последнюю ячейку
    const actionCell = document.createElement('td');
    actionCell.style.width = '80px';
    actionCell.style.textAlign = 'center';
    actionCell.innerHTML = `<button 
        class="btn-delete-row" 
        onclick="deleteTableRow('${rowId}', '${tableId}')" 
        title="Удалить строку">🗑️</button>`;
    newRow.appendChild(actionCell);
    
    // Вставляем строку перед итоговой строкой или в конец
    if (insertBeforeRow) {
        tbody.insertBefore(newRow, insertBeforeRow);
        console.log(`➕ Добавлена новая строка перед итоговой строкой в таблицу ${tableId}`);
    } else {
        tbody.appendChild(newRow);
        console.log(`➕ Добавлена новая строка в конец таблицы ${tableId}`);
    }
    
    // Фокусируемся на первой ячейке
    const firstInput = newRow.querySelector('input');
    if (firstInput) {
        firstInput.focus();
    }
}

/**
 * Удаляет строку из таблицы
 * @param {string} rowId - ID строки для удаления
 * @param {string} tableId - ID таблицы
 */
function deleteTableRow(rowId, tableId) {
    if (!confirm('Удалить эту строку?')) return;
    
    const row = document.getElementById(rowId);
    if (!row) {
        console.error(`Строка ${rowId} не найдена`);
        return;
    }
    
    // Удаляем данные из localStorage
    const inputs = row.querySelectorAll('input');
    inputs.forEach(input => {
        if (input.id && localStorage.getItem(input.id)) {
            localStorage.removeItem(input.id);
        }
    });
    
    row.remove();
    console.log(`🗑️ Удалена строка ${rowId} из таблицы ${tableId}`);
    
    // Вызываем сохранение, если функция доступна
    if (typeof saveData === 'function') {
        saveData();
    }
}

/**
 * Добавляет кнопку "Добавить строку" после таблицы
 * @param {HTMLTableElement} table - Таблица
 * @param {string} tableId - ID таблицы
 * @param {function} onInputCallback - Callback при изменении данных
 */
function addAddRowButton(table, tableId, onInputCallback = null) {
    if (!table) return;
    
    // Проверяем, есть ли уже кнопка
    let footer = table.nextElementSibling;
    if (footer && footer.classList.contains('table-footer')) {
        return; // Кнопка уже есть
    }
    
    // Создаем футер с кнопкой
    footer = document.createElement('div');
    footer.className = 'table-footer';
    footer.innerHTML = `<button 
        class="btn-add-row" 
        onclick="addTableRow('${tableId}', ${onInputCallback ? onInputCallback.name : 'null'})">
        ➕ Добавить новую строку
    </button>`;
    
    // Вставляем после таблицы
    table.parentNode.insertBefore(footer, table.nextSibling);
}

/**
 * Инициализация всех таблиц на странице как редактируемых
 * @param {string} selector - CSS селектор для поиска таблиц
 * @param {function} onInputCallback - Callback при изменении данных
 */
function initAllEditableTables(selector = 'table', onInputCallback = null) {
    initEditableTableStyles();
    
    const tables = document.querySelectorAll(selector);
    tables.forEach((table, index) => {
        const tableId = table.id || `table_${index}`;
        if (!table.id) {
            table.id = tableId;
        }
        
        makeTableEditable(table, tableId, onInputCallback);
        addAddRowButton(table, tableId, onInputCallback);
    });
    
    console.log(`✅ Инициализировано ${tables.length} редактируемых таблиц`);
}

// Экспортируем функции для использования в других скриптах
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        initEditableTableStyles,
        makeTableEditable,
        addTableRow,
        deleteTableRow,
        addAddRowButton,
        initAllEditableTables
    };
}
