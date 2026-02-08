# VS Code Configuration - IMPORTANT FOR WINDOWS USERS

## 🔴 If You're Still Getting "bash not recognized" Error

This means VS Code is using cached tasks. Follow these steps:

### Solution 1: Reload VS Code Window (EASIEST)

1. Press `Ctrl+Shift+P` (or `F1`)
2. Type: `Reload Window`
3. Press Enter
4. Try building again with `Ctrl+Shift+B`

### Solution 2: Use Explicit Windows Task

Instead of `Ctrl+Shift+B`, use the task menu:

1. Press `Ctrl+Shift+P` (or `F1`)
2. Type: `Tasks: Run Task`
3. Select: **"🪟 Build (Windows PowerShell)"**

### Solution 3: Close and Reopen VS Code

1. Close VS Code completely (File → Exit)
2. Reopen the project
3. Try `Ctrl+Shift+B` again

### Solution 4: Run Build Script Directly

Open a terminal in VS Code (`` Ctrl+` ``) and run:

**PowerShell:**
```powershell
.\build.ps1
```

**CMD:**
```cmd
build.bat
```

---

## 📋 Available Build Tasks

When you press `Ctrl+Shift+P` → "Tasks: Run Task", you'll see:

1. **🪟 Build (Windows PowerShell)** - Use this if default task fails
2. **🪟 Build (Windows CMD)** - Alternative if PowerShell is blocked
3. **Build Depth Charge** - Default task (auto-detects platform)
4. **Build with Make** - For Linux/macOS with make installed
5. **Manual Build with KickAssembler** - Direct Java invocation
6. **Build with CMD (Windows)** - Another Windows option

---

## 🔧 Why This Happens

VS Code caches task definitions. When we updated `tasks.json` to fix Windows compatibility, VS Code might still be using the old cached version that tried to run `bash`.

**The fix:** Reload the VS Code window to clear the cache.

---

## ✅ Verification

After reloading, press `Ctrl+Shift+B` and you should see:

- **Windows:** PowerShell window opens and runs `build.ps1`
- **Linux/macOS:** Terminal runs `./build.sh`

You should NOT see "bash: command not found" or "bash is not recognized"

---

## 🆘 Still Having Issues?

1. **Check you have the latest files:**
   ```powershell
   git pull origin copilot/implement-depth-charge-game
   ```

2. **Verify the scripts exist:**
   ```powershell
   dir build.ps1
   dir build.bat
   ```

3. **Try running directly in terminal:**
   ```powershell
   .\build.ps1
   ```

4. **See full troubleshooting:**
   - [WINDOWS-TROUBLESHOOTING.md](../WINDOWS-TROUBLESHOOTING.md)
   - [VSCODE-SETUP.md](../VSCODE-SETUP.md)

---

## 📝 Files in This Directory

- `tasks.json` - Build task definitions
- `launch.json` - VICE emulator launcher configuration
- `extensions.json` - Recommended VS Code extensions
- `README.md` - This file

---

**Quick fix:** Press `Ctrl+Shift+P` → `Reload Window` → Try `Ctrl+Shift+B` again!
