# Скрипт для массового добавления editable-table.js во все HTML файлы
# Версия: 1.0
# Дата: 27.12.2025

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  Массовое обновление HTML файлов" -ForegroundColor Cyan
Write-Host "  Добавление редактируемых таблиц" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Список файлов для обновления
$files = @(
    # РБ файлы
    "rb-svod.html",
    "rb-income.html",
    "rb-kalkulyacia.html",
    "rb-plan-komandir.html",
    
    # ПУ файлы
    "pu-svod-2026.html",
    "pu-ss-almaty.html",
    "pu-ss-dotacia.html",
    "pu-income-pu.html",
    "pu-income-dt.html",
    "pu-income-dop.html",
    "pu-fot-almaty.html",
    "pu-grafik-almaty.html",
    "pu-kalkulyacia-almaty.html",
    "pu-plan-rk.html",
    "pu-plan-abroad.html"
)

$scriptTag = '<script src="editable-table.js"></script>'
$updatedCount = 0
$skippedCount = 0
$errorCount = 0

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Обработка: $file" -ForegroundColor Yellow
        
        try {
            # Читаем содержимое файла
            $content = Get-Content $file -Raw -Encoding UTF8
            
            # Проверяем, не добавлен ли уже скрипт
            if ($content -match 'editable-table\.js') {
                Write-Host "  [ПРОПУЩЕН] Скрипт уже подключен" -ForegroundColor Gray
                $skippedCount++
                continue
            }
            
            # Ищем место для вставки (после других скриптов или перед </head>)
            if ($content -match '(<script[^>]*xlsx[^>]*></script>)') {
                # Вставляем после XLSX скрипта
                $content = $content -replace '(<script[^>]*xlsx[^>]*></script>)', "`$1`n    $scriptTag"
                Write-Host "  [OK] Вставлено после XLSX" -ForegroundColor Green
            }
            elseif ($content -match '</head>') {
                # Вставляем перед закрывающим тегом </head>
                $content = $content -replace '</head>', "    $scriptTag`n</head>"
                Write-Host "  [OK] Вставлено перед </head>" -ForegroundColor Green
            }
            else {
                Write-Host "  [ОШИБКА] Не найдено место для вставки" -ForegroundColor Red
                $errorCount++
                continue
            }
            
            # Добавляем инициализацию в конец DOMContentLoaded или создаем новый обработчик
            if ($content -match "document\.addEventListener\('DOMContentLoaded'") {
                # Есть DOMContentLoaded, добавляем в конец функции
                $initCode = @"
            
            // Инициализация редактируемых таблиц
            setTimeout(() => {
                if (typeof initAllEditableTables === 'function') {
                    initAllEditableTables('table', typeof handleInput === 'function' ? handleInput : null);
                    console.log('✅ Редактируемые таблицы инициализированы');
                }
            }, 100);
"@
                # Ищем последнюю закрывающую скобку в DOMContentLoaded
                $pattern = "(document\.addEventListener\('DOMContentLoaded'[^}]+)(\}\);)"
                if ($content -match $pattern) {
                    $content = $content -replace $pattern, "`$1$initCode`n        `$2"
                    Write-Host "  [OK] Добавлена инициализация в DOMContentLoaded" -ForegroundColor Green
                }
            }
            else {
                # Нет DOMContentLoaded, создаем новый
                $newEventListener = @"
    <script>
        // Инициализация редактируемых таблиц
        document.addEventListener('DOMContentLoaded', () => {
            setTimeout(() => {
                if (typeof initAllEditableTables === 'function') {
                    initAllEditableTables('table');
                    console.log('✅ Редактируемые таблицы инициализированы');
                }
            }, 100);
        });
    </script>
"@
                $content = $content -replace '</body>', "$newEventListener`n</body>"
                Write-Host "  [OK] Создан новый DOMContentLoaded" -ForegroundColor Green
            }
            
            # Сохраняем изменения
            $content | Set-Content $file -Encoding UTF8 -NoNewline
            $updatedCount++
            Write-Host "  [ГОТОВО] Файл обновлен" -ForegroundColor Green
            
        }
        catch {
            Write-Host "  [ОШИБКА] $($_.Exception.Message)" -ForegroundColor Red
            $errorCount++
        }
    }
    else {
        Write-Host "Файл не найден: $file" -ForegroundColor Red
        $errorCount++
    }
    
    Write-Host ""
}

# Итоговый отчет
Write-Host "================================" -ForegroundColor Cyan
Write-Host "        ИТОГОВЫЙ ОТЧЕТ" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Обработано файлов: $($files.Count)" -ForegroundColor White
Write-Host "✅ Обновлено: $updatedCount" -ForegroundColor Green
Write-Host "⏭️  Пропущено: $skippedCount" -ForegroundColor Gray
Write-Host "❌ Ошибок: $errorCount" -ForegroundColor Red
Write-Host ""

if ($updatedCount -gt 0) {
    Write-Host "🎉 Обновление завершено успешно!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Следующие шаги:" -ForegroundColor Yellow
    Write-Host "1. Откройте любой обновленный файл в браузере" -ForegroundColor White
    Write-Host "2. Проверьте функциональность редактирования ячеек" -ForegroundColor White
    Write-Host "3. Попробуйте добавить и удалить строки" -ForegroundColor White
    Write-Host "4. Проверьте консоль (F12) на наличие ошибок" -ForegroundColor White
}
else {
    Write-Host "⚠️ Ни один файл не был обновлен" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Нажмите любую клавишу для выхода..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
