# Installation Guide

Step-by-step installation of MCP servers for on-prem development.

## Method 1: Automated Setup (Recommended)

### Step 1: Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/mcp-setup-guide.git
cd mcp-setup-guide
```

### Step 2: Run Setup Script

```bash
./scripts/setup.sh
```

This will:
- ✅ Check prerequisites
- ✅ Test MCP server installations
- ✅ Create `configs/secrets.env` from template
- ✅ Set secure permissions

### Step 3: Configure Your Tokens

```bash
# Edit the secrets file
nano configs/secrets.env
```

Fill in your actual:
- GitHub Enterprise URL and token
- SonarQube URL and token
- JIRA URL and token
- Confluence URL and token

### Step 4: Update Project Path

Edit `configs/claude-config.json`:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", 
        "/home/YOUR_USERNAME/projects"  // <-- Change this
      ]
    }
  }
}
```

### Step 5: Install Config

```bash
# Create Claude config directory
mkdir -p ~/.config/claude

# Copy config
cp configs/claude-config.json ~/.config/claude/mcp-config.json

# Or for older Claude versions
cp configs/claude-config.json ~/.claude/mcp-config.json
```

### Step 6: Start Using

```bash
# Load secrets
source configs/secrets.env

# Start Claude
claude
```

---

## Method 2: Manual Setup

If you prefer manual control:

### Install MCP Servers Directly

```bash
# Test each server (they install on first run)
npx -y @modelcontextprotocol/server-filesystem /path/to/repos
npx -y @modelcontextprotocol/server-fetch
npx -y @modelcontextprotocol/server-memory
npx -y @modelcontextprotocol/server-git
```

### Create Config Manually

Create `~/.config/claude/mcp-config.json`:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/your/project/path"]
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}",
        "GITHUB_URL": "${GITHUB_URL}",
        "SONAR_TOKEN": "${SONAR_TOKEN}",
        "SONAR_URL": "${SONAR_URL}",
        "JIRA_TOKEN": "${JIRA_TOKEN}",
        "JIRA_URL": "${JIRA_URL}",
        "CONFLUENCE_TOKEN": "${CONFLUENCE_TOKEN}",
        "CONFLUENCE_URL": "${CONFLUENCE_URL}"
      }
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git"]
    }
  }
}
```

### Set Environment Variables

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
# MCP Server Secrets
export GITHUB_URL="https://github.your-company.com"
export GITHUB_TOKEN="ghp_your_token"

export SONAR_URL="https://sonar.your-company.com"
export SONAR_TOKEN="squ_your_token"

export JIRA_URL="https://jira.your-company.com"
export JIRA_TOKEN="your_jira_token"

export CONFLUENCE_URL="https://confluence.your-company.com"
export CONFLUENCE_TOKEN="your_confluence_token"
```

Then reload:
```bash
source ~/.bashrc
```

---

## Verify Installation

### Test Filesystem MCP

In Claude:
```
List files in the current project
```

Expected: Claude shows directory listing.

### Test Fetch MCP

In Claude:
```
Make a test API call to https://httpbin.org/get
```

Expected: Claude shows JSON response.

### Test Memory MCP

In Claude:
```
Remember that we use PostgreSQL for the database
```

Then:
```
What database do we use?
```

Expected: Claude recalls "PostgreSQL".

---

## Troubleshooting

### "npx command not found"

```bash
# Reinstall npm
npm install -g npm
```

### "Cannot find module"

```bash
# Clear npx cache
rm -rf ~/.npm/_npx
```

### "Permission denied"

```bash
# Fix permissions
chmod +x scripts/setup.sh
chmod 600 configs/secrets.env
```

---

## Next Steps

→ Go to [03-configuration.md](03-configuration.md) for advanced config options
