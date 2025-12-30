#!/usr/bin/env pwsh
# Quick deploy script for Vercel via GitHub

Write-Host "`n=== DEPLOY TO VERCEL - Quick Commands ===`n" -ForegroundColor Cyan

# Check current status
Write-Host "1. Git status check..." -ForegroundColor Yellow
git status

# Show instructions
Write-Host "`n2. Next steps:`n" -ForegroundColor Yellow

Write-Host "Copy and execute these commands (replace YOUR_USERNAME with your GitHub username):`n" -ForegroundColor White

$commands = @"
# Connect to GitHub repository
git remote add origin https://github.com/YOUR_USERNAME/finka-budget-system.git

# Rename branch to main
git branch -M main

# Push to GitHub
git push -u origin main
"@

Write-Host $commands -ForegroundColor Cyan

Write-Host "`n3. After executing commands:" -ForegroundColor Yellow
Write-Host "   - Go to https://vercel.com" -ForegroundColor White
Write-Host "   - Click 'Add New Project'" -ForegroundColor White
Write-Host "   - Import repository finka-budget-system" -ForegroundColor White
Write-Host "   - Click 'Deploy'" -ForegroundColor White

Write-Host "`n4. For subsequent updates use:" -ForegroundColor Yellow

$updateCommands = @"
# Add changes
git add .

# Create commit
git commit -m "Update description"

# Push to GitHub (Vercel will auto-deploy)
git push
"@

Write-Host $updateCommands -ForegroundColor Cyan

Write-Host "`nReady! Vercel will auto-deploy on every push`n" -ForegroundColor Green
