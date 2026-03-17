import pandas as pd
import json

# Читаем лист "Сводная общая 2026г."
xl = pd.ExcelFile('Бюджет РБ 2026 (1).xlsx')
df = pd.read_excel(xl, 'Сводная общая 2026г.', header=None)

print(f"Размер листа: {df.shape[0]} строк x {df.shape[1]} столбцов")
print("\n" + "="*80)

# Находим все строки с заголовками разделов (жирный текст или заглавными буквами)
sections = []
current_section = None
section_data = []

for idx, row in df.iterrows():
    # Пропускаем полностью пустые строки
    if row.isna().all():
        continue
    
    # Первая ячейка с текстом
    first_cell = str(row[0]) if pd.notna(row[0]) else ""
    
    # Если это заголовок раздела (обычно в первой колонке, может быть заглавными буквами)
    # или номер статьи вида "01.00.000"
    if first_cell and (first_cell.isupper() or any(c.isdigit() for c in first_cell[:10])):
        if current_section and section_data:
            sections.append({
                'title': current_section,
                'start_row': section_data[0],
                'end_row': section_data[-1],
                'rows_count': len(section_data)
            })
        current_section = first_cell
        section_data = [idx]
    elif current_section:
        section_data.append(idx)

# Добавляем последний раздел
if current_section and section_data:
    sections.append({
        'title': current_section,
        'start_row': section_data[0],
        'end_row': section_data[-1],
        'rows_count': len(section_data)
    })

print(f"\nНайдено разделов: {len(sections)}")
print("\nРазделы:")
for i, sec in enumerate(sections[:20], 1):  # Первые 20 разделов
    print(f"{i}. {sec['title'][:60]} | Строки {sec['start_row']}-{sec['end_row']} ({sec['rows_count']} строк)")

# Сохраняем первые 100 строк для анализа структуры
sample = []
for idx in range(min(100, len(df))):
    row_data = []
    for col_idx in range(min(20, len(df.columns))):  # Первые 20 колонок
        val = df.iloc[idx, col_idx]
        if pd.isna(val):
            row_data.append(None)
        else:
            row_data.append(str(val))
    sample.append(row_data)

with open('svodnaya_full_structure.json', 'w', encoding='utf-8') as f:
    json.dump({
        'total_rows': df.shape[0],
        'total_cols': df.shape[1],
        'sections': sections[:30],  # Первые 30 разделов
        'sample_rows': sample
    }, f, ensure_ascii=False, indent=2)

print(f"\n✅ Структура сохранена в svodnaya_full_structure.json")
print(f"Всего строк: {df.shape[0]}")
print(f"Всего столбцов: {df.shape[1]}")
