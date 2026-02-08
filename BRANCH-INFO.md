# ⚠️ IMPORTANT: Branch Information

## Are You Seeing Only README.md?

If you just cloned this repository and only see a README.md file, **you're on the wrong branch!**

The complete game implementation is on the **`copilot/implement-depth-charge-game`** branch.

---

## How to Get the Full Code

### Option 1: Switch to the Feature Branch (Recommended)

After cloning, run:

```bash
git checkout copilot/implement-depth-charge-game
```

Or clone directly to the feature branch:

```bash
git clone -b copilot/implement-depth-charge-game https://github.com/PaoloSupernova/Depth-Charge.git
```

### Option 2: View the Pull Request

The implementation is in Pull Request #X. You can:
1. Review the PR on GitHub
2. Wait for it to be merged to `main`
3. Then clone/pull the `main` branch

---

## What You'll Get

Once you're on the correct branch, you'll see:

```
Depth-Charge/
├── src/                    # 8 assembly source files (2,600+ lines)
│   ├── main.asm
│   ├── player.asm
│   ├── enemies.asm
│   ├── scroll.asm
│   ├── sprites.asm
│   ├── sound.asm
│   ├── graphics.asm
│   └── data.asm
├── .vscode/                # VS Code configuration
│   ├── tasks.json
│   ├── launch.json
│   └── extensions.json
├── build.sh                # Build script
├── Makefile                # Build automation
├── README.md               # Main documentation
├── QUICKSTART.md           # 5-minute setup guide
├── VSCODE-SETUP.md         # Complete VS Code guide
├── CHECKLIST.md            # Setup checklist
├── HOW-TO-START.md         # Getting started guide
├── BUILDING.md             # Build instructions
└── IMPLEMENTATION.md       # Implementation details
```

---

## Quick Start (After Switching Branches)

```bash
# 1. Make sure you're on the right branch
git checkout copilot/implement-depth-charge-game

# 2. Verify you have all files
ls -la src/

# 3. Follow the setup guide
# See QUICKSTART.md or VSCODE-SETUP.md
```

---

## Why Is This Happening?

The complete game implementation was created on a feature branch and has not yet been merged to the `main` branch. This is normal for Pull Request workflows - the code is reviewed before being merged to main.

---

## Need Help?

1. **If you just want to play/test the game:**
   - Switch to `copilot/implement-depth-charge-game` branch
   - Follow [QUICKSTART.md](QUICKSTART.md)

2. **If you're a repository maintainer:**
   - Review and merge the Pull Request
   - Then users can use `main` branch directly

3. **If files still don't appear:**
   - Run: `git fetch --all`
   - Then: `git checkout copilot/implement-depth-charge-game`
   - Verify: `git branch` (should show a * next to copilot/implement-depth-charge-game)

---

## Branch Status

- ✅ **`copilot/implement-depth-charge-game`** - Complete implementation (3,000+ lines of code)
- 📝 **`main`** - Initial repository (README.md only)

**Current Status:** PR is open and ready for review/merge

---

For more information, see the [Pull Request](https://github.com/PaoloSupernova/Depth-Charge/pulls) or check the documentation files after switching to the feature branch.
