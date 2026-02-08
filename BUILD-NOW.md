# 🚀 BUILD THE GAME NOW (Windows)

## Copy-Paste This Into VS Code Terminal

### Step 1: Open Terminal
Press **`` Ctrl+` ``** in VS Code

### Step 2: Make Sure You're Using PowerShell
Look at the top of the terminal window. It should say "PowerShell"

If it doesn't:
1. Click the dropdown arrow next to the + button
2. Select "PowerShell"

### Step 3: Copy-Paste This Command

```powershell
.\build.ps1
```

Press **Enter**

---

## ✅ If That Works

You'll see:
```
Building Depth Charge...
Build successful!
Output: build/depthcharge.prg
```

**Success!** The game is built. Now run it:

```powershell
# If you have VICE installed:
& "C:\Program Files\VICE\x64sc.exe" build\depthcharge.prg

# Or press F5 in VS Code
```

---

## ❌ If You Get "KickAssembler not found"

KickAss.jar needs to be in this directory. Download it:
1. Go to: http://www.theweb.dk/KickAssembler/
2. Download KickAssembler
3. Extract `KickAss.jar`
4. Put it in your Depth-Charge folder
5. Try building again: `.\build.ps1`

---

## ❌ If You Get "Java not found"

Install Java:
1. Go to: https://adoptium.net/
2. Download and install Java
3. Restart VS Code
4. Try building again: `.\build.ps1`

---

## ❌ If You Get "build.ps1 cannot be loaded" (Execution Policy)

Run this ONCE:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Then try building again: `.\build.ps1`

---

## 🔄 Alternative: Use CMD Instead

If PowerShell gives you trouble, use CMD:

1. Open CMD terminal (dropdown → Command Prompt)
2. Type: `build.bat`
3. Press Enter

---

## 📋 Quick Verification Commands

Copy-paste these one by one:

```powershell
# 1. Check Java
java -version

# 2. Check KickAss.jar
Test-Path KickAss.jar

# 3. Build!
.\build.ps1
```

---

## 🎯 ONE-LINER: Build Right Now

```powershell
java -jar KickAss.jar src\main.asm -o build\depthcharge.prg ; if ($?) { Write-Host "Build successful! Run with: & 'C:\Program Files\VICE\x64sc.exe' build\depthcharge.prg" -ForegroundColor Green }
```

This builds the game in one command!

---

## 🆘 Share This If You Need Help

### Option 1: Run Diagnostic Script

```powershell
.\check-setup.ps1
```

This will check everything and tell you exactly what's wrong!

### Option 2: Manual Diagnostic

```powershell
# Run this and share the output:
@"
=== DIAGNOSTIC INFO ===
Directory: $(pwd)
Java: $(java -version 2>&1 | Select-Object -First 1)
KickAss.jar exists: $(Test-Path KickAss.jar)
build.ps1 exists: $(Test-Path build.ps1)
Source files: $(if (Test-Path src) { (dir src\*.asm).Count } else { "src folder missing!" })
=== END INFO ===
"@
```

---

## 💡 Remember

**On Windows:**
- ✅ Use: `.\build.ps1` or `build.bat`
- ❌ Don't use: `bash` or `./build.sh`

**Bash is not needed on Windows!**

---

## 🎮 After Building Successfully

Your game is at: `build\depthcharge.prg`

Run it:
1. **F5** in VS Code (if VICE is configured)
2. Or manually: Open VICE emulator → File → Autostart → Select `build\depthcharge.prg`
3. Or: `& "C:\Program Files\VICE\x64sc.exe" build\depthcharge.prg`

---

**TL;DR:** Open PowerShell terminal in VS Code, type `.\build.ps1`, press Enter. Done! 🎉
