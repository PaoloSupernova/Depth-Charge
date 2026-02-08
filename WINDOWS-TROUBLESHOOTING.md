# Windows Build Troubleshooting Guide

This guide helps Windows users resolve common build issues with the Depth Charge C64 game.

## 🔴 MOST COMMON: VS Code Task Cache Issue

### 🚨 Error Still Happening After Updates?

If you're still getting "bash not recognized" error even after pulling latest changes, **VS Code is using cached old tasks**.

### ✅ QUICK FIX: Reload VS Code Window (5 seconds)

1. Press **`Ctrl+Shift+P`** (or `F1`)
2. Type: **`Reload Window`**
3. Press **Enter**
4. Try **`Ctrl+Shift+B`** again

**This clears the task cache and loads the new Windows-compatible tasks.**

### Alternative: Use Explicit Windows Task

If reloading doesn't work:

1. Press **`Ctrl+Shift+P`**
2. Type: **`Tasks: Run Task`**
3. Select: **`🪟 Build (Windows PowerShell)`**

---

## 🔴 Problem: "bash is not recognized"

### Error Message
```
bash : The term 'bash' is not recognized as the name of a cmdlet, function, script file, or operable 
program. Check the spelling of the name, or if a path was included, verify that the path is correct and 
try again.
```

### Why This Happens
1. The original build system assumed bash was available
2. Windows PowerShell doesn't include bash by default
3. **OR** VS Code is using old cached task definitions (see above)

### ✅ Solution 1: Reload VS Code (If Just Updated)

**See "VS Code Task Cache Issue" section above** - this is the most common reason!

### ✅ Solution 2: Use the Updated Build System

The repository now includes Windows-native build scripts:

1. **Using VS Code Build Task (Easiest):**
   - Press `Ctrl+Shift+B`
   - The system automatically uses PowerShell on Windows
   - No bash required!

2. **Using PowerShell Terminal:**
   ```powershell
   .\build.ps1
   ```

3. **Using CMD Terminal:**
   ```cmd
   build.bat
   ```

### ✅ Solution 2: Install Git for Windows (Alternative)

If you prefer to use bash scripts:

