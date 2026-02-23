@echo off
REM MCP Setup for Windows - CMD/Batch Version
REM Usage: setup-windows.cmd
REM 
REM Requirements:
REM   - Node.js 18+ (install from https://nodejs.org/)
REM   - Git for Windows (includes Git Bash)
REM   - CMD or Git Bash

echo.
echo  ==========================================
echo   MCP Setup Guide - Windows (CMD/Git Bash)
echo  ==========================================
echo.

REM Check prerequisites
echo  [1/5] Checking prerequisites...
echo.

REM Check Node.js
node --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo  [X] Node.js not found!
    echo      Please install from: https://nodejs.org/
    echo      Download the LTS version and run the installer.
    exit /b 1
) else (
    for /f "tokens=*" %%a in ('node --version') do echo  [OK] Node.js %%a found
)

REM Check npx
npx --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo  [X] npx not found!
    exit /b 1
) else (
    echo  [OK] npx found
)

REM Check Git
git --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo  [!] Git not found - optional but recommended
    echo      Install from: https://git-scm.com/download/win
) else (
    for /f "tokens=*" %%a in ('git --version') do echo  [OK] %%a found
)

REM Check Claude
claude --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo  [!] Claude Code not found in PATH
    echo      Install with: npm install -g @anthropic-ai/claude-code
) else (
    echo  [OK] Claude Code found
)

echo.
echo  [2/5] Testing MCP servers...
echo.

echo  Testing @modelcontextprotocol/server-filesystem...
npx -y @modelcontextprotocol/server-filesystem --help >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo    [OK] Ready
) else (
    echo    [!] Will install on first use
)

echo  Testing @modelcontextprotocol/server-fetch...
npx -y @modelcontextprotocol/server-fetch --help >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo    [OK] Ready
) else (
    echo    [!] Will install on first use
)

echo  Testing @modelcontextprotocol/server-memory...
npx -y @modelcontextprotocol/server-memory --help >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo    [OK] Ready
) else (
    echo    [!] Will install on first use
)

echo  Testing @modelcontextprotocol/server-git...
npx -y @modelcontextprotocol/server-git --help >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo    [OK] Ready
) else (
    echo    [!] Will install on first use
)

echo.
echo  [3/5] Setting up configuration...
echo.

REM Create configs directory
if not exist "configs" mkdir configs

REM Copy secrets template
if not exist "configs\secrets.env" (
    if exist "configs\secrets.env.template" (
        copy /Y "configs\secrets.env.template" "configs\secrets.env" >nul
        echo  [OK] Created configs\secrets.env from template
        echo      IMPORTANT: Edit this file with your actual tokens!
    ) else (
        echo  [X] configs\secrets.env.template not found!
    )
) else (
    echo  [OK] configs\secrets.env already exists
)

REM Set attributes (hidden)
if exist "configs\secrets.env" (
    attrib +H configs\secrets.env 2>nul
    echo  [OK] Set secrets.env as hidden
)

echo.
echo  [4/5] Creating helper scripts...
echo.

REM Create Load-MCP-Secrets.bat for CMD
(
echo @echo off
echo REM Load MCP secrets into environment variables for current session
echo.
echo if not exist "%%~dp0..\configs\secrets.env" ^(
echo     echo [X] secrets.env not found!
echo     exit /b 1
echo ^)
echo.
echo echo Loading secrets from configs\secrets.env...
echo.
echo for /f "usebackq tokens=*" %%%%a in ^("%%~dp0..\configs\secrets.env"^) do ^(
echo     for /f "tokens=1,2 delims==" %%%%i in ^("%%%%a"^) do ^(
echo         set %%%%i=%%%%j
echo         echo Set %%%%i
echo     ^)
echo ^)
echo.
echo echo.
echo echo [OK] All secrets loaded!
echo echo Now you can start Claude with: claude
echo.
) > "scripts\Load-MCP-Secrets.bat"

echo  [OK] Created scripts\Load-MCP-Secrets.bat

echo.
echo  [5/5] Setup complete!
echo.

echo  ==========================================
echo   NEXT STEPS:
echo  ==========================================
echo.
echo  1. Edit configs\secrets.env with your tokens:
echo     notepad configs\secrets.env
echo.
echo  2. Update configs\claude-config.json:
echo     Change '/path/to/your/repos' to your actual path
echo     Example: C:/Users/%USERNAME%/Documents/Projects
echo     (Use FORWARD SLASHES: C:/ not C:\)
echo.
echo  3. Copy config to Claude:
echo     mkdir "%APPDATA%\Claude"
echo     copy configs\claude-config.json "%APPDATA%\Claude\mcp-config.json"
echo.
echo  4. Load secrets and start Claude:
echo     scripts\Load-MCP-Secrets.bat
echo     claude
echo.
echo  For Git Bash users:
echo     source scripts/load-mcp-secrets.sh
echo     claude
echo.
echo  See docs/07-windows-setup.md for detailed guide
echo.
pause
