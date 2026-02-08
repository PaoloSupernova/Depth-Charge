# 🔴 WINDOWS USERS: If Build Still Fails with "bash not recognized"

## The Problem

You're seeing this error:
```
bash : The term 'bash' is not recognized as the name of a cmdlet
```

## The Cause

VS Code is using **cached old tasks** from before we added Windows support.

---

## ✅ SOLUTION: Reload VS Code (Takes 5 seconds)

### Step 1: Reload VS Code Window

1. Press **`Ctrl+Shift+P`** (or `F1`)
2. Type: **`Reload Window`**
3. Press **Enter**

### Step 2: Try Building Again

Press **`Ctrl+Shift+B`**

✅ **It should now work!**

---

## 🔄 Alternative Solutions (If Above Doesn't Work)

### Option A: Use the Explicit Windows Task

1. Press **`Ctrl+Shift+P`**
2. Type: **`Tasks: Run Task`**
3. Select: **`🪟 Build (Windows PowerShell)`**

### Option B: Run Build Script Directly

Open terminal in VS Code (`` Ctrl+` ``) and type:

**PowerShell:**
```powershell
.\build.ps1
```

**CMD:**
```cmd
build.bat
```

### Option C: Close and Reopen VS Code

1. File → Exit (or Alt+F4)
2. Reopen VS Code
3. Open your project folder
4. Try `Ctrl+Shift+B`

---

## 🎯 What You Should See After Fix

When you press `Ctrl+Shift+B`, you should see:

```
Building Depth Charge...
Found KickAss.jar in current directory
Java found: java version "X.X.X"
Assembling main.asm...
Build successful!
Output: build/depthcharge.prg
```

You should **NOT** see:
- ❌ "bash : The term 'bash' is not recognized"
- ❌ "bash: command not found"
- ❌ Any reference to "bash" at all

---

## 📚 Additional Help

- **Full Windows Guide:** [WINDOWS-TROUBLESHOOTING.md](WINDOWS-TROUBLESHOOTING.md)
- **VS Code Setup:** [VSCODE-SETUP.md](VSCODE-SETUP.md)
- **Quick Start:** [QUICKSTART.md](QUICKSTART.md)
- **VS Code Cache Help:** [.vscode/README.md](.vscode/README.md)

---

## 🔍 Why This Happened

1. **Before the fix:** tasks.json tried to run `bash ./build.sh` on Windows
2. **After the fix:** tasks.json uses `powershell.exe -File build.ps1` on Windows
3. **Your VS Code:** Still had the old cached task in memory

**The reload clears the cache!**

---

## ✅ Checklist

After reloading VS Code, verify:

- [ ] `Ctrl+Shift+B` builds without bash errors
- [ ] You see PowerShell window (not bash)
- [ ] Build completes successfully
- [ ] `build/depthcharge.prg` file is created

---

## 🆘 Emergency Fallback

If nothing works, build manually:

```powershell
# Open PowerShell in project directory
cd path\to\Depth-Charge

# Create build directory
mkdir -Force build

# Run KickAssembler directly
java -jar KickAss.jar src\main.asm -o build\depthcharge.prg
```

---

## 💡 TL;DR (Too Long; Didn't Read)

1. Press `Ctrl+Shift+P`
2. Type `Reload Window`
3. Press Enter
4. Press `Ctrl+Shift+B`
5. Build now works! ✅

**That's it!** The reload clears VS Code's task cache.
