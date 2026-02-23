# Windows Setup Guide (CMD & Git Bash)

Setup instructions for **CMD** and **Git Bash** on Windows 10/11.

For **PowerShell**, see: `docs/07-windows-setup.md` (alternative file)

---

## Quick Setup (Choose Your Shell)

### Option 1: CMD (Command Prompt)

```batch
cd C:\Users\%USERNAME%\Documents
git clone https://github.com/eng-elias-owis/mcp-setup-guide.git
cd mcp-setup-guide
scripts\setup-windows.cmd
```

### Option 2: Git Bash

```bash
cd /c/Users/$USER/Documents
git clone https://github.com/eng-elias-owis/mcp-setup-guide.git
cd mcp-setup-guide
./scripts/setup-windows.cmd   # Or use Windows CMD first, then:
```

---

## Detailed CMD Setup

### 1. Install Prerequisites

**Node.js (18+):**
- Download: https://nodejs.org/
- Run installer (include npm)
- Verify:
  ```batch
  node --version
  npm --version
  ```

**Git (includes Git Bash):**
- Download: https://git-scm.com/download/win
- Install with "Use Git from Windows Command Prompt" option
- Verify:
  ```batch
  git --version
  ```

**Claude Code:**
```batch
npm install -g @anthropic-ai/claude-code
claude --version
```

---

### 2. Clone Repository

```batch
cd C:\Users\%USERNAME%\Documents
git clone https://github.com/eng-elias-owis/mcp-setup-guide.git
cd mcp-setup-guide
```

---

### 3. Run Setup

```batch
scripts\setup-windows.cmd
```

This creates:
- `configs/secrets.env` (from template)
- `scripts/Load-MCP-Secrets.bat` (helper script)

---

### 4. Configure Secrets

```batch
notepad configs\secrets.env
```

**Fill in your values:**
```batch
# GitHub Enterprise
GITHUB_URL=https://github.your-company.com
GITHUB_TOKEN=ghp_your_token_here

# SonarQube
SONAR_URL=https://sonar.your-company.com
SONAR_TOKEN=squ_your_token_here

# JIRA
JIRA_URL=https://jira.your-company.com
JIRA_TOKEN=your_jira_token

# Confluence
CONFLUENCE_URL=https://confluence.your-company.com
CONFLUENCE_TOKEN=your_confluence_token
```

---

### 5. Update Claude Config

```batch
notepad configs\claude-config.json
```

**Update the filesystem path:**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "C:/Users/YOUR_USERNAME/Documents/Projects"
      ]
    }
  }
}
```

**⚠️ Important:** Use **forward slashes** `/` not backslashes `\`

---

### 6. Install Claude Config

```batch
mkdir "%APPDATA%\Claude"
copy configs\claude-config.json "%APPDATA%\Claude\mcp-config.json"
```

---

### 7. Load Secrets & Start

```batch
scripts\Load-MCP-Secrets.bat
claude
```

---

## Detailed Git Bash Setup

### 1. Install Prerequisites (Same as above)

Verify in Git Bash:
```bash
node --version    # v18.x.x
npm --version
claude --version
```

---

### 2. Clone Repository

```bash
cd /c/Users/$USER/Documents
git clone https://github.com/eng-elias-owis/mcp-setup-guide.git
cd mcp-setup-guide
```

---

### 3. Run Windows Setup (in CMD)

Git Bash doesn't run `.cmd` files directly. Use CMD:
```bash
# Open CMD and run:
scripts/setup-windows.cmd

# Then return to Git Bash
```

Or use the bash setup script:
```bash
chmod +x scripts/load-mcp-secrets.sh
```

---

### 4. Configure Secrets

```bash
nano configs/secrets.env
# or
notepad configs/secrets.env
```

---

### 5. Update Config Path

```bash
nano configs/claude-config.json
```

**For Git Bash, you can use Unix-style paths:**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/c/Users/YOUR_USERNAME/Documents/Projects"
      ]
    }
  }
}
```

Both work:
- Windows style: `C:/Users/...`
- Unix style: `/c/Users/...`

---

### 6. Install Config

```bash
mkdir -p "$APPDATA/Claude"
cp configs/claude-config.json "$APPDATA/Claude/mcp-config.json"
```

---

### 7. Load Secrets & Start

```bash
# Git Bash uses source
cd /c/Users/$USER/Documents/mcp-setup-guide
source scripts/load-mcp-secrets.sh

# Start Claude
claude
```

---

## Shell Comparison

| Task | CMD | Git Bash |
|------|-----|----------|
| **Setup script** | `scripts\setup-windows.cmd` | Run in CMD first |
| **Load secrets** | `scripts\Load-MCP-Secrets.bat` | `source scripts/load-mcp-secrets.sh` |
| **Edit file** | `notepad file` | `nano file` or `notepad file` |
| **Path format** | `C:/Users/...` | `C:/Users/...` or `/c/Users/...` |
| **Env variables** | `set VAR=value` | `export VAR=value` |
| **Home directory** | `%USERNAME%` | `$USER` |
| **Config location** | `%APPDATA%\Claude` | `$APPDATA/Claude` |

---

## Common Commands

### CMD
```batch
REM Load secrets for current session
scripts\Load-MCP-Secrets.bat

REM Verify loaded
set GITHUB_URL
set SONAR_URL

REM Start Claude
claude
```

### Git Bash
```bash
# Load secrets
source scripts/load-mcp-secrets.sh

# Verify loaded
echo $GITHUB_URL
echo $SONAR_URL

# Start Claude
claude
```

---

## Troubleshooting

### "'npx' is not recognized" (CMD)

```batch
REM Check Node.js installation path
echo %PATH%

REM Add Node.js to PATH if missing
set PATH=%PATH%;C:\Program Files\nodejs\
```

### "Permission denied" (Git Bash)

```bash
# Fix script permissions
chmod +x scripts/*.sh

# Or use CMD for setup
```

### "Config not found" (Both)

Check locations:
```batch
REM CMD
dir "%APPDATA%\Claude\mcp-config.json"

REM Git Bash
ls "$APPDATA/Claude/mcp-config.json"
```

### Path Issues

**In configs, always use forward slashes:**
```json
"C:/Users/John/Projects"   ✅
"C:\\Users\\John\\Projects"  ✅
"C:\Users\John\Projects"    ❌
```

---

## Quick Reference

### CMD
```batch
REM One-liner to load and run
scripts\Load-MCP-Secrets.bat && claude

REM Check all env vars
set | findstr "GITHUB SONAR JIRA CONFLUENCE"
```

### Git Bash
```bash
# One-liner
source scripts/load-mcp-secrets.sh && claude

# Check all env vars
env | grep -E "GITHUB|SONAR|JIRA|CONFLUENCE"
```

---

## File Locations

| File | CMD Path | Git Bash Path |
|------|----------|---------------|
| Secrets | `configs\secrets.env` | `configs/secrets.env` |
| Claude config | `%APPDATA%\Claude\mcp-config.json` | `$APPDATA/Claude/mcp-config.json` |
| Helper script | `scripts\Load-MCP-Secrets.bat` | `scripts/load-mcp-secrets.sh` |

---

## Next Steps

1. Complete setup above
2. See [04-security.md](04-security.md) for token management
3. See [05-api-reference.md](05-api-reference.md) for API examples
4. See [.claude/README.md](../.claude/README.md) for agents/commands

---

**Choose your preferred shell and start using MCP with Claude!** 🚀
