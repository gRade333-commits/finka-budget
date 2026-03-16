$dir = "c:\Users\Admin\OneDrive - uib.kz\finka-budget-main"
Get-ChildItem $dir -Filter "*.html" | Where-Object { $_.Name -notlike "_*" } | ForEach-Object {
    $c = [IO.File]::ReadAllText($_.FullName)
    $hasButtons = $c -match "branch-btn"
    $hasNaoBtn = ($c -match 'data-branch="nao"') -or ($c -match "switchBranch\('nao'\)")
    $hasBranches = $c -match "branches\s*=\s*\["
    $hasNaoInArray = $c -match "'nao'"
    $s = ""
    if ($hasButtons -and -not $hasNaoBtn) { $s += " MISSING_NAO_BUTTON" }
    if ($hasBranches -and -not $hasNaoInArray) { $s += " MISSING_NAO_ARRAY" }
    if ($hasButtons -and $hasNaoBtn) { $s += " OK_btn" }
    if ($hasBranches -and $hasNaoInArray) { $s += " OK_arr" }
    if (-not $hasButtons -and -not $hasBranches) { $s += " no_branches" }
    Write-Host "$($_.Name) =>$s"
}
