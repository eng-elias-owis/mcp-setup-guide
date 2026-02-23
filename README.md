# MCP Setup Guide for On-Prem Development

Complete setup guide for using Model Context Protocol (MCP) servers with Claude Code in enterprise environments with on-prem GitHub, SonarQube, JIRA, and Confluence.

## 🎯 What This Repo Provides

- **npx-only MCP servers** (no Docker, no Python)
- **Secure token management** for on-prem tools
- **Ready-to-use configurations** for your stack
- **API integration examples** via Fetch MCP

## 🚀 Quick Start

### 1. Install MCP Servers (5 minutes)

```bash
# Clone this repo
git clone https://github.com/YOUR_USERNAME/mcp-setup-guide.git
cd mcp-setup-guide

# Run the setup script
./scripts/setup.sh
```

### 2. Configure Secrets (5 minutes)

```bash
# Copy the template
cp configs/secrets.env.template configs/secrets.env

# Edit with your tokens
nano configs/secrets.env

# Secure the file
chmod 600 configs/secrets.env
```

### 3. Start Using (immediate)

```bash
# Load secrets and start Claude
source configs/secrets.env
claude
```

## 📋 Included MCP Servers

| Server | Install | Purpose | On-Prem Support |
|--------|---------|---------|-----------------|
| **filesystem** | `npx` | Browse local repos | ✅ |
| **fetch** | `npx` | API calls to tools | ✅ |
| **memory** | `npx` | Persistent context | ✅ |
| **git** | `npx` | Git operations | ✅ |

## 🔧 On-Prem Tool Integration

### Via Fetch MCP (No Custom MCPs Needed)

| Tool | API Endpoint | Auth Method |
|------|--------------|-------------|
| **GitHub Enterprise** | `/api/v3/` | Bearer token |
| **SonarQube Server** | `/api/` | Basic auth |
| **JIRA Server** | `/rest/api/2/` | Bearer token |
| **Confluence Server** | `/rest/api/` | Bearer token |

## 📁 Repository Structure

```
mcp-setup-guide/
├── README.md                 # This file
├── configs/
│   ├── claude-config.json    # Complete Claude MCP config
│   ├── secrets.env.template  # Template for tokens
│   └── secrets.env.example   # Example with fake values
├── scripts/
│   ├── setup.sh              # One-command setup
│   ├── test-connections.sh   # Test all APIs
│   └── rotate-tokens.sh      # Token rotation helper
├── docs/
│   ├── 01-prerequisites.md   # Requirements
│   ├── 02-installation.md      # Step-by-step install
│   ├── 03-configuration.md   # Config details
│   ├── 04-security.md        # Security best practices
│   ├── 05-api-reference.md     # API examples
│   └── 06-troubleshooting.md   # Common issues
├── examples/
│   ├── github-queries.md       # GitHub API examples
│   ├── sonar-queries.md        # SonarQube examples
│   ├── jira-queries.md           # JIRA examples
│   └── confluence-queries.md   # Confluence examples
└── .gitignore
```

## 🔐 Security First

- ✅ No tokens in git (ever)
- ✅ 600 permissions on secrets files
- ✅ Environment variable injection
- ✅ Support for keychain/macOS credential store

## 🎯 Common Tasks

### Browse Local Code
```
"Show me all TODO comments in the auth-service project"
```

### Check SonarQube Quality
```
"Get critical issues for project auth-service from Sonar"
```

### JIRA Integration
```
"Create JIRA ticket: Fix authentication bug in login"
```

### GitHub Enterprise
```
"List open PRs in the backend repository"
```

### Persistent Memory
```
"Remember we use JWT tokens for auth in this project"
"What auth method do we use here?" (Claude recalls)
```

## 📚 Documentation

See the `docs/` directory for detailed guides:

1. [Prerequisites](docs/01-prerequisites.md) - What you need
2. [Installation](docs/02-installation.md) - Step-by-step setup
3. [Configuration](docs/03-configuration.md) - Config details
4. [Security](docs/04-security.md) - Token management
5. [API Reference](docs/05-api-reference.md) - Example queries
6. [Troubleshooting](docs/06-troubleshooting.md) - Fix common issues

## 🛠️ Requirements

- Node.js 18+ (for npx)
- Claude Code (already installed)
- Access tokens for your on-prem tools
- Bash/zsh shell

## 📝 License

MIT - Use freely in your organization.

## 🤝 Contributing

This is a template for your organization. Customize it to your specific needs.

---

**Ready?** Start with [docs/01-prerequisites.md](docs/01-prerequisites.md)
