# Diagnostic Script for Depth Charge Build
# This script checks if everything is set up correctly

Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "  DEPTH CHARGE BUILD DIAGNOSTICS" -ForegroundColor Cyan
Write-Host "======================================`n" -ForegroundColor Cyan

# Check 1: Current Directory
Write-Host "[1/7] Checking current directory..." -ForegroundColor Yellow
$currentDir = Get-Location
Write-Host "    Current directory: $currentDir" -ForegroundColor Gray
if (Test-Path "src\main.asm") {
    Write-Host "    ✅ You're in the correct project directory" -ForegroundColor Green
} else {
    Write-Host "    ❌ ERROR: Not in the Depth-Charge directory!" -ForegroundColor Red
    Write-Host "    Navigate to your Depth-Charge folder first!" -ForegroundColor Red
}

# Check 2: Java
Write-Host "`n[2/7] Checking Java installation..." -ForegroundColor Yellow
try {
    $javaVersion = & java -version 2>&1 | Select-Object -First 1
    Write-Host "    ✅ Java is installed: $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "    ❌ ERROR: Java not found!" -ForegroundColor Red
    Write-Host "    Download from: https://adoptium.net/" -ForegroundColor Yellow
}

# Check 3: KickAss.jar
Write-Host "`n[3/7] Checking KickAssembler..." -ForegroundColor Yellow
if (Test-Path "KickAss.jar") {
    $size = (Get-Item "KickAss.jar").Length
    Write-Host "    ✅ KickAss.jar found (Size: $size bytes)" -ForegroundColor Green
} else {
    Write-Host "    ❌ ERROR: KickAss.jar not found!" -ForegroundColor Red
    Write-Host "    Download from: http://www.theweb.dk/KickAssembler/" -ForegroundColor Yellow
    Write-Host "    Place KickAss.jar in this directory: $currentDir" -ForegroundColor Yellow
}

# Check 4: Build Scripts
Write-Host "`n[4/7] Checking build scripts..." -ForegroundColor Yellow
if (Test-Path "build.ps1") {
    Write-Host "    ✅ build.ps1 found" -ForegroundColor Green
} else {
    Write-Host "    ❌ build.ps1 missing!" -ForegroundColor Red
}
if (Test-Path "build.bat") {
    Write-Host "    ✅ build.bat found" -ForegroundColor Green
} else {
    Write-Host "    ❌ build.bat missing!" -ForegroundColor Red
}

# Check 5: Source Files
Write-Host "`n[5/7] Checking source files..." -ForegroundColor Yellow
if (Test-Path "src") {
    $asmFiles = (Get-ChildItem src\*.asm -ErrorAction SilentlyContinue)
    if ($asmFiles.Count -gt 0) {
        Write-Host "    ✅ Found $($asmFiles.Count) assembly files in src/" -ForegroundColor Green
        $asmFiles | ForEach-Object { Write-Host "       - $($_.Name)" -ForegroundColor Gray }
    } else {
        Write-Host "    ❌ No .asm files in src/ directory!" -ForegroundColor Red
    }
} else {
    Write-Host "    ❌ ERROR: src/ directory not found!" -ForegroundColor Red
}

# Check 6: Build Directory
Write-Host "`n[6/7] Checking build directory..." -ForegroundColor Yellow
if (Test-Path "build") {
    if (Test-Path "build\depthcharge.prg") {
        $prgSize = (Get-Item "build\depthcharge.prg").Length
        $prgTime = (Get-Item "build\depthcharge.prg").LastWriteTime
        Write-Host "    ✅ Previous build found: $prgSize bytes" -ForegroundColor Green
        Write-Host "       Built: $prgTime" -ForegroundColor Gray
    } else {
        Write-Host "    ℹ️  build/ exists but no .prg file yet" -ForegroundColor Yellow
    }
} else {
    Write-Host "    ℹ️  build/ directory doesn't exist (will be created on first build)" -ForegroundColor Yellow
}

# Check 7: PowerShell Version
Write-Host "`n[7/7] Checking PowerShell version..." -ForegroundColor Yellow
Write-Host "    PowerShell version: $($PSVersionTable.PSVersion)" -ForegroundColor Gray

# Summary
Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "  SUMMARY" -ForegroundColor Cyan
Write-Host "======================================`n" -ForegroundColor Cyan

$canBuild = $true
$issues = @()

if (-not (Test-Path "src\main.asm")) {
    $canBuild = $false
    $issues += "Wrong directory - navigate to Depth-Charge folder"
}

try {
    & java -version 2>&1 | Out-Null
} catch {
    $canBuild = $false
    $issues += "Java not installed - download from https://adoptium.net/"
}

if (-not (Test-Path "KickAss.jar")) {
    $canBuild = $false
    $issues += "KickAss.jar missing - download from http://www.theweb.dk/KickAssembler/"
}

if ($canBuild) {
    Write-Host "✅ ALL CHECKS PASSED!" -ForegroundColor Green
    Write-Host "`nYou can build the game now!" -ForegroundColor Green
    Write-Host "`nRun this command:" -ForegroundColor Yellow
    Write-Host "    .\build.ps1" -ForegroundColor White
    Write-Host "`nOr press Ctrl+Shift+B in VS Code`n" -ForegroundColor Yellow
} else {
    Write-Host "❌ ISSUES FOUND:" -ForegroundColor Red
    foreach ($issue in $issues) {
        Write-Host "   • $issue" -ForegroundColor Red
    }
    Write-Host "`nFix these issues then run this script again.`n" -ForegroundColor Yellow
}

Write-Host "======================================`n" -ForegroundColor Cyan

# Offer to try building
if ($canBuild) {
    Write-Host "Would you like to try building now? (Y/N): " -ForegroundColor Cyan -NoNewline
    $response = Read-Host
    if ($response -eq "Y" -or $response -eq "y") {
        Write-Host "`nStarting build...`n" -ForegroundColor Green
        & .\build.ps1
    }
}
