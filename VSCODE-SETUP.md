# VS Code Setup Guide for Depth Charge

This guide will help you set up, build, and test the Depth Charge C64 game in Visual Studio Code with KickAssembler and VICE emulator.

## ⚠️ CRITICAL: Check Your Branch First!

**Before you proceed, make sure you're on the correct branch!**

The complete game implementation is on the **`copilot/implement-depth-charge-game`** branch. If you only see README.md, you're on the wrong branch.

### Fix It Now:
```bash
# Check current branch
git branch

# If not on copilot/implement-depth-charge-game, switch to it:
git checkout copilot/implement-depth-charge-game

# Verify files are present
ls -la src/
```

**For full branch details, see [BRANCH-INFO.md](BRANCH-INFO.md)**

---

## Prerequisites

Before you begin, ensure you have:

- ✅ **Visual Studio Code** installed
- ✅ **KickAssembler** (KickAss.jar) installed and configured
- ✅ **VICE emulator** (x64 or x64sc) installed
- ✅ **Java Runtime Environment** (JRE) for KickAssembler
- ✅ **Git** for cloning the repository

---

## Step 1: Clone the Repository

Open a terminal in VS Code (`` Ctrl+` `` or `Cmd+` `` on Mac) and run:

```bash
# Clone with the correct branch
git clone -b copilot/implement-depth-charge-game https://github.com/PaoloSupernova/Depth-Charge.git
cd Depth-Charge
```

Or use VS Code's built-in Git:
1. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
2. Type "Git: Clone"
3. Enter the repository URL: `https://github.com/PaoloSupernova/Depth-Charge.git`
4. Choose a local folder
5. Click "Open" when prompted

---

## Step 2: Open in VS Code

If not already open:

```bash
code .
```

Or:
1. Open VS Code
2. File → Open Folder
3. Select the `Depth-Charge` folder

---

## Step 3: Configure KickAssembler Path

You need to tell VS Code where your KickAssembler is located.

### Option A: Using Environment Variable (Recommended)

Add KickAssembler to your system PATH or create an environment variable:

**Windows:**
```cmd
setx KICKASS_JAR "C:\path\to\KickAss.jar"
```

**macOS/Linux:**
Add to your `~/.bashrc` or `~/.zshrc`:
```bash
export KICKASS_JAR="/path/to/KickAss.jar"
```

### Option B: Edit Build Files

If you prefer not to use environment variables, you can modify the build scripts:

**Edit `build.sh` (lines 10-16):**
```bash
# Update the path to your KickAss.jar location
KICKASS="java -jar /your/path/to/KickAss.jar"
```

**Edit `Makefile` (line 4):**
```makefile
KICKASS = java -jar /your/path/to/KickAss.jar
```

---

## Step 4: Set Up VS Code Tasks (Build Automation)

Create a `.vscode` folder in the project root and add `tasks.json`:

1. Create the folder:
   ```bash
   mkdir .vscode
   ```

2. The repository includes a pre-configured `tasks.json` file (see below)

This allows you to:
- Build with `Ctrl+Shift+B` (Windows/Linux) or `Cmd+Shift+B` (Mac)
- Run tasks from the command palette

---

## Step 5: Set Up VICE Launch Configuration

The repository includes a `launch.json` file for running the game directly from VS Code.

**Configure your VICE path:**

Edit `.vscode/launch.json` and update the `program` path to point to your VICE executable:

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

---

## Step 6: Build the Game

### Method 1: VS Code Build Task (Recommended)

1. Press `Ctrl+Shift+B` (or `Cmd+Shift+B` on Mac)
2. Select "Build Depth Charge"
3. Check the terminal output for success

### Method 2: Terminal Command

Open terminal in VS Code and run:

```bash
# Using build script
./build.sh

# Or using Make
make
```

### Method 3: Manual Build

```bash
java -jar /path/to/KickAss.jar src/main.asm -o build/depthcharge.prg
```

**Expected Output:**
```
Building Depth Charge...
Assembling main.asm...
Build successful!
Output: build/depthcharge.prg
File size: XXXX bytes
```

---

## Step 7: Run the Game in VICE

### Method 1: VS Code Launch (Recommended)

1. Press `F5` or click the "Run and Debug" icon in the sidebar
2. Select "Launch Depth Charge in VICE"
3. The game will open in VICE automatically

### Method 2: Command Line

```bash
# Using the configured path
x64sc build/depthcharge.prg

# Or with full path
/path/to/vice/x64sc build/depthcharge.prg
```

### Method 3: VICE GUI

1. Open VICE (x64 or x64sc)
2. File → Autostart disk/tape image...
3. Navigate to `build/depthcharge.prg`
4. Select and open

---

## Step 8: Test the Game

Once the game loads in VICE:

### Controls

| Action | Control |
|--------|---------|
| **Movement** | Joystick Port 2 (arrow keys by default in VICE) |
| **Fire Torpedo** | Joystick Fire Button (usually Space or Ctrl) |
| **Pause** | RUN/STOP key |

### Configure VICE Joystick

If arrow keys don't work:

1. In VICE: Settings → Input devices → Control port settings
2. Set "Control Port 2" to "Keyboard (Numpad)"
3. Now use:
   - Numpad arrows for movement
   - Numpad 0 for fire

Or set to "Keyboard" for:
   - Arrow keys for movement
   - Space or Right Ctrl for fire

### Testing Checklist

Test these features:

- [ ] Title screen appears with "DEPTH CHARGE" text
- [ ] Press fire to start game
- [ ] Player submarine appears and moves in 8 directions
- [ ] Fire button launches torpedoes (max 2 on screen)
- [ ] Enemies spawn and move (ships, submarines, mines)
- [ ] Torpedoes destroy enemies on collision
- [ ] Score increases when enemies are destroyed
- [ ] Oxygen bar depletes underwater
- [ ] Oxygen regenerates when near surface
- [ ] Player takes damage when hit by enemies
- [ ] Lives decrease and invincibility activates
- [ ] Game over screen appears when lives reach 0
- [ ] Sound effects play (torpedo launch, explosions)
- [ ] Background music plays

---

## Step 9: Debugging Tips

### Using VICE Monitor

The VICE emulator has a built-in debugger/monitor:

1. In VICE, press `Alt+H` to open the monitor
2. Useful commands:
   - `r` - Show registers
   - `d $0801` - Disassemble from address
   - `m $C000` - View memory
   - `break $0801` - Set breakpoint
   - `x` - Exit monitor and continue

### VS Code Debugging

While VS Code doesn't directly debug C64 assembly, you can:

1. Add `printf` debugging by writing to screen memory
2. Use VICE's monitor window (opened with Alt+H)
3. Check memory locations in VICE: Monitor → Memory

### Common Issues

**Issue: "Build failed - KickAssembler not found"**
- Solution: Check your KICKASS_JAR path or edit build.sh/Makefile

**Issue: "VICE doesn't start"**
- Solution: Update the path in `.vscode/launch.json`

**Issue: "Game freezes on title screen"**
- Solution: Make sure joystick is configured in VICE (Control Port 2)

**Issue: "No sound"**
- Solution: Check VICE audio settings: Settings → Sound settings → Enable sound playback

**Issue: "Compilation errors about undefined labels"**
- Solution: Make sure all .asm files are in the `src/` directory

---

## Step 10: Making Changes and Rebuilding

### Edit Source Files

1. Open any `.asm` file in the `src/` folder
2. Make your changes
3. Save the file (`Ctrl+S` or `Cmd+S`)

### Rebuild

1. Press `Ctrl+Shift+B` (or `Cmd+Shift+B`)
2. Or run `./build.sh` in terminal

### Test Changes

1. Press `F5` to launch in VICE
2. Or manually load the new `build/depthcharge.prg`

---

## Quick Reference

### VS Code Keyboard Shortcuts

| Action | Windows/Linux | macOS |
|--------|--------------|-------|
| Build | `Ctrl+Shift+B` | `Cmd+Shift+B` |
| Run/Debug | `F5` | `F5` |
| Open Terminal | ``Ctrl+` `` | ``Cmd+` `` |
| Command Palette | `Ctrl+Shift+P` | `Cmd+Shift+P` |
| Save | `Ctrl+S` | `Cmd+S` |

### Build Commands

```bash
# Quick build
./build.sh

# Build with Make
make

# Clean build artifacts
make clean

# Build and run in VICE
make run
```

### Useful VICE Commands

```bash
# Run with specific VICE version
x64 build/depthcharge.prg          # Fast emulation
x64sc build/depthcharge.prg        # Cycle-accurate (slower)

# Run with specific options
x64sc -autostart build/depthcharge.prg -sounddev pulse
```

---

## Recommended VS Code Extensions

While not required, these extensions enhance C64 development:

1. **ASM Code Lens** - 6502 assembly syntax highlighting
2. **Kick Assembler** - KickAssembler syntax support
3. **C64 Debugger** - Enhanced C64 development tools
4. **Better Comments** - Colorize assembly comments

Install via:
1. `Ctrl+Shift+X` to open Extensions
2. Search for extension name
3. Click Install

---

## Project Structure

```
Depth-Charge/
├── src/                    # Source code
│   ├── main.asm           # Entry point and game loop
│   ├── player.asm         # Player controls
│   ├── enemies.asm        # Enemy AI
│   ├── scroll.asm         # Scrolling engine
│   ├── sprites.asm        # Sprite data
│   ├── sound.asm          # SID music/sound
│   ├── graphics.asm       # Graphics and HUD
│   └── data.asm           # Game data
├── build/                 # Compiled output (generated)
│   └── depthcharge.prg   # C64 program file
├── .vscode/              # VS Code configuration
│   ├── tasks.json        # Build tasks
│   └── launch.json       # Run/debug config
├── build.sh              # Build script
├── Makefile              # Make configuration
├── README.md             # Main documentation
├── BUILDING.md           # Build instructions
└── VSCODE-SETUP.md       # This file
```

---

## Need Help?

### Documentation

- **README.md** - Game features, controls, technical specs
- **BUILDING.md** - General build instructions
- **IMPLEMENTATION.md** - Code architecture and statistics

### Resources

- [KickAssembler Documentation](http://www.theweb.dk/KickAssembler/Main.html)
- [VICE Emulator Manual](http://vice-emu.sourceforge.net/vice_toc.html)
- [C64 Wiki](https://www.c64-wiki.com/)
- [Codebase64](https://codebase64.org/) - C64 programming tutorials

### Troubleshooting

If you encounter issues:

1. Check that all prerequisites are installed
2. Verify paths in configuration files
3. Review the terminal output for error messages
4. Check the BUILDING.md for known limitations
5. Open an issue on the GitHub repository

---

## Advanced: VS Code Tasks Overview

The included `tasks.json` provides these tasks:

1. **Build Depth Charge** - Compiles the game
2. **Clean Build** - Removes build artifacts
3. **Build and Run** - Compiles and launches in VICE
4. **Show Memory Usage** - Displays memory map

Access via:
- `Ctrl+Shift+B` for default build
- `Ctrl+Shift+P` → "Tasks: Run Task" for all tasks

---

## Summary: Quick Start

```bash
# 1. Clone
git clone https://github.com/PaoloSupernova/Depth-Charge.git
cd Depth-Charge

# 2. Open in VS Code
code .

# 3. Configure paths in .vscode/launch.json

# 4. Build (Ctrl+Shift+B)
./build.sh

# 5. Run (F5 or manually)
x64sc build/depthcharge.prg
```

**That's it! Happy C64 game development! 🎮**
