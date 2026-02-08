@echo off
REM Batch Build Script for Depth Charge
REM Windows CMD alternative to build.sh

echo Building Depth Charge...

REM Create build directory if it doesn't exist
if not exist build mkdir build

REM Check if KickAssembler is available
set KICKASS_JAR=
if exist KickAss.jar (
    set KICKASS_JAR=KickAss.jar
    echo Found KickAss.jar in current directory
) else if defined KICKASS_JAR (
    if exist "%KICKASS_JAR%" (
        echo Using KickAss.jar from KICKASS_JAR environment variable
    ) else (
        echo KICKASS_JAR environment variable points to non-existent file
        goto :error
    )
) else (
    echo KickAssembler not found!
    echo Please ensure KickAss.jar is in the current directory
    echo Or set KICKASS_JAR environment variable to point to KickAss.jar
    goto :error
)

REM Check if Java is available
java -version >nul 2>&1
if errorlevel 1 (
    echo Java not found! Please install Java Runtime Environment (JRE)
    goto :error
)

REM Assemble the main file
echo Assembling main.asm...
java -jar "%KICKASS_JAR%" src/main.asm -o build/depthcharge.prg -showmem

REM Check if build was successful
if errorlevel 1 goto :error
if not exist build\depthcharge.prg goto :error

echo.
echo Build successful!
echo Output: build\depthcharge.prg

REM Show file size
for %%A in (build\depthcharge.prg) do echo File size: %%~zA bytes

goto :end

:error
echo.
echo Build failed!
exit /b 1

:end
