# Windows Setup Guide

Complete setup instructions for Windows 10/11 with Claude Code.

## Prerequisites

### 1. Install Node.js 18+

**Download:** https://nodejs.org/ (LTS version recommended)

**Verify installation:**
```powershell
node --version    # Should show v18.x.x or higher
npm --version
```

### 2. Install Git

**Download:** https://git-scm.com/download/win

**Verify:**
```powershell
git --version
```

### 3. Install Claude Code

```powershell
npm install -g @anthropic-ai/claude-code
```

**Verify:**
```powershell
claude --version
```

---

## Setup Steps

### Step 1: Clone the Repository

```powershell
# Open PowerShell or CMD
cd C:\Users\%USERNAME%\Documents
git clone https://github.com/eng-elias-owis/mcp-setup-guide.git
cd mcp-setup-guide
```

### Step 2: Run Setup Script

**Option A: PowerShell Script (Recommended)**

Create `scripts/setup-windows.ps1`:

```powershell
# MCP Setup for Windows
# Save this as setup-windows.ps1 and run in PowerShell

Write-Host "🚀 MCP Setup Guide - Windows Installation" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check Node.js
Write-Host "📋 Checking prerequisites..." -ForegroundColor Yellow

try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js $nodeVersion found" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not found. Please install from https://nodejs.org/" -ForegroundColor Red
    exit 1
}

try {
    $npxVersion = npx --version
    Write-Host "✅ npx found" -ForegroundColor Green
} catch {
    Write-Host "❌ npx not found" -ForegroundColor Red
    exit 1
}

try {
    $claudePath = (Get-Command claude).Source
    Write-Host "✅ Claude Code found at $claudePath" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Claude Code not found in PATH" -ForegroundColor Yellow
    Write-Host "   Install: npm install -g @anthropic-ai/claude-code"
}

Write-Host ""
Write-Host "📦 Testing MCP servers..." -ForegroundColor Yellow

# Test MCP servers
$mcpServers = @(
    "@modelcontextprotocol/server-filesystem",
    "@modelcontextprotocol/server-fetch",
    "@modelcontextprotocol/server-memory",
    "@modelcontextprotocol/server-git"
)

foreach ($server in $mcpServers) {
    Write-Host "Testing $server..." -NoNewline
    try {
        $null = npx -y $server --help 2>&1
        Write-Host " ✅" -ForegroundColor Green
    } catch {
        Write-Host " ⚠️  (will install on first use)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "⚙️  Setting up configuration..." -ForegroundColor Yellow

# Create configs directory
New-Item -ItemType Directory -Force -Path "configs" | Out-Null

# Copy secrets template if doesn't exist
if (-not (Test-Path "configs/secrets.env")) {
    Copy-Item "configs/secrets.env.template" "configs/secrets.env"
    Write-Host "📝 Created configs/secrets.env from template" -ForegroundColor Green
    Write-Host "   Please edit this file with your actual tokens" -ForegroundColor Yellow
} else {
    Write-Host "✅ configs/secrets.env already exists" -ForegroundColor Green
}

# Set permissions (Windows doesn't use Unix permissions, but we can hide the file)
if (Test-Path "configs/secrets.env") {
    $file = Get-Item "configs/secrets.env" -Force
    $file.Attributes = 'Hidden'
    Write-Host "🔒 Set secrets.env as hidden file" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎯 Next Steps:" -ForegroundColor Cyan
Write-Host "=============" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Edit configs/secrets.env with your tokens:"
Write-Host "   notepad configs\secrets.env"
Write-Host ""
Write-Host "2. Update the filesystem path in configs\claude-config.json:"
Write-Host "   Change '/path/to/your/repos' to your actual projects directory"
Write-Host "   Example: C:/Users/%USERNAME%/Documents/Projects"
Write-Host ""
Write-Host "3. Copy the MCP config to Claude:"
Write-Host "   $claudeDir = \"$env:APPDATA\Claude\""
Write-Host "   New-Item -ItemType Directory -Force -Path $claudeDir"
Write-Host "   Copy-Item configs\claude-config.json \"$claudeDir\mcp-config.json\""
Write-Host ""
Write-Host "4. Start using:"
Write-Host "   $env:GITHUB_TOKEN = 'your-token'"
Write-Host "   claude"
Write-Host ""
Write-Host "📚 See docs/ directory for detailed guides"
Write-Host ""
Write-Host "✅ Setup complete!" -ForegroundColor Green
```

