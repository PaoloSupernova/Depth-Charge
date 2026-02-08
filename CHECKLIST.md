# Setup Checklist for VS Code + KickAssembler + VICE

## ⚠️ BRANCH CHECK - START HERE!

**CRITICAL FIRST STEP:**
- [ ] **Verify you're on the `copilot/implement-depth-charge-game` branch**
  - Run: `git branch` (should show a * next to copilot/implement-depth-charge-game)
  - If not, run: `git checkout copilot/implement-depth-charge-game`
  - **If you only see README.md, you MUST switch branches!**

See [BRANCH-INFO.md](BRANCH-INFO.md) for details.

---

## ✅ Prerequisites Check

Before you start, make sure you have:

- [ ] **VS Code** installed
- [ ] **KickAssembler** (KickAss.jar) downloaded and you know its location
- [ ] **VICE emulator** (x64 or x64sc) installed and you know its location
- [ ] **Java** installed (check with `java -version`)
- [ ] **Git** installed (to clone the repository)

Missing something? See [VSCODE-SETUP.md](VSCODE-SETUP.md) for download links.

---

## 📝 Setup Steps

### 1. Get the Repository
- [ ] Open terminal/command prompt
- [ ] Run: `git clone -b copilot/implement-depth-charge-game https://github.com/PaoloSupernova/Depth-Charge.git`
- [ ] Run: `cd Depth-Charge`
- [ ] Run: `code .` (opens in VS Code)
- [ ] **VERIFY:** Run `ls -la src/` - you should see 8 .asm files

### 2. Configure VICE Path
- [ ] In VS Code, open file: `.vscode/launch.json`
- [ ] Find the line with `"program":`
- [ ] Update it with your VICE path:
  - Windows: `"program": "C:\\Program Files\\VICE\\x64sc.exe"`
  - macOS: `"program": "/Applications/Vice/x64sc.app/Contents/MacOS/x64sc"`
  - Linux: `"program": "/usr/bin/x64sc"`
- [ ] Save the file (`Ctrl+S` or `Cmd+S`)

### 3. (Optional) Configure KickAssembler Path
If build fails with "KickAssembler not found":
- [ ] Open file: `build.sh`
- [ ] Find line 15-16 (the KICKASS= line)
- [ ] Update path: `KICKASS="java -jar /your/path/to/KickAss.jar"`
- [ ] Save the file

OR set environment variable:
- [ ] Windows: `setx KICKASS_JAR "C:\path\to\KickAss.jar"`
- [ ] macOS/Linux: Add to `~/.bashrc`: `export KICKASS_JAR="/path/to/KickAss.jar"`

### 4. Build the Game
- [ ] Press `Ctrl+Shift+B` (Windows/Linux) or `Cmd+Shift+B` (macOS)
- [ ] Wait for build to complete
- [ ] Check terminal output says "Build successful!"
- [ ] Verify file exists: `build/depthcharge.prg`

If build fails, see troubleshooting in [HOW-TO-START.md](HOW-TO-START.md)

### 5. Run in VICE
- [ ] Press `F5` in VS Code
- [ ] VICE emulator should open
- [ ] Game should load automatically
- [ ] You should see the "DEPTH CHARGE" title screen

If VICE doesn't start, double-check the path in `.vscode/launch.json`

### 6. Configure Joystick Controls (First Time)
- [ ] In VICE: Click "Settings" menu
- [ ] Select "Input devices" → "Control port settings"
- [ ] Set **Control Port 2** to "Keyboard"
- [ ] Close settings

Now you can use:
- [ ] Arrow keys to move submarine
- [ ] Space bar or Right Ctrl to fire torpedoes

### 7. Test Basic Gameplay
- [ ] Title screen appears with text
- [ ] Press fire button (Space) to start
- [ ] Submarine appears on screen
- [ ] Arrow keys move submarine in all directions
- [ ] Fire button launches torpedoes
- [ ] Torpedoes move across screen
- [ ] Background music plays

### 8. Test Advanced Features
- [ ] Enemies appear (ships, submarines, mines)
- [ ] Torpedoes destroy enemies on collision
- [ ] Score increases when enemies destroyed
- [ ] Oxygen bar shows at top right
- [ ] Oxygen depletes when underwater
- [ ] Oxygen regenerates near top of screen
- [ ] Player takes damage when hit by enemies
- [ ] Lives counter decreases when hit
- [ ] Sound effects play (torpedoes, explosions)

---

## 🎯 Quick Success Check

If you can check these boxes, you're all set:
- [ ] Repository cloned and opened in VS Code
- [ ] Build completes successfully (Ctrl+Shift+B)
- [ ] Game launches in VICE (F5)
- [ ] Can see title screen
- [ ] Can control submarine with arrow keys
- [ ] Can fire torpedoes

**All checked? You're ready to play and develop! 🎉**

---

## 🐛 Something Not Working?

### Build Issues
- Check [HOW-TO-START.md](HOW-TO-START.md) → "Common Issues & Solutions"
- Check [VSCODE-SETUP.md](VSCODE-SETUP.md) → "Debugging Tips"

### VICE Issues
- Check [HOW-TO-START.md](HOW-TO-START.md) → "VICE doesn't start"
- Check [VSCODE-SETUP.md](VSCODE-SETUP.md) → "Common Issues"

### Control Issues
- Check [QUICKSTART.md](QUICKSTART.md) → "Controls Setup"
- Check [VSCODE-SETUP.md](VSCODE-SETUP.md) → "Configure VICE Joystick"

---

## 📚 Documentation Map

Start with the right guide for your needs:

1. **Just want to run it?**
   → [QUICKSTART.md](QUICKSTART.md)

2. **Want detailed instructions?**
   → [VSCODE-SETUP.md](VSCODE-SETUP.md)

3. **Had an issue?**
   → [HOW-TO-START.md](HOW-TO-START.md)

4. **Want to understand the code?**
   → [README.md](README.md) and [IMPLEMENTATION.md](IMPLEMENTATION.md)

5. **General build info?**
   → [BUILDING.md](BUILDING.md)

---

## 🎮 Ready to Play!

Once everything is working:
- Edit code in `src/` folder
- Press `Ctrl+Shift+B` to rebuild
- Press `F5` to test changes
- Enjoy developing for the C64!

**Have fun! 🚀**
