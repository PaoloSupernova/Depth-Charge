# 🎮 How to Get Started with Depth Charge in VS Code

## What You Asked For

You said: *"I've got KickAssembler and VICE emulator set up in VS Code. Please instruct me on the process I need to follow to test this game."*

## What We Created for You

We've added **complete VS Code setup documentation** to make this super easy! 🚀

---

## 📖 Your Starting Points

### Option 1: Quick Start (5 Minutes) ⚡

**Start here if you just want to play:** [QUICKSTART.md](QUICKSTART.md)

This gives you the 5 essential steps:
1. Clone
2. Configure VICE path
3. Build (Ctrl+Shift+B)
4. Run (F5)
5. Play!

### Option 2: Complete Guide (Detailed) 📚

**Start here if you want the full walkthrough:** [VSCODE-SETUP.md](VSCODE-SETUP.md)

This comprehensive guide (10+ pages) covers:
- Every step in detail
- VS Code configuration
- Build automation setup
- VICE integration
- Debugging tips
- Troubleshooting
- Keyboard shortcuts
- Recommended extensions

---

## ✨ What's New in Your Repository

### VS Code Configuration Files (Ready to Use!)

We've added a `.vscode/` folder with:

1. **`tasks.json`** - Build automation
   - Press `Ctrl+Shift+B` to build instantly
   - 6 different build tasks available

2. **`launch.json`** - VICE integration
   - Press `F5` to launch game in VICE
   - Supports Windows, macOS, and Linux
   - Just need to set your VICE path once

3. **`extensions.json`** - Recommended extensions
   - VS Code will prompt you to install helpful extensions
   - Includes 6502 assembly syntax highlighting
   - C64 development tools

### Documentation Files

1. **VSCODE-SETUP.md** (445 lines)
   - Complete step-by-step guide
   - Covers everything from cloning to debugging

2. **QUICKSTART.md** (112 lines)
   - Get running in 5 minutes
   - Essential steps only

3. **Updated README.md**
   - Now has prominent links to VS Code guides
   - Quick access right at the top of build section

---

## 🚀 The Process You Need to Follow

### Step 1: Get the Repository

```bash
git clone https://github.com/PaoloSupernova/Depth-Charge.git
cd Depth-Charge
code .
```

### Step 2: Configure VICE Path (One-Time Setup)

Open `.vscode/launch.json` and update line with your VICE executable path:

**Windows:**
```json
"program": "C:\\Program Files\\VICE\\x64sc.exe"
```

**macOS:**
```json
"program": "/Applications/Vice/x64sc.app/Contents/MacOS/x64sc"
```

**Linux:**
```json
"program": "/usr/bin/x64sc"
```

### Step 3: Build the Game

Press **`Ctrl+Shift+B`** (Windows/Linux) or **`Cmd+Shift+B`** (macOS)

You'll see the build output in the terminal. Look for:
```
Building Depth Charge...
Build successful!
Output: build/depthcharge.prg
```

### Step 4: Run in VICE

Press **`F5`**

The game will automatically:
1. Build if needed
2. Launch VICE emulator
3. Load the game
4. Start playing!

### Step 5: Configure Controls (First Time)

In VICE, you need to set up the joystick:

1. Settings → Input devices → Control port settings
2. Set **Control Port 2** to "Keyboard"
3. Now you can use:
   - **Arrow keys** = Move submarine
   - **Space** or **Right Ctrl** = Fire torpedoes

### Step 6: Play!

The game should now be running:
- You'll see the title screen "DEPTH CHARGE"
- Press fire button to start
- Navigate your submarine with arrow keys
- Shoot torpedoes with fire button
- Watch your oxygen meter (top right)
- Survive the enemy waves!

---

## 🎯 Testing the Game

Here's what you should test:

### Basic Functionality
- [ ] Title screen appears
- [ ] Press fire to start game
- [ ] Player submarine appears on screen
- [ ] Submarine moves in all 8 directions
- [ ] Fire button launches torpedoes

