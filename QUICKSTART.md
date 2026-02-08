# Quick Start Guide - VS Code Setup

## ⚠️ Important: Branch Information

**Are you seeing only README.md?** The full code is on the `copilot/implement-depth-charge-game` branch!

Switch branches:
```bash
git checkout copilot/implement-depth-charge-game
```

Or clone directly to the branch:
```bash
git clone -b copilot/implement-depth-charge-game https://github.com/PaoloSupernova/Depth-Charge.git
```

See [BRANCH-INFO.md](BRANCH-INFO.md) for details.

---

## 🚀 Get Started in 5 Minutes

### Step 1: Clone the Repository
```bash
git clone -b copilot/implement-depth-charge-game https://github.com/PaoloSupernova/Depth-Charge.git
cd Depth-Charge
code .
```

### Step 2: Configure VICE Path
Edit `.vscode/launch.json` and update the path to your VICE executable:

**Windows:** `"program": "C:\\Program Files\\VICE\\x64sc.exe"`  
**macOS:** `"program": "/Applications/Vice/x64sc.app/Contents/MacOS/x64sc"`  
**Linux:** `"program": "/usr/bin/x64sc"`

### Step 3: Build the Game
Press **`Ctrl+Shift+B`** (Windows/Linux) or **`Cmd+Shift+B`** (macOS)

**Windows users:** This automatically uses PowerShell (no bash needed!)

**🔴 Still getting "bash not recognized"?** VS Code task cache issue!
- Press `Ctrl+Shift+P` → Type `Reload Window` → Enter → Try again
- Or use: `Ctrl+Shift+P` → `Tasks: Run Task` → `🪟 Build (Windows PowerShell)`

Or run in terminal:

**Linux/macOS:**
```bash
./build.sh
```

**Windows PowerShell:**
```powershell
.\build.ps1
```

**Windows CMD:**
```cmd
build.bat
```

### Step 4: Run in VICE
Press **`F5`** to launch the game in VICE emulator

Or run manually:
```bash
x64sc build/depthcharge.prg
```

### Step 5: Play!
- **Movement:** Arrow keys (configure joystick in VICE if needed)
- **Fire:** Space bar or Right Ctrl
- **Pause:** RUN/STOP key

---

## 🎮 Controls Setup

In VICE, configure joystick:
1. Settings → Input devices → Control port settings
2. Set **Control Port 2** to "Keyboard"
3. Use arrow keys + Space to play

---

## 📝 Need More Help?

See **[VSCODE-SETUP.md](VSCODE-SETUP.md)** for:
- Detailed configuration instructions
- Troubleshooting common issues
- Advanced debugging tips
- VS Code keyboard shortcuts

---

## ⚡ VS Code Shortcuts

| Action | Shortcut |
|--------|----------|
| Build | `Ctrl+Shift+B` / `Cmd+Shift+B` |
| Run | `F5` |
| Terminal | ``Ctrl+` `` / ``Cmd+` `` |
| Tasks | `Ctrl+Shift+P` → "Tasks: Run Task" |

---

## 🔧 Prerequisites Checklist

- [ ] VS Code installed
- [ ] KickAssembler (KickAss.jar) available
- [ ] VICE emulator (x64 or x64sc) installed
- [ ] Java Runtime Environment (for KickAssembler)
- [ ] Git installed

Missing something? See [VSCODE-SETUP.md](VSCODE-SETUP.md) for installation links.

---

## 📁 Project Structure

```
Depth-Charge/
├── src/            # Assembly source code
├── build/          # Compiled .prg file (generated)
├── .vscode/        # VS Code configuration
├── build.sh        # Build script
└── Makefile        # Build automation
```

---

## 🐛 Common Issues

**"bash is not recognized" (Windows)**  
→ Use `Ctrl+Shift+B` (now uses PowerShell automatically) or run `.\build.ps1` or `build.bat`

**"KickAssembler not found"**  
→ Set `KICKASS_JAR` environment variable or ensure KickAss.jar is in project directory

**"VICE doesn't start"**  
→ Update path in `.vscode/launch.json`

**"No joystick input"**  
→ Configure Control Port 2 in VICE settings

**"PowerShell execution policy" (Windows)**  
→ Run `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` or use `build.bat`

---

**Full documentation:** [VSCODE-SETUP.md](VSCODE-SETUP.md)  
**Build guide:** [BUILDING.md](BUILDING.md)  
**Game info:** [README.md](README.md)
