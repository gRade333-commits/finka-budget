import pandas as pd

# Проверяем листы в обоих Excel файлах
rb = pd.ExcelFile('Бюджет РБ 2026 (1).xlsx')
pu = pd.ExcelFile('Бюджет ПУ 2026 (1).xlsx')

print('='*80)
print('=== БЮДЖЕТ РБ (Республиканский бюджет) ===')
print('='*80)
print(f'Всего листов: {len(rb.sheet_names)}\n')
for i, name in enumerate(rb.sheet_names, 1):
    print(f'{i}. {name}')

print('\n' + '='*80)
print('=== БЮДЖЕТ ПУ (Собственные средства) ===')
print('='*80)
print(f'Всего листов: {len(pu.sheet_names)}\n')
for i, name in enumerate(pu.sheet_names, 1):
    print(f'{i}. {name}')

print('\n' + '='*80)
print('ИТОГО:', len(rb.sheet_names) + len(pu.sheet_names), 'листов')
print('='*80)