### Gameplay Features
- [ ] Enemies spawn (ships, submarines, mines)
- [ ] Torpedoes destroy enemies on hit
- [ ] Score increases when you destroy enemies
- [ ] Oxygen bar depletes when underwater
- [ ] Oxygen regenerates near surface
- [ ] Player can take damage
- [ ] Lives decrease when hit
- [ ] Invincibility activates after damage

### Audio
- [ ] Background music plays
- [ ] Torpedo launch sound effect
- [ ] Explosion sound when enemies destroyed
- [ ] Player hit sound effect
- [ ] Oxygen warning beep

### Progression
- [ ] Level counter displays
- [ ] Game over screen when lives reach 0
- [ ] Can restart from title screen

---

## ⌨️ Essential VS Code Shortcuts

| What You Want to Do | Press This |
|---------------------|------------|
| Build the game | `Ctrl+Shift+B` or `Cmd+Shift+B` |
| Run in VICE | `F5` |
| Open terminal | ``Ctrl+` `` or ``Cmd+` `` |
| View all tasks | `Ctrl+Shift+P` → "Tasks: Run Task" |
| Save file | `Ctrl+S` or `Cmd+S` |

---

## 🐛 Common Issues & Solutions

### "KickAssembler not found"
**Fix:** Edit `build.sh` and set the path to your KickAss.jar:
```bash
KICKASS="java -jar /your/path/to/KickAss.jar"
```

Or set environment variable:
```bash
export KICKASS_JAR="/path/to/KickAss.jar"
```

### "VICE doesn't start when I press F5"
**Fix:** Edit `.vscode/launch.json` and update the VICE path for your OS.

### "Joystick doesn't work in VICE"
**Fix:** In VICE: Settings → Input devices → Control port settings → Set Port 2 to "Keyboard"

### "No sound"
**Fix:** In VICE: Settings → Sound settings → Check "Enable sound playback"

### "Build fails"
**Fix:** Make sure you're in the project directory and have Java installed:
```bash
java -version   # Should show Java version
./build.sh      # Try building manually
```

---

## 📂 Files You Should Know About

| File | What It Does |
|------|--------------|
| `src/main.asm` | Main game code - start here to understand the code |
| `build/depthcharge.prg` | Compiled game (created when you build) |
| `.vscode/tasks.json` | Build automation config |
| `.vscode/launch.json` | VICE launcher config (edit VICE path here) |
| `build.sh` | Build script (edit KickAssembler path here) |

---

## 📚 Next Steps

### After You Get It Running

1. **Read the code:**
   - Start with `src/main.asm` to see the game loop
   - Check `src/player.asm` to see how controls work
   - Look at `src/enemies.asm` for AI behavior

2. **Make changes:**
   - Edit any `.asm` file
   - Press `Ctrl+Shift+B` to rebuild
   - Press `F5` to test your changes

3. **Experiment:**
   - Adjust player speed in `player.asm`
   - Change enemy spawn rates in `enemies.asm`
   - Modify colors in `main.asm`
   - Add new sound effects in `sound.asm`

### Learn More

- [VSCODE-SETUP.md](VSCODE-SETUP.md) - Full detailed guide
- [BUILDING.md](BUILDING.md) - Build system details
- [README.md](README.md) - Game features and specs
- [IMPLEMENTATION.md](IMPLEMENTATION.md) - Code architecture

---

## 🎓 Summary

**You asked:** How do I test this game in VS Code with KickAssembler and VICE?

**We provided:**
1. ✅ Complete VS Code setup guide (VSCODE-SETUP.md)
2. ✅ Quick start guide (QUICKSTART.md)
3. ✅ VS Code configuration files (.vscode/)
4. ✅ Build automation (Ctrl+Shift+B)
5. ✅ VICE integration (F5 to launch)
6. ✅ Troubleshooting help

**You need to do:**
1. Clone repository
2. Edit one line in `.vscode/launch.json` (VICE path)
3. Press Ctrl+Shift+B
4. Press F5
5. Play!

---

## ❓ Still Have Questions?

- Check [VSCODE-SETUP.md](VSCODE-SETUP.md) for detailed troubleshooting
- Check [BUILDING.md](BUILDING.md) for build system details
- Open an issue on GitHub if you're stuck

---

**Ready to play? Start with [QUICKSTART.md](QUICKSTART.md)!** 🎮
