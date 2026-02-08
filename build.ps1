# PowerShell Build Script for Depth Charge
# Windows-native alternative to build.sh

Write-Host "Building Depth Charge..." -ForegroundColor Yellow

# Create build directory if it doesn't exist
if (-not (Test-Path "build")) {
    New-Item -ItemType Directory -Path "build" | Out-Null
}

# Check if KickAssembler is available
$kickassJar = ""
if (Test-Path "KickAss.jar") {
    $kickassJar = ".\KickAss.jar"
    Write-Host "Found KickAss.jar in current directory" -ForegroundColor Green
} elseif ($env:KICKASS_JAR -and (Test-Path $env:KICKASS_JAR)) {
    $kickassJar = $env:KICKASS_JAR
    Write-Host "Using KickAss.jar from KICKASS_JAR environment variable" -ForegroundColor Green
} else {
    Write-Host "KickAssembler not found!" -ForegroundColor Red
    Write-Host "Please ensure KickAss.jar is in the current directory" -ForegroundColor Yellow
    Write-Host "Or set KICKASS_JAR environment variable to point to KickAss.jar" -ForegroundColor Yellow
    exit 1
}

# Check if Java is available
try {
    $javaVersion = java -version 2>&1
    Write-Host "Java found: $($javaVersion[0])" -ForegroundColor Green
} catch {
    Write-Host "Java not found! Please install Java Runtime Environment (JRE)" -ForegroundColor Red
    exit 1
}

# Assemble the main file
Write-Host "Assembling main.asm..." -ForegroundColor Yellow
$output = & java -jar $kickassJar src/main.asm -o build/depthcharge.prg -showmem 2>&1

# Display output
$output | ForEach-Object { Write-Host $_ }

# Check if build was successful
if ($LASTEXITCODE -eq 0 -and (Test-Path "build/depthcharge.prg")) {
    Write-Host "`nBuild successful!" -ForegroundColor Green
    Write-Host "Output: build/depthcharge.prg" -ForegroundColor Green
    
    # Show file size
    $fileSize = (Get-Item "build/depthcharge.prg").Length
    Write-Host "File size: $fileSize bytes" -ForegroundColor Green
} else {
    Write-Host "`nBuild failed!" -ForegroundColor Red
    exit 1
}
