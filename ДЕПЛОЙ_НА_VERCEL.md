# 🚀 Деплой на Vercel - Пошаговая инструкция

## ✅ Что уже сделано:

1. ✅ Git репозиторий инициализирован
2. ✅ Все файлы добавлены в git
3. ✅ Создан коммит с описанием изменений
4. ✅ Создан .gitignore
5. ✅ Создан vercel.json с конфигурацией

## 📋 Два способа деплоя на Vercel:

---

## 🌐 Способ 1: Через GitHub (Рекомендуется)

### Шаг 1: Создайте репозиторий на GitHub

1. Перейдите на https://github.com
2. Нажмите кнопку **"New repository"** (зеленая кнопка)
3. Заполните:
   - **Repository name**: `finka-budget-system` (или любое другое имя)
   - **Description**: "Бюджетная система НАО РФМШ с мобильной адаптацией"
   - Выберите **Public** или **Private**
   - **НЕ СОЗДАВАЙТЕ** README, .gitignore, license (у вас уже есть)
4. Нажмите **"Create repository"**

### Шаг 2: Подключите локальный репозиторий к GitHub

Скопируйте и выполните команды (замените `YOUR_USERNAME` на ваш username GitHub):

```powershell
cd "c:\Users\kiral\Desktop\finka\Новая папка"
git remote add origin https://github.com/YOUR_USERNAME/finka-budget-system.git
git branch -M main
git push -u origin main
```

**Пример:**
```powershell
git remote add origin https://github.com/ivanov/finka-budget-system.git
git branch -M main
git push -u origin main
```

### Шаг 3: Подключите Vercel к GitHub

1. Перейдите на https://vercel.com
2. Нажмите **"Sign Up"** или **"Login"**
3. Выберите **"Continue with GitHub"**
4. Авторизуйтесь через GitHub
5. На главной странице нажмите **"Add New..."** → **"Project"**
6. Найдите ваш репозиторий `finka-budget-system`
7. Нажмите **"Import"**
8. В настройках:
   - **Framework Preset**: Other
   - **Root Directory**: ./
   - **Build Command**: (оставьте пустым)
   - **Output Directory**: (оставьте пустым)
9. Нажмите **"Deploy"**

### Шаг 4: Готово! 🎉

Vercel автоматически задеплоит ваш проект. После завершения вы получите:
- Production URL (например: `https://finka-budget-system.vercel.app`)
- Preview URL для каждого коммита

**Автоматический деплой:**
- При каждом `git push` Vercel автоматически обновит сайт
- Изменения появятся через 1-2 минуты

---

## 💻 Способ 2: Через Vercel CLI

### Шаг 1: Установите Vercel CLI

```powershell
npm install -g vercel
```

Если npm не установлен, сначала установите Node.js с https://nodejs.org

### Шаг 2: Войдите в Vercel

```powershell
cd "c:\Users\kiral\Desktop\finka\Новая папка"
vercel login
```

Следуйте инструкциям для авторизации.

### Шаг 3: Деплой проекта

```powershell
vercel
```

Ответьте на вопросы:
- **Set up and deploy?** → Y (yes)
- **Which scope?** → Выберите ваш аккаунт
- **Link to existing project?** → N (no)
- **What's your project's name?** → finka-budget-system
- **In which directory?** → ./ (оставьте по умолчанию)
- **Override settings?** → N (no)

### Шаг 4: Деплой в production

```powershell
vercel --prod
```

### Шаг 5: Готово! 🎉

Vercel выдаст URL вашего сайта, например:
```
https://finka-budget-system.vercel.app
```

---

## 🔄 Обновление проекта после изменений

### Если используете GitHub:

```powershell
cd "c:\Users\kiral\Desktop\finka\Новая папка"
git add .
git commit -m "Описание изменений"
git push
```

Vercel автоматически задеплоит изменения!

### Если используете Vercel CLI:

```powershell
cd "c:\Users\kiral\Desktop\finka\Новая папка"
vercel --prod
```

---

## 📱 Проверка мобильной версии

После деплоя откройте сайт на:
- 📱 Смартфоне (Chrome, Safari)
- 💻 В браузере через DevTools (F12 → Toggle Device Toolbar)
- 📱 iPad/планшете

---

## 🛠️ Полезные команды

### Проверить статус git:
```powershell
git status
```

### Посмотреть историю коммитов:
```powershell
git log --oneline
```

### Посмотреть URL репозитория:
```powershell
git remote -v
```

### Посмотреть развернутые проекты Vercel:
```powershell
vercel list
```

---

## ⚠️ Важные замечания

1. **GitHub рекомендуется** - более удобен для работы в команде
2. **Автоматический деплой** работает только при подключении через GitHub
3. **LocalStorage** данные не переносятся - пользователи должны будут заполнить данные заново или импортировать из Excel
4. **HTTPS** - Vercel автоматически включает SSL сертификат

---

## 🎯 Быстрый старт (для GitHub способа)

1. Создайте репозиторий на GitHub
2. Выполните команды:
```powershell
cd "c:\Users\kiral\Desktop\finka\Новая папка"
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git
git branch -M main
git push -u origin main
```
3. Зайдите на vercel.com
4. Импортируйте проект с GitHub
5. Нажмите Deploy
6. Готово! Получите ссылку на сайт

---

## 📧 Поддержка

Если возникнут проблемы:
- Vercel Docs: https://vercel.com/docs
- GitHub Docs: https://docs.github.com
- Vercel Support: https://vercel.com/support

---

**Дата создания**: 30 декабря 2025
**Статус**: ✅ Готово к деплою
