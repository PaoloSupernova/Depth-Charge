# ⛔ STOP! You Don't Need Bash on Windows!

## Are You Getting "bash not recognized" Error?

**YOU DON'T NEED BASH!** This project works natively on Windows without bash.

---

## ✅ What You Should Do Instead

### Open PowerShell Terminal in VS Code:

1. In VS Code, press **`` Ctrl+` ``** (that's Ctrl + backtick)
2. If it says "PowerShell" at the top, you're good!
3. If it says something else, click the dropdown and select "PowerShell"

### Then Type These Commands:

```powershell
# Verify Java works
java -version

# Verify KickAssembler exists
dir KickAss.jar

# Build the game!
.\build.ps1
```

**That's it!** No bash needed!

---

## 🚀 Quick Build Guide (Copy-Paste These)

### Check Everything Is Set Up:

```powershell
# 1. Check Java
java -version

# 2. Check if KickAss.jar exists
Test-Path KickAss.jar

# 3. Check if source files exist
dir src\*.asm
```

### Build the Game:

**Option 1: PowerShell (Recommended)**
```powershell
.\build.ps1
```

**Option 2: CMD**
```cmd
build.bat
```

**Option 3: Direct Java Command**
```powershell
java -jar KickAss.jar src\main.asm -o build\depthcharge.prg
```

---

## ❌ What NOT to Do on Windows

**DON'T type these:**
- ❌ `bash ./build.sh`
- ❌ `./build.sh`
- ❌ `sh build.sh`
- ❌ Any bash commands

**These won't work on Windows!**

---

## ✅ What TO Type on Windows

**DO type these:**
- ✅ `.\build.ps1` (PowerShell)
- ✅ `build.bat` (CMD)
- ✅ Use VS Code task: `Ctrl+Shift+B`

---

## 🔍 Diagnostic Commands (If Build Fails)

### Quick Diagnostic (Recommended)

```powershell
.\check-setup.ps1
```

This script will check everything and tell you exactly what's missing!

### Manual Diagnostic

Copy-paste these one by one to diagnose:

```powershell
# Show current directory
pwd

# List all files
dir

# Check if build scripts exist
Test-Path build.ps1
Test-Path build.bat

# Check if KickAss.jar exists
Test-Path KickAss.jar

# Check Java
java -version

# Check source directory
Test-Path src\main.asm

# Try manual build
mkdir -Force build
java -jar KickAss.jar src\main.asm -o build\depthcharge.prg
```

**Copy the output and share it if you need help!**

---

## 🎯 Expected Output When Build Works

```
Building Depth Charge...
Found KickAss.jar in current directory
Java found: java version "17.0.x" (or similar)
Assembling main.asm...
Build successful!
Output: build/depthcharge.prg
File size: XXXX bytes
```

---

## 🆘 If Build Still Fails

Run this diagnostic and share the output:

```powershell
# Comprehensive diagnostic
Write-Host "=== Diagnostic Report ==="
Write-Host "Current Directory:" (pwd)
Write-Host "`nJava Version:"
java -version 2>&1
Write-Host "`nKickAss.jar exists:" (Test-Path KickAss.jar)
Write-Host "`nSource files:"
dir src\*.asm | Select-Object Name
Write-Host "`nBuild scripts:"
dir build.* | Select-Object Name
Write-Host "`n=== End Report ==="
```

Copy the output and share it!

---

## 💡 Key Point

**You're on Windows. Use Windows commands:**
- PowerShell: `.\build.ps1`
- CMD: `build.bat`

**Bash is for Linux/Mac. You don't need it!**

---

## 🎮 Quick Start (30 Seconds)

1. Open VS Code
2. Press `` Ctrl+` `` to open terminal
3. Make sure it says "PowerShell" (not CMD)
4. Type: `.\build.ps1`
5. Press Enter
6. Game builds!

Done! 🎉
