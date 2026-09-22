# MDCAT Auto-Push Script
# Jab bhi koi file save ho — automatically GitHub pe push hoga

$folderPath = "C:\Users\abcde\Desktop\MDCAT"
$token      = "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"
$repoUrl    = "https://InayatullahMassori51:$token@github.com/InayatullahMassori51/mdcat-merit-calculator.git"

Set-Location $folderPath
git remote set-url origin $repoUrl

Write-Host ""
Write-Host "[OK] Auto-Push Script Shuru Ho Gaya!" -ForegroundColor Green
Write-Host "[>>] Watching: $folderPath" -ForegroundColor Cyan
Write-Host "[..] Har file save pe GitHub update hoga..." -ForegroundColor Yellow
Write-Host "[X]  Band karne ke liye Ctrl+C dabao" -ForegroundColor Red
Write-Host ""

$watcher                       = New-Object System.IO.FileSystemWatcher
$watcher.Path                  = $folderPath
$watcher.Filter                = "*.*"
$watcher.IncludeSubdirectories = $false
$watcher.NotifyFilter          = [System.IO.NotifyFilters]::LastWrite

$action = {
    $fileName = $Event.SourceEventArgs.Name
    if ($fileName -match "\.git|auto-push\.ps1") { return }

    Write-Host ""
    Write-Host "[CHANGE] $fileName" -ForegroundColor Magenta
    Write-Host "[PUSH] GitHub pe push ho raha hai..." -ForegroundColor Cyan

    Set-Location "C:\Users\abcde\Desktop\MDCAT"
    git add -A
    $commitMsg = "Update: $fileName - $(Get-Date -Format 'dd-MM-yyyy HH:mm:ss')"
    git commit -m $commitMsg
    git push origin main 2>&1

    Write-Host "[LIVE] https://inayatullahmassori51.github.io/mdcat-merit-calculator/" -ForegroundColor Green
    Write-Host ""
}

Register-ObjectEvent $watcher "Changed" -Action $action | Out-Null
$watcher.EnableRaisingEvents = $true

try {
    while ($true) { Start-Sleep -Seconds 2 }
} finally {
    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()
    Write-Host "[STOP] Auto-Push band ho gaya." -ForegroundColor Red
}
