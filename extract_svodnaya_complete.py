import pandas as pd
import json

# Читаем лист "Сводная общая 2026г."
xl = pd.ExcelFile('Бюджет РБ 2026 (1).xlsx')
df = pd.read_excel(xl, 'Сводная общая 2026г.', header=None)

print(f"Размер: {df.shape[0]} строк x {df.shape[1]} столбцов\n")

# Ищем начало разделов по ключевым словам
sections = []
current_section = None
section_rows = []

for row_idx in range(len(df)):
    row = df.iloc[row_idx]
    # Проверяем ячейку с названием раздела (обычно колонка 2)
    cell_2 = str(row[2]) if pd.notna(row[2]) else ""
    
    # Заголовки разделов начинаются с цифры и точки (например "1. Фонд Оплаты Труда")
    if cell_2.strip() and len(cell_2) > 2:
        # Проверяем, начинается ли с цифры и точки
        parts = cell_2.strip().split('.', 1)
        if len(parts) == 2 and parts[0].strip().isdigit():
            # Сохраняем предыдущий раздел
            if current_section:
                sections.append({
                    'num': current_section['num'],
                    'title': current_section['title'],
                    'start_row': current_section['start_row'],
                    'end_row': row_idx - 1,
                    'rows': section_rows
                })
            
            # Начинаем новый раздел
            num = int(parts[0].strip())
            title = parts[1].strip()
            current_section = {
                'num': num,
                'title': title,
                'start_row': row_idx
            }
            section_rows = []
        else:
            # Добавляем строку к текущему разделу
            if current_section:
                section_rows.append({
                    'idx': row_idx,
                    'data': [str(row[i]) if pd.notna(row[i]) else "" for i in range(len(row))]
                })

# Сохраняем последний раздел
if current_section:
    sections.append({
        'num': current_section['num'],
        'title': current_section['title'],
        'start_row': current_section['start_row'],
        'end_row': len(df) - 1,
        'rows': section_rows
    })

print(f"Найдено {len(sections)} разделов:\n")
for sec in sections:
    print(f"{sec['num']}. {sec['title']}")
    print(f"   Строки: {sec['start_row']}-{sec['end_row']} ({len(sec['rows'])} строк данных)\n")

# Сохраняем в JSON
with open('svodnaya_sections_full.json', 'w', encoding='utf-8') as f:
    json.dump({
        'total_rows': df.shape[0],
        'total_cols': df.shape[1],
        'sections_count': len(sections),
        'sections': sections
    }, f, ensure_ascii=False, indent=2)

print(f"✅ Данные сохранены в svodnaya_sections_full.json")
