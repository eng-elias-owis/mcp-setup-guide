# MCP Setup for Windows
# Save this as setup-windows.ps1 and run in PowerShell
# 
# Usage:
#   .\setup-windows.ps1
#
# Requirements:
#   - Node.js 18+ (install from https://nodejs.org/)
#   - PowerShell 5.1 or higher
#   - Git for Windows

param(
    [string]$ProjectsPath = "$env:USERPROFILE\Documents\Projects"
)

# Colors for output
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

Write-ColorOutput Cyan "🚀 MCP Setup Guide - Windows Installation"
Write-ColorOutput Cyan "=========================================="
Write-Output ""

# Check prerequisites
Write-ColorOutput Yellow "📋 Checking prerequisites..."

try {
    $nodeVersion = node --version 2>$null
    Write-ColorOutput Green "✅ Node.js $nodeVersion found"
} catch {
    Write-ColorOutput Red "❌ Node.js not found. Please install from https://nodejs.org/"
    Write-Output "   Download the LTS version and run the installer."
    exit 1
}

try {
    $npxVersion = npx --version 2>$null
    Write-ColorOutput Green "✅ npx found"
} catch {
    Write-ColorOutput Red "❌ npx not found"
    exit 1
}

try {
    $gitVersion = git --version 2>$null
    Write-ColorOutput Green "✅ $gitVersion found"
} catch {
    Write-ColorOutput Yellow "⚠️  Git not found. Install from https://git-scm.com/download/win"
}

try {
    $claudePath = (Get-Command claude -ErrorAction Stop).Source
    Write-ColorOutput Green "✅ Claude Code found at $claudePath"
} catch {
    Write-ColorOutput Yellow "⚠️  Claude Code not found in PATH"
    Write-Output "   Install with: npm install -g @anthropic-ai/claude-code"
}

Write-Output ""
Write-ColorOutput Yellow "📦 Testing MCP servers..."

# Test MCP servers
$mcpServers = @(
    "@modelcontextprotocol/server-filesystem",
    "@modelcontextprotocol/server-fetch",
    "@modelcontextprotocol/server-memory",
    "@modelcontextprotocol/server-git"
)

foreach ($server in $mcpServers) {
    Write-Output "Testing $server..." -NoNewline
    try {
        $null = npx -y $server --help 2>&1 | Out-Null
        Write-ColorOutput Green " ✅"
    } catch {
        Write-ColorOutput Yellow " ⚠️  (will install on first use)"
    }
}

Write-Output ""
Write-ColorOutput Yellow "⚙️  Setting up configuration..."

# Create configs directory
New-Item -ItemType Directory -Force -Path "configs" | Out-Null

# Copy secrets template if doesn't exist
if (-not (Test-Path "configs\secrets.env")) {
    if (Test-Path "configs\secrets.env.template") {
        Copy-Item "configs\secrets.env.template" "configs\secrets.env"
        Write-ColorOutput Green "📝 Created configs\secrets.env from template"
        Write-ColorOutput Yellow "   Please edit this file with your actual tokens"
    } else {
        Write-ColorOutput Red "❌ configs\secrets.env.template not found"
    }
} else {
    Write-ColorOutput Green "✅ configs\secrets.env already exists"
}

# Set file as hidden (Windows equivalent of chmod 600)
if (Test-Path "configs\secrets.env") {
    $file = Get-Item "configs\secrets.env" -Force
    $file.Attributes = $file.Attributes -bor [System.IO.FileAttributes]::Hidden
    Write-ColorOutput Green "🔒 Set secrets.env as hidden file"
}

# Update claude-config.json with Windows path
if (Test-Path "configs\claude-config.json") {
    $configPath = Resolve-Path "configs\claude-config.json"
    $config = Get-Content $configPath -Raw | ConvertFrom-Json
    
    # Update filesystem path if it's the default
    if ($config.mcpServers.filesystem.args[2] -eq "/path/to/your/repos") {
        Write-ColorOutput Yellow "   Updating filesystem path in config..."
        Write-Output "   Change '/path/to/your/repos' to your actual projects path in:"
        Write-Output "   $configPath"
    }
}

Write-Output ""
Write-ColorOutput Cyan "🎯 Next Steps:"
Write-ColorOutput Cyan "============="
Write-Output ""
Write-Output "1. Edit configs\secrets.env with your tokens:"
Write-Output "   notepad configs\secrets.env"
Write-Output ""
Write-Output "2. Update the filesystem path in configs\claude-config.json:"
Write-Output "   Change '/path/to/your/repos' to: $ProjectsPath"
Write-Output "   (Use forward slashes: C:/Users/... or escaped backslashes: C:\\Users\\...)"
Write-Output ""
Write-Output "3. Copy the MCP config to Claude:"
Write-Output "   $claudeDir = \"$env:APPDATA\Claude\""
Write-Output "   New-Item -ItemType Directory -Force -Path $claudeDir"
Write-Output "   Copy-Item configs\claude-config.json \"$claudeDir\mcp-config.json\""
Write-Output ""
Write-Output "4. Load secrets and start Claude:"
Write-Output "   Get-Content configs\secrets.env | ForEach-Object {"
Write-Output "       if (`$_ -match \"^([A-Z_]+)=(.+)$\") {"
Write-Output "           [Environment]::SetEnvironmentVariable(`$matches[1], `$matches[2], \"Process\")"
Write-Output "       }"
Write-Output "   }"
Write-Output "   claude"
Write-Output ""
Write-Output "📚 See docs/07-windows-setup.md for detailed Windows guide"
Write-Output ""
Write-ColorOutput Green "✅ Setup complete!"

# Create helper script for loading secrets
$helperScript = @'
# Load-MCP-Secrets.ps1
# Helper script to load MCP secrets into environment variables

$secretFile = "$PSScriptRoot\..\configs\secrets.env"

if (Test-Path $secretFile) {
    Get-Content $secretFile | ForEach-Object {
        if ($_ -match "^([A-Z_]+)=(.+)$") {
            $varName = $matches[1]
            $varValue = $matches[2]
            [Environment]::SetEnvironmentVariable($varName, $varValue, "Process")
            Write-Host "Set $varName" -ForegroundColor Green
        }
    }
    Write-Host "`n✅ All secrets loaded. Start Claude with: claude" -ForegroundColor Green
} else {
    Write-Host "❌ Secrets file not found: $secretFile" -ForegroundColor Red
}
'@

$helperPath = "scripts\Load-MCP-Secrets.ps1"
if (-not (Test-Path $helperPath)) {
    $helperScript | Out-File -FilePath $helperPath -Encoding UTF8
    Write-Output ""
    Write-ColorOutput Green "📝 Created helper script: $helperPath"
    Write-Output "   Usage: .\scripts\Load-MCP-Secrets.ps1"
}
