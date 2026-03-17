"""
Проверка формул в HTML файлах
"""
import re

def check_formulas_in_file(filepath, expected_formulas):
    """Проверяет наличие формул в HTML файле"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        results = []
        for formula_name, pattern in expected_formulas.items():
            if re.search(pattern, content, re.IGNORECASE):
                results.append(f'  ✅ {formula_name}')
            else:
                results.append(f'  ❌ {formula_name} - НЕ НАЙДЕНА!')
        
        return results
    except Exception as e:
        return [f'  ❌ Ошибка чтения файла: {e}']

print('='*80)
print('ПРОВЕРКА ФОРМУЛ В HTML ФАЙЛАХ')
print('='*80)

# Проверяем rb-svod.html
print('\n📘 1. rb-svod.html (Свод 2026-2028)')
print('-'*80)
formulas = {
    'Суммирование 2026+2027+2028': r'2026.*2027.*2028|parseInt.*\+.*parseInt',
    'updateRow функция': r'function updateRow',
    'Автосохранение': r'saveData|localStorage'
}
for result in check_formulas_in_file('rb-svod.html', formulas):
    print(result)

# Проверяем rb-income.html
print('\n📘 2. rb-income.html (Доходная часть РБ)')
print('-'*80)
formulas = {
    'Расчет на 1 учащегося (÷1186)': r'1186|STUDENTS',
    'Помесячное суммирование': r'sum.*month|месяц',
    'updateCell функция': r'function updateCell|function calc'
}
for result in check_formulas_in_file('rb-income.html', formulas):
    print(result)

# Проверяем rb-fzp.html  
print('\n📘 3. rb-fzp.html (СВОД ФЗП)')
print('-'*80)
formulas = {
    'Налоги 6%, 5%, 3%, 3.5%': r'0\.06|0\.05|0\.03|0\.035',
    'Штатное + Тарификация': r'shtat.*tarif',
    'calc функция': r'function calc'
}
for result in check_formulas_in_file('rb-fzp.html', formulas):
    print(result)

# Проверяем rb-kalkulyacia.html
print('\n📘 4. rb-kalkulyacia.html (Калькуляция 2026)')
print('-'*80)
formulas = {
    'Деление на контингент (1186)': r'1186|STUDENTS',
    'Годовая стоимость': r'year|год|annual',
    'Месячная стоимость (÷12)': r'÷ 12|/ 12',
    'Карточки итогов': r'summary-card|итог'
}
for result in check_formulas_in_file('rb-kalkulyacia.html', formulas):
    print(result)

# Проверяем rb-plan-komandir.html
print('\n📘 5. rb-plan-komandir.html (План командировок)')
print('-'*80)
formulas = {
    'МРП 2026 = 3692': r'3692|MRP',
    'Суточные = МРП × Поездки × Дни × Чел': r'mrp.*trips.*days.*people|МРП.*поездки',
    'Динамическое добавление строк': r'addTrip|addRow'
}
for result in check_formulas_in_file('rb-plan-komandir.html', formulas):
    print(result)

# Проверяем pu-ss-almaty.html
print('\n📗 6. pu-ss-almaty.html (СС Алматы)')
print('-'*80)
formulas = {
    'Школа = Всего - ФинЦентр': r'total.*fin|всего.*фин',
    '159 + 164 = 323': r'159|164|323',
    'updateRow функция': r'function updateRow'
}
for result in check_formulas_in_file('pu-ss-almaty.html', formulas):
    print(result)

# Проверяем pu-kalkulyacia-almaty.html
print('\n📗 7. pu-kalkulyacia-almaty.html (Калькуляция Алматы)')
print('-'*80)
formulas = {
    'Контингент 323': r'323|STUDENTS',
    'Деление на контингент': r'÷ 323|/ 323|STUDENTS',
    'Карточки расчета': r'summary.*card|card.*summary'
}
for result in check_formulas_in_file('pu-kalkulyacia-almaty.html', formulas):
    print(result)

# Проверяем pu-grafik-almaty.html
print('\n📗 8. pu-grafik-almaty.html (График оплаты)')
print('-'*80)
formulas = {
    'Ежемесячно = Контингент × Тариф': r'contingent.*tariff|контингент.*тариф',
    '12 месяцев автоматически': r'month.*12|12.*месяц',
    'addStudent функция': r'addStudent|addClass'
}
for result in check_formulas_in_file('pu-grafik-almaty.html', formulas):
    print(result)

# Проверяем pu-plan-rk.html
print('\n📗 9. pu-plan-rk.html (Командировки РК)')
print('-'*80)
formulas = {
    'МРП 2026 = 3692': r'3692|MRP',
    'Суточные формула': r'daily.*mrp|суточные',
    'ИТОГО = (Билеты+Проживание)×Поездки×Чел + Суточные': r'total.*ticket.*hotel|итого'
}
for result in check_formulas_in_file('pu-plan-rk.html', formulas):
    print(result)

# Проверяем pu-plan-abroad.html
print('\n📗 10. pu-plan-abroad.html (Командировки заграницу)')
print('-'*80)
formulas = {
    'Учет визы и страховки': r'visa|виза',
    'ИТОГО = (Билеты+Проживание+Суточные+Виза)×Поездки×Чел': r'total.*visa|итого.*виза',
    'Динамические строки': r'addTrip|addRow'
}
for result in check_formulas_in_file('pu-plan-abroad.html', formulas):
    print(result)

print('\n' + '='*80)
print('ПРОВЕРКА ЗАВЕРШЕНА')
print('='*80)
