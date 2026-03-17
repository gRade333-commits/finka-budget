# 🚀 Инструкция по развертыванию на Vercel

## Быстрый старт

### 1. Установите Vercel CLI (один раз)

Откройте PowerShell и выполните:

```powershell
npm install -g vercel
```

Если npm не установлен, сначала установите Node.js с https://nodejs.org/

### 2. Войдите в Vercel

```powershell
vercel login
```

Выберите способ входа (GitHub, GitLab, Bitbucket или Email)

### 3. Разверните проект

Перейдите в папку проекта и выполните:

```powershell
cd "c:\Users\kiral\Desktop\finka\Новая папка"
vercel
```

При первом развертывании ответьте на вопросы:
- Set up and deploy? → **Yes**
- Which scope? → Выберите ваш аккаунт
- Link to existing project? → **No**
- What's your project's name? → **finka-budget** (или любое другое)
- In which directory is your code located? → **./** (нажмите Enter)

### 4. Получите ссылку

После успешного развертывания вы получите ссылку вида:
```
https://finka-budget-xxxx.vercel.app
```

Эту ссылку можно отправить финансисту!

## Обновление проекта

Когда вы внесете изменения в файлы, просто выполните:

```powershell
vercel --prod
```

Это обновит продакшн версию сайта.

## Важно! ⚠️

**localStorage и данные:**
- Данные сохраняются в браузере пользователя (localStorage)
- У каждого пользователя будут свои данные
- Если нужна общая база данных для всех - нужно добавить backend

**Безопасность:**
- Сайт будет публичным (доступен всем по ссылке)
- Если нужен пароль - можно добавить простую авторизацию

## Альтернатива: Развертывание через Web UI

1. Зайдите на https://vercel.com
2. Нажмите "Add New Project"
3. Выберите "Import Git Repository" или загрузите папку напрямую
4. Vercel автоматически развернет проект

## Управление проектом

- Dashboard: https://vercel.com/dashboard
- Удаление проекта: Settings → Delete Project
- Просмотр логов: вкладка Deployments

## Поддержка

Если возникнут проблемы:
1. Проверьте что все файлы .html, .js, .css, .json на месте
2. Убедитесь что нет ошибок в консоли браузера
3. Проверьте логи деплоя в Vercel Dashboard