**Run the script:**
```powershell
# Navigate to repo
cd C:\Users\%USERNAME%\Documents\mcp-setup-guide

# Run setup
.\scripts\setup-windows.ps1

# If execution policy blocks it:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\scripts\setup-windows.ps1
```

**Option B: Manual Setup**

```powershell
# Test MCP servers
npx -y @modelcontextprotocol/server-filesystem C:\Users\%USERNAME%\Documents\Projects
npx -y @modelcontextprotocol/server-fetch
npx -y @modelcontextprotocol/server-memory
npx -y @modelcontextprotocol/server-git
```

---

### Step 3: Configure Secrets

**Edit the secrets file:**

```powershell
notepad configs\secrets.env
```

**Fill in your on-prem URLs and tokens:**

```powershell
# GitHub Enterprise
$env:GITHUB_URL = "https://github.your-company.com"
$env:GITHUB_TOKEN = "ghp_your_token_here"

# SonarQube
$env:SONAR_URL = "https://sonar.your-company.com"
$env:SONAR_TOKEN = "squ_your_token_here"

# JIRA
$env:JIRA_URL = "https://jira.your-company.com"
$env:JIRA_TOKEN = "your_jira_token"

# Confluence
$env:CONFLUENCE_URL = "https://confluence.your-company.com"
$env:CONFLUENCE_TOKEN = "your_confluence_token"
```

---

### Step 4: Update Claude Config

**Edit the config file:**

```powershell
notepad configs\claude-config.json
```

**Update the filesystem path to Windows format:**

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

**Important:** Use forward slashes `/` or escaped backslashes `\\` in the path.

---

### Step 5: Install Claude Config

```powershell
# Create Claude config directory
$claudeDir = "$env:APPDATA\Claude"
New-Item -ItemType Directory -Force -Path $claudeDir

# Copy config
Copy-Item configs\claude-config.json "$claudeDir\mcp-config.json"

# Verify
Get-Content "$claudeDir\mcp-config.json"
```

**Alternative location (older Claude versions):**
```powershell
$claudeDir = "$env:USERPROFILE\.claude"
New-Item -ItemType Directory -Force -Path $claudeDir
Copy-Item configs\claude-config.json "$claudeDir\mcp-config.json"
```

---

### Step 6: Set Environment Variables

**Option A: PowerShell Session (Temporary)**

```powershell
# Load secrets for current session
Get-Content configs\secrets.env | ForEach-Object {
    if ($_ -match "^([A-Z_]+)=(.+)$") {
        [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
    }
}

# Verify
$env:GITHUB_URL
$env:SONAR_URL
```

**Option B: Windows Environment Variables (Persistent)**

```powershell
# Set user-level environment variables
[Environment]::SetEnvironmentVariable("GITHUB_URL", "https://github.your-company.com", "User")
[Environment]::SetEnvironmentVariable("GITHUB_TOKEN", "ghp_xxx", "User")
[Environment]::SetEnvironmentVariable("SONAR_URL", "https://sonar.your-company.com", "User")
[Environment]::SetEnvironmentVariable("SONAR_TOKEN", "squ_xxx", "User")
[Environment]::SetEnvironmentVariable("JIRA_URL", "https://jira.your-company.com", "User")
[Environment]::SetEnvironmentVariable("JIRA_TOKEN", "xxx", "User")
[Environment]::SetEnvironmentVariable("CONFLUENCE_URL", "https://confluence.your-company.com", "User")
[Environment]::SetEnvironmentVariable("CONFLUENCE_TOKEN", "xxx", "User")

# Restart PowerShell to load new variables
```

