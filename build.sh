#!/bin/bash
# Build script for Depth Charge

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Building Depth Charge...${NC}"

# Create build directory if it doesn't exist
mkdir -p build

# Check if KickAssembler is available
if [ ! -f "KickAss.jar" ]; then
    echo -e "${YELLOW}KickAssembler not found in current directory.${NC}"
    echo -e "${YELLOW}Attempting to build with java -jar KickAss.jar...${NC}"
    echo -e "${YELLOW}Please ensure KickAss.jar is in your PATH or current directory.${NC}"
    KICKASS="java -jar KickAss.jar"
else
    KICKASS="java -jar ./KickAss.jar"
fi

# Assemble the main file
echo -e "${YELLOW}Assembling main.asm...${NC}"
$KICKASS src/main.asm -o build/depthcharge.prg -showmem 2>&1

# Check if build was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Build successful!${NC}"
    echo -e "${GREEN}Output: build/depthcharge.prg${NC}"
    
    # Show file size
    if [ -f "build/depthcharge.prg" ]; then
        SIZE=$(stat -f%z "build/depthcharge.prg" 2>/dev/null || stat -c%s "build/depthcharge.prg" 2>/dev/null)
        echo -e "${GREEN}File size: $SIZE bytes${NC}"
    fi
else
    echo -e "${RED}Build failed!${NC}"
    exit 1
fi
