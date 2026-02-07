# Makefile for Depth Charge

# Assembler
KICKASS = java -jar KickAss.jar

# Directories
SRC_DIR = src
BUILD_DIR = build

# Main source file
MAIN_SRC = $(SRC_DIR)/main.asm

# Output file
OUTPUT = $(BUILD_DIR)/depthcharge.prg

# Default target
all: $(OUTPUT)

# Build the .prg file
$(OUTPUT): $(MAIN_SRC) $(wildcard $(SRC_DIR)/*.asm)
	@echo "Building Depth Charge..."
	@mkdir -p $(BUILD_DIR)
	$(KICKASS) $(MAIN_SRC) -o $(OUTPUT) -showmem
	@echo "Build complete: $(OUTPUT)"

# Clean build artifacts
clean:
	@echo "Cleaning build directory..."
	@rm -rf $(BUILD_DIR)
	@echo "Clean complete."

# Run in VICE emulator (x64)
run: $(OUTPUT)
	@echo "Running in VICE emulator..."
	x64 $(OUTPUT)

# Run in VICE emulator (x64sc - cycle accurate)
run-accurate: $(OUTPUT)
	@echo "Running in VICE emulator (cycle accurate)..."
	x64sc $(OUTPUT)

.PHONY: all clean run run-accurate