**Or use GUI:**
1. Win + R → `sysdm.cpl` → Enter
2. Advanced → Environment Variables
3. Add New User Variables

---

### Step 7: Copy Claude Customizations

```powershell
# Copy agents, commands, and skills to your project
$projectDir = "C:/Users/%USERNAME%/Documents/your-project"
cd $projectDir

# Create .claude directory
New-Item -ItemType Directory -Force -Path ".claude"

# Copy from mcp-setup-guide
Copy-Item -Recurse "C:/Users/%USERNAME%/Documents/mcp-setup-guide/.claude/*" .claude/

# Or create symbolic link (if supported)
cmd /c mklink /J .claude "C:\Users\%USERNAME%\Documents\mcp-setup-guide\.claude"
```

---

## Usage

### Start Claude with Environment Variables

```powershell
# Navigate to your project
cd C:\Users\%USERNAME%\Documents\your-project

# Load secrets
Get-Content C:\Users\%USERNAME%\Documents\mcp-setup-guide\configs\secrets.env | ForEach-Object {
    if ($_ -match "^([A-Z_]+)=(.+)$") {
        [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
    }
}

# Start Claude
claude
```

### Use Commands

```bash
# In Claude
/sonar-scan backend
/jira-ticket "Fix Windows path bug"
/pr-check 123
```

### Use Agents

```bash
# In Claude
Switch to the pr-reviewer agent
Review PR #456 in the backend repo
```

---

## Windows-Specific Notes

### Path Formatting

**Use forward slashes in configs:**
```json
"C:/Users/John/Documents/Projects"   ✅
"C:\\Users\\John\\Documents\\Projects"  ✅
"C:\Users\John\Documents\Projects"      ❌ (escaping issues)
```

### Line Endings

Git may convert line endings. If scripts fail:

```powershell
# Configure Git to preserve line endings
git config --global core.autocrlf false

# Or convert a specific file
(Get-Content scripts\setup.sh -Raw).Replace("`r`n", "`n") | Set-Content scripts\setup.sh -NoNewline
```

### PowerShell Execution Policy

If scripts won't run:

```powershell
# Check current policy
Get-ExecutionPolicy

# Set for current user (less secure, but works)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Or bypass for single session
PowerShell -ExecutionPolicy Bypass -File .\script.ps1
```

### Antivirus/Firewall

Corporate antivirus may block npx downloads:
- Add `%LOCALAPPDATA%\npm-cache` to exclusions
- Or whitelist Node.js in antivirus

---

## Troubleshooting

### "npx is not recognized"

```powershell
# Check npm is installed
npm --version

# If missing, reinstall Node.js from nodejs.org
```

### "Cannot find module"

```powershell
# Clear npm cache
npm cache clean --force

# Reinstall global packages
npm install -g @anthropic-ai/claude-code
```

### "Permission denied" on secrets.env

Windows doesn't have Unix permissions, but you can:
```powershell
# Hide the file
$file = Get-Item "configs\secrets.env" -Force
$file.Attributes = 'Hidden'

# Or encrypt with Windows
cipher /e configs\secrets.env
```

### "Config not loading"

Check both locations:
```powershell
Test-Path "$env:APPDATA\Claude\mcp-config.json"
Test-Path "$env:USERPROFILE\.claude\mcp-config.json"
```

---

## Quick Reference

| Task | Command |
|------|---------|
| Edit secrets | `notepad configs\secrets.env` |
| Edit config | `notepad configs\claude-config.json` |
| Load secrets | `Get-Content configs\secrets.env \| ForEach-Object { if ($_ -match "^([A-Z_]+)=(.+)$") { [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process") } }` |
| Start Claude | `claude` |
| Check config | `Get-Content "$env:APPDATA\Claude\mcp-config.json"` |

---

## Next Steps

→ See [02-installation.md](02-installation.md) for detailed guides
→ See [04-security.md](04-security.md) for secure token management
→ See [06-troubleshooting.md](06-troubleshooting.md) for common issues
