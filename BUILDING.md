# Build and Testing Notes

## Build Requirements

This project requires **KickAssembler** to compile. KickAssembler is a cross-platform 6502 assembler written in Java.

### Installing KickAssembler

1. Download KickAssembler from: http://www.theweb.dk/KickAssembler/
2. Extract `KickAss.jar` to your system
3. Ensure Java Runtime Environment (JRE) is installed

### Building the Project

Once KickAssembler is installed, you can build using:

```bash
# Using the build script
./build.sh

# Using Make
make

# Manual build
java -jar /path/to/KickAss.jar src/main.asm -o build/depthcharge.prg
```

## Testing

### Automated Testing

Due to the specialized nature of C64 development, automated testing requires:
- KickAssembler for compilation
- VICE emulator for runtime testing
- Custom test harness for C64 programs

These tools are not typically available in standard CI environments.

### Manual Testing

To test the game:

1. Build the .prg file using KickAssembler
2. Load in VICE emulator: `x64 build/depthcharge.prg`
3. Test gameplay features:
   - Player movement (joystick port 2)
   - Torpedo firing (fire button)
   - Enemy spawning and AI
   - Collision detection
   - HUD display (score, lives, oxygen)
   - Level progression
   - Sound effects and music

### Testing Checklist

- [ ] Game compiles without errors
- [ ] Program loads and runs in VICE
- [ ] Title screen displays correctly
- [ ] Player submarine appears and responds to joystick
- [ ] Torpedoes fire and move correctly
- [ ] Enemies spawn and move
- [ ] Collisions are detected
- [ ] Score increases when enemies destroyed
- [ ] Oxygen depletes and regenerates
- [ ] Lives system works (damage and respawn)
- [ ] Level complete transition works
- [ ] Game over screen displays
- [ ] Sound effects play
- [ ] Background music plays
- [ ] No crashes or freezes during gameplay

## Known Limitations

As this is a demonstration/example C64 game:

1. **No unit tests** - Assembly code testing requires specialized frameworks
2. **No CI/CD compilation** - Requires KickAssembler (Java) and is platform-specific
3. **Manual verification required** - Must be tested in emulator or real hardware
4. **Emulator-specific features** - Some features may behave differently on real hardware vs emulators

## Verification in CI

Since automated compilation and testing is not feasible in standard CI:

- Code structure and syntax follow KickAssembler conventions
- Memory map is documented and within C64 constraints
- All game modules are included and properly referenced
- Build scripts are provided for manual compilation
- Comprehensive documentation is included

For actual compilation and testing, developers should:
1. Clone the repository
2. Install KickAssembler locally
3. Build and test in VICE emulator
4. Report any issues found

## Development Environment Setup

Recommended setup for C64 development:

1. **Assembler**: KickAssembler (Java-based, cross-platform)
2. **Emulator**: VICE (most accurate C64 emulator)
3. **Editor**: Any text editor with 6502 syntax highlighting
4. **Debugger**: VICE built-in monitor (invoked with Alt+H)
5. **Tools**: 
   - SpritePad (sprite editor)
   - CharPad (character set editor)
   - GoatTracker (SID music editor)

## Contributing

When contributing to this project:

1. Ensure code follows KickAssembler syntax
2. Test changes in VICE emulator
3. Document any new features or changes
4. Maintain compatibility with PAL C64 (50Hz)
5. Keep memory usage within defined map
6. Preserve existing functionality
