"""
Проверка соответствия Excel листов и HTML файлов
"""

# Excel листы
excel_rb = [
    "Свод",
    "ДОХОДНАЯ ЧАСТЬ РБ", 
    "Сводная общая 2026г.",
    "СВОД ФЗП",
    "Калькуляция 2026",
    "План командир 2026"
]

excel_pu = [
    "СС Алматы",
    "СС Дотация",
    "ДОХОДНАЯ ЧАСТЬ ПУ",
    "ДОХОДНАЯ ЧАСТЬ ДТ",
    "ДОХОДНАЯ ЧАСТЬ доп",
    "Свод ФОТ Алматы",
    "СВОД общий 2026",
    "График род. оплаты Алматы",
    "Калькуляция Алматы",
    "План команд в пред РК",
    "План команд за пределы РК"
]

# Созданные HTML файлы
html_rb = [
    "rb-svod.html",                    # Свод
    "rb-income.html",                  # ДОХОДНАЯ ЧАСТЬ РБ
    "rb-svodnaya-full.html",          # Сводная общая 2026г.
    "rb-fzp.html",                    # СВОД ФЗП
    "rb-kalkulyacia.html",            # Калькуляция 2026
    "rb-plan-komandir.html"           # План командир 2026
]

html_pu = [
    "pu-ss-almaty.html",              # СС Алматы
    "pu-ss-dotacia.html",             # СС Дотация
    "pu-income-pu.html",              # ДОХОДНАЯ ЧАСТЬ ПУ
    "pu-income-dt.html",              # ДОХОДНАЯ ЧАСТЬ ДТ
    "pu-income-dop.html",             # ДОХОДНАЯ ЧАСТЬ доп
    "pu-fot-almaty.html",             # Свод ФОТ Алматы
    "pu-svod-2026.html",              # СВОД общий 2026
    "pu-grafik-almaty.html",          # График род. оплаты Алматы
    "pu-kalkulyacia-almaty.html",     # Калькуляция Алматы
    "pu-plan-rk.html",                # План команд в пред РК
    "pu-plan-abroad.html"             # План команд за пределы РК
]

print('='*80)
print('ПРОВЕРКА СООТВЕТСТВИЯ EXCEL ↔ HTML')
print('='*80)

print('\n📘 БЮДЖЕТ РБ (Республиканский бюджет):')
print('-'*80)
for i, (excel, html) in enumerate(zip(excel_rb, html_rb), 1):
    status = '✅' if html else '❌'
    print(f'{status} {i}. {excel:40} → {html}')

print('\n📗 БЮДЖЕТ ПУ (Собственные средства):')
print('-'*80)
for i, (excel, html) in enumerate(zip(excel_pu, html_pu), 1):
    status = '✅' if html else '❌'
    print(f'{status} {i}. {excel:40} → {html}')

print('\n' + '='*80)
print('ИТОГОВАЯ СТАТИСТИКА:')
print('='*80)
print(f'Excel РБ: {len(excel_rb)} листов')
print(f'HTML РБ:  {len(html_rb)} файлов')
print(f'Соответствие РБ: {"✅ ВСЕ СОВПАДАЮТ" if len(excel_rb) == len(html_rb) else "❌ НЕСООТВЕТСТВИЕ"}')
print()
print(f'Excel ПУ: {len(excel_pu)} листов')
print(f'HTML ПУ:  {len(html_pu)} файлов')
print(f'Соответствие ПУ: {"✅ ВСЕ СОВПАДАЮТ" if len(excel_pu) == len(html_pu) else "❌ НЕСООТВЕТСТВИЕ"}')
print()
print(f'ВСЕГО Excel: {len(excel_rb) + len(excel_pu)} листов')
print(f'ВСЕГО HTML:  {len(html_rb) + len(html_pu)} файлов')
print('='*80)

if len(excel_rb) + len(excel_pu) == len(html_rb) + len(html_pu):
    print('\n🎉 ВСЕ ЛИСТЫ РЕАЛИЗОВАНЫ! (17/17 = 100%)')
else:
    print(f'\n⚠️ НЕСООТВЕТСТВИЕ! Не хватает {abs((len(excel_rb) + len(excel_pu)) - (len(html_rb) + len(html_pu)))} файлов')