1. Download and install [Git for Windows](https://git-scm.com/download/win)
2. This includes Git Bash
3. Use Git Bash terminal in VS Code or run:
   ```bash
   ./build.sh
   ```

### ✅ Solution 3: Use WSL (Windows Subsystem for Linux)

For a full Linux environment on Windows:

1. Install WSL: `wsl --install` in PowerShell as Administrator
2. Open WSL terminal
3. Navigate to your project
4. Run: `./build.sh`

---

## 🔴 Problem: "PowerShell Execution Policy"

### Error Message
```
.\build.ps1 : File cannot be loaded because running scripts is disabled on this system.
```

### ✅ Solution 1: Change Execution Policy (One-time setup)

Run PowerShell as Administrator and execute:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### ✅ Solution 2: Bypass for Single Script

Run the script with bypass:
```powershell
powershell.exe -ExecutionPolicy Bypass -File build.ps1
```

### ✅ Solution 3: Use batch file instead

The .bat file doesn't have execution policy restrictions:
```cmd
build.bat
```

---

## 🔴 Problem: "KickAssembler not found"

### Error Message
```
KickAssembler not found!
Please ensure KickAss.jar is in the current directory
```

### ✅ Solution 1: Place KickAss.jar in Project Directory

1. Download KickAssembler from [www.theweb.dk/KickAssembler](http://www.theweb.dk/KickAssembler/)
2. Extract `KickAss.jar`
3. Copy it to your `Depth-Charge` project directory
4. Build again

### ✅ Solution 2: Set Environment Variable

**PowerShell (current session):**
```powershell
$env:KICKASS_JAR = "C:\path\to\KickAss.jar"
```

**PowerShell (permanent):**
```powershell
[System.Environment]::SetEnvironmentVariable('KICKASS_JAR', 'C:\path\to\KickAss.jar', 'User')
```

**CMD (current session):**
```cmd
set KICKASS_JAR=C:\path\to\KickAss.jar
```

**System-wide (via GUI):**
1. Open System Properties → Advanced → Environment Variables
2. Click "New" under User variables
3. Variable name: `KICKASS_JAR`
4. Variable value: `C:\path\to\KickAss.jar`
5. Click OK

---

## 🔴 Problem: "Java not found"

### Error Message
```
Java not found! Please install Java Runtime Environment (JRE)
```

### ✅ Solution: Install Java

1. Download Java from:
   - [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
   - Or [OpenJDK](https://adoptium.net/)

2. Install Java

3. Verify installation:
   ```powershell
   java -version
   ```

4. If java command not found after install:
   - Add Java to your PATH:
   - System Properties → Advanced → Environment Variables
   - Edit PATH variable
   - Add Java bin directory (e.g., `C:\Program Files\Java\jdk-17\bin`)

---

## 🔴 Problem: Path Issues (Slashes)

### Issue
Windows uses backslashes `\` while Unix uses forward slashes `/`

### ✅ Solution

The build scripts handle this automatically. If manually running commands:

**PowerShell/CMD:**
```powershell
java -jar KickAss.jar src\main.asm -o build\depthcharge.prg
```

**Git Bash:**
```bash
java -jar KickAss.jar src/main.asm -o build/depthcharge.prg
```

---

## 🔴 Problem: VICE Emulator Path

### Issue
VICE not launching from VS Code

### ✅ Solution

Edit `.vscode/launch.json` and set correct Windows path:

```json
{
  "windows": {
    "program": "C:\\Program Files\\VICE\\x64sc.exe"
  }
}
```

Common VICE installation paths:
- `C:\Program Files\VICE\x64sc.exe`
- `C:\Program Files (x86)\VICE\x64sc.exe`
- `C:\VICE\x64sc.exe`

---

## 📋 Quick Command Reference

### Build Commands

| Method | Command |
|--------|---------|
| VS Code Task | `Ctrl+Shift+B` |
| PowerShell | `.\build.ps1` |
| CMD | `build.bat` |
| Git Bash | `./build.sh` |
| Manual | `java -jar KickAss.jar src\main.asm -o build\depthcharge.prg` |

### Run Commands

| Method | Command |
|--------|---------|
| VS Code | `F5` |
| PowerShell | `& "C:\Program Files\VICE\x64sc.exe" build\depthcharge.prg` |
| CMD | `"C:\Program Files\VICE\x64sc.exe" build\depthcharge.prg` |

---

## ✅ Verification Checklist

After setup, verify everything works:

- [ ] Java is installed: `java -version`
- [ ] KickAss.jar is accessible (in project dir or KICKASS_JAR set)
- [ ] Build scripts exist: `build.ps1` and `build.bat`
- [ ] Can build: `.\build.ps1` or `build.bat`
- [ ] Build directory created: `build\depthcharge.prg` exists
- [ ] VICE path configured in `.vscode/launch.json`
- [ ] Can run: `F5` in VS Code

---

## 🆘 Still Having Issues?

1. **Check the main guides:**
   - [VSCODE-SETUP.md](VSCODE-SETUP.md) - Complete setup guide
   - [QUICKSTART.md](QUICKSTART.md) - Quick setup
   - [BUILDING.md](BUILDING.md) - Build system details

2. **Enable detailed error messages:**
   ```powershell
   # Run build with verbose output
   .\build.ps1 -Verbose
   ```

3. **Check file permissions:**
   - Right-click files → Properties → Unblock (if from download)

4. **Verify directory structure:**
   ```powershell
   # Should show src/ directory with .asm files
   Get-ChildItem -Recurse
   ```

5. **Open an issue on GitHub with:**
   - Windows version
   - PowerShell version: `$PSVersionTable.PSVersion`
   - Java version: `java -version`
   - Error messages (full text)
   - Steps you've tried

---

## 💡 Tips for Windows Users

1. **Use Windows Terminal** (modern, better than CMD)
   - Download from Microsoft Store
   - Supports tabs, better colors, easier copy/paste

2. **VS Code integrated terminal:**
   - Press `` Ctrl+` `` to open terminal
   - Change default shell: `Ctrl+Shift+P` → "Select Default Profile"
   - Choose PowerShell, CMD, or Git Bash

3. **Avoid spaces in paths:**
   - Clone to `C:\Projects\Depth-Charge`
   - Not `C:\My Projects\Depth Charge` (spaces cause issues)

4. **Keep tools updated:**
   - Update Java regularly
   - Update VS Code
   - Update VICE emulator

---

## 🎯 Summary

**The "bash not recognized" error is now fixed!**

- Use `Ctrl+Shift+B` in VS Code (automatic)
- Or run `.\build.ps1` in PowerShell
- Or run `build.bat` in CMD

**No bash installation required for Windows users!**
