# DEPTH CHARGE

**A Commodore 64 Submarine Warfare Side-Scroller**

![Version](https://img.shields.io/badge/version-1.0-blue)
![Platform](https://img.shields.io/badge/platform-Commodore%2064-green)
![Language](https://img.shields.io/badge/language-6502%20Assembly-red)

---

## ⚠️ IMPORTANT: Only Seeing README.md?

**The complete game code is on the `copilot/implement-depth-charge-game` branch!**

If you just cloned the repository and only see this README, you need to switch branches:

```bash
git checkout copilot/implement-depth-charge-game
```

Or clone directly to the correct branch:

```bash
git clone -b copilot/implement-depth-charge-game https://github.com/PaoloSupernova/Depth-Charge.git
```

**📖 Full explanation:** See [BRANCH-INFO.md](BRANCH-INFO.md) for details about why the code is on a feature branch.

---

## 🎮 About

**DEPTH CHARGE** is a complete, playable submarine warfare side-scroller written in 6502 assembly language for the Commodore 64. Inspired by classic 8-bit games like *Harrier Attack!*, you pilot a military submarine through hostile waters, battling enemy vessels, avoiding mines, and surviving intense boss encounters.

Navigate your submarine through 8 progressively challenging levels filled with surface ships, enemy submarines, aircraft, mines, and powerful end-of-level bosses. Manage your oxygen supply as you dive deep or surface for air, all while dodging enemy fire and launching torpedoes at anything that moves!

---

## ✨ Features

### Gameplay
- **8-directional movement** using joystick in Port 2
- **Smooth horizontal scrolling** with hardware-accelerated pixel-perfect movement
- **Torpedo combat system** - Fire up to 2 torpedoes simultaneously
- **Oxygen management** - Deplete oxygen underwater, regenerate at the surface
- **Multiple enemy types**:
  - Surface ships dropping depth charges
  - Enemy submarines with sine-wave movement patterns
  - Floating mines with bob animation
  - Aircraft dropping torpedoes
  - End-of-level bosses with unique attack patterns
- **8 challenging levels** with increasing difficulty
- **Lives system** with brief invincibility after taking damage
- **Score tracking** with BCD arithmetic

### Technical Features
- Written in **6502 assembly language** using KickAssembler syntax
- **Sprite multiplexing** for displaying more than 8 sprites
- **Custom sprite graphics** for player, enemies, and projectiles
- **SID chip music** with underwater ambience and military march themes
- **Sound effects library** including torpedo launch, explosions, and warnings
- **Optimized game loop** running at 50fps (PAL) / 60fps (NTSC)
- **Collision detection** using VIC-II hardware registers with software refinement
- **Memory-efficient design** fitting within 64KB RAM

### Graphics
- **Multicolor sprites** for detailed submarine and enemy graphics
- **Character-based backgrounds** with water gradient and terrain
- **HUD display** showing score, lives, oxygen meter, and level info
- **Smooth scrolling** using VIC-II hardware registers
- **Animation system** for sprite propellers, explosions, and water effects

### Audio
- **SID chip music** with 3-voice composition:
  - Voice 1: Deep bass rumble (sawtooth wave)
  - Voice 2: Melody line (pulse wave)
  - Voice 3: Atmospheric effects (triangle wave) / sound effects
- **Sound effects**:
  - Torpedo launch (noise sweep)
  - Explosions (noise with decay)
  - Player hit (warbling noise)
  - Oxygen warning (pulse beeps)
  - Power-up collection (arpeggio)

---

## 📋 Game Mechanics

### Controls
| Input | Action |
|-------|--------|
| **Joystick Port 2** | 8-directional movement |
| **Fire Button** | Launch torpedo |
| **RUN/STOP** | Pause game |

### Scoring System
| Target | Points |
|--------|--------|
| Surface Ship | 100 |
| Enemy Submarine | 150 |
| Mine (destroyed) | 50 |
| Aircraft | 200 |
| Boss | 1000 |

### Game Flow
1. **Title Screen** - Press fire to start
2. **Level Play** - Navigate, fight, and survive
3. **Level Complete** - Advance to next level
4. **Game Over** - Final score display, press fire to return to title

### Difficulty Progression
Each level increases in:
- Scroll speed (slow → medium → fast)
- Enemy spawn density
- New enemy types introduced
- Boss difficulty and attack patterns

After completing Level 8, the game loops with increased difficulty.

---

## 🛠️ Building the Game

### 🚀 Quick Start for VS Code Users

**Using VS Code with KickAssembler and VICE?** See our detailed guide:

📖 **[VS Code Setup Guide (VSCODE-SETUP.md)](VSCODE-SETUP.md)** - Complete walkthrough  
⚡ **[Quick Start (QUICKSTART.md)](QUICKSTART.md)** - Get running in 5 minutes

The guide includes:
- Step-by-step VS Code configuration
- Build automation with keyboard shortcuts (Ctrl+Shift+B)
- One-click launch in VICE (F5)
- Debugging tips and troubleshooting
- **Windows-native build support** (PowerShell/CMD - no bash needed!)

### Prerequisites
- **KickAssembler** (KickAss.jar) - Download from [www.theweb.dk/KickAssembler](http://www.theweb.dk/KickAssembler/)
- **Java Runtime Environment** (JRE) - To run KickAssembler
- **Make** (optional, Linux/macOS) - For using the Makefile

### Quick Build

#### Linux/macOS:
```bash
./build.sh
```

#### Windows PowerShell:
```powershell
.\build.ps1
```

#### Windows CMD:
```cmd
build.bat
```

#### Using Make (Linux/macOS):
```bash
make
```

#### Manual build (all platforms):
```bash
java -jar KickAss.jar src/main.asm -o build/depthcharge.prg
```

**Windows users:** See [WINDOWS-TROUBLESHOOTING.md](WINDOWS-TROUBLESHOOTING.md) if you encounter issues.

### Build Output
The build process generates:
- `build/depthcharge.prg` - The compiled C64 program file

---

## 🎯 Running the Game

### VICE Emulator (Recommended)

VICE is the most accurate C64 emulator. Download from [vice-emu.sourceforge.io](http://vice-emu.sourceforge.io/)

#### Command line:
```bash
x64 build/depthcharge.prg
```

#### Or with cycle-accurate emulation:
```bash
x64sc build/depthcharge.prg
```

#### From VICE GUI:
1. Launch VICE (x64 or x64sc)
2. File → Autostart disk/tape image...
3. Select `build/depthcharge.prg`
4. Game starts automatically

### Real C64 Hardware

#### Loading from SD2IEC or other device:
```
LOAD "DEPTHCHARGE.PRG",8,1
RUN
```

Or simply:
```
LOAD "DEPTHCHARGE.PRG",8,1
```
(The program auto-starts)

#### Loading from tape:
```
LOAD
[Press PLAY on tape]
RUN
```

### Joystick Configuration
- Ensure joystick is plugged into **Port 2** (the right port)
- In VICE: Settings → Input devices → Control port settings
  - Set Control Port 2 to your input device

---

## 📂 Project Structure

```
Depth-Charge/
├── src/
│   ├── main.asm       # Entry point, game loop, state machine
│   ├── player.asm     # Player movement, shooting, collision
│   ├── enemies.asm    # Enemy AI, spawning, behavior patterns
│   ├── scroll.asm     # Scrolling engine, level loading
│   ├── sprites.asm    # Sprite data and animation system
│   ├── sound.asm      # SID music player and sound effects
│   ├── graphics.asm   # Drawing routines, HUD updates
│   └── data.asm       # Data includes and references
├── build/
│   └── depthcharge.prg  # Compiled game (generated)
├── build.sh           # Build script
├── Makefile           # Make build configuration
└── README.md          # This file
```

---

## 🧮 Technical Specifications

### Memory Map
```
$0801-$0FFF   BASIC stub + main game code
$1000-$1FFF   Game logic, enemy AI, collision routines
$2000-$3FFF   Character set (custom 256 chars for tiles)
$4000-$47FF   Screen RAM
$4800-$4FFF   Sprite data (21 sprites × 64 bytes)
$5000-$5FFF   Level data (tile maps, spawn tables)
$6000-$7FFF   Music data (SID player + patterns)
$C000-$CFFF   Scroll buffer and working RAM
$D000-$DFFF   I/O (VIC-II, SID, CIA) - memory mapped
```

### VIC-II Configuration
- Screen memory: $4000
- Character set: $2000 (custom)
- Sprites: 0-7 enabled, multicolor mode
- Smooth scrolling: Hardware register $D016
- Border: Black ($00)
- Background: Dark blue ($06) - deep water theme

### Sprite Allocation
```
Sprite 0:     Player submarine (multicolor, animated)
Sprite 1-2:   Player torpedoes
Sprite 3-7:   Enemies and projectiles
```

### SID Configuration
- Voice 1: Bass/rumble (sawtooth)
- Voice 2: Melody (pulse with PWM)
- Voice 3: Atmosphere/SFX (triangle/noise)
- Filter: Low-pass for underwater effect
- Volume: Maximum ($0F)

---

## 🎨 Color Palette

| Element | Colors |
|---------|--------|
| Background (water) | Dark Blue ($06) |
| Player submarine | Grey ($0C), Dark Grey ($0B), Yellow ($07) |
| Surface ships | Green ($05), Dark Green ($0D) |
| Enemy subs | Red ($02), Brown ($09) |
| Mines | Black ($00), Yellow ($07) |
| Aircraft | White ($01), Light Grey ($0F) |
| HUD | White ($01), Yellow ($07) |

---

## 🐛 Known Issues & Limitations

1. **Sprite multiplexing not fully implemented** - Limited to 8 on-screen sprites currently
2. **Level data is procedurally generated** - No pre-designed level maps yet
3. **Boss AI simplified** - Basic movement patterns, no complex phases
4. **No high score persistence** - Scores reset when restarting
5. **Pause function incomplete** - RUN/STOP key scanning not implemented
6. **Character set uses default** - Custom underwater tiles not loaded

These are areas for future enhancement!

---

## 🚀 Future Enhancements

- [ ] Full sprite multiplexer for 20+ simultaneous enemies
- [ ] Pre-designed level maps with terrain variation
- [ ] Complex boss patterns with multiple phases
- [ ] High score table with persistence (save to disk/tape)
- [ ] Custom character set for water effects and terrain
- [ ] Parallax scrolling background layers
- [ ] Power-ups (shields, rapid fire, speed boost)
- [ ] Two-player cooperative mode
- [ ] Demo mode / attract screen animation
- [ ] Configurable difficulty settings

---

## 🎓 Development Notes

### Assembly Techniques Used
- **Zero page variables** for fast access to game state
- **Unrolled loops** for sprite updates and scrolling
- **BCD arithmetic** for score display
- **Indexed addressing** for sprite and enemy arrays
- **Bit manipulation** for collision detection and flags
- **Lookup tables** for sine waves and music notes

### Performance Optimizations
- Critical game loop synchronized to raster line 251
- Sprite positions updated once per frame
- Collision detection uses hardware registers first
- Music/SFX use separate voices to avoid conflicts
- Screen scrolling uses hardware fine scroll + coarse software shift

### KickAssembler Features
- `#import` for modular code organization
- `.const` for readable constants
- `.var` for memory-mapped variables
- `.byte` / `.text` for data definition
- `BasicUpstart()` macro for auto-starting programs

---

## 📚 Resources & References

### Commodore 64 Documentation
- [C64 Wiki](https://www.c64-wiki.com/) - Comprehensive C64 information
- [Codebase64](https://codebase64.org/) - C64 coding tutorials and examples
- [6502.org](http://6502.org/) - 6502 processor reference

### Development Tools
- [KickAssembler](http://www.theweb.dk/KickAssembler/) - Cross-platform 6502 assembler
- [VICE Emulator](http://vice-emu.sourceforge.io/) - Versatile Commodore Emulator
- [SpritePad](https://csdb.dk/release/?id=132081) - C64 sprite editor
- [CharPad](https://subchristsoftware.itch.io/charpad-free-edition) - Character set editor

### Learning 6502 Assembly
- [Easy 6502](https://skilldrick.github.io/easy6502/) - Interactive tutorial
- [6502 Assembly Language Programming](https://archive.org/details/6502_Assembly_Language_Programming) - Classic book
- [Retro Game Mechanics Explained](https://www.youtube.com/c/RetroGameMechanicsExplained) - Video tutorials

---

## 📄 License

This project is released as **public domain** / **CC0**. Feel free to use, modify, and distribute as you wish.

The game is created as a learning example and tribute to classic 8-bit gaming. No commercial use intended.

---

## 🙏 Acknowledgments

- Inspired by classic C64 games: *Harrier Attack!*, *Scramble*, *Defender*
- Thanks to the C64 community for decades of documentation and tools
- Built with love for retro gaming and 6502 assembly programming

---

## 👨‍💻 Author

Created as a demonstration of Commodore 64 game development using 6502 assembly language and KickAssembler.

---

## 🎮 Happy Gaming!

**"Dive deep, fight hard, surface victorious!"**

---

*For questions, issues, or contributions, please open an issue on the GitHub repository.*