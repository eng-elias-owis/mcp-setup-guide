# MCP Setup Guide - Project Context

This is a template for teams using Model Context Protocol (MCP) servers with Claude Code in enterprise environments.

## Project Overview

**Purpose:** Enable AI-assisted development with on-prem tools (GitHub Enterprise, SonarQube, JIRA, Confluence) using only npx-based MCP servers (no Docker, no Python).

**Stack:**
- GitHub Enterprise Server (on-prem)
- SonarQube Server (on-prem)
- JIRA Server/Data Center (on-prem)
- Confluence Server/Data Center (on-prem)
- Claude Code (AI assistant)
- MCP Servers (filesystem, fetch, memory, git)

## Quick Links

- Repository: https://github.com/eng-elias-owis/mcp-setup-guide
- Setup Script: `./scripts/setup.sh`
- Config File: `configs/claude-config.json`
- Secrets Template: `configs/secrets.env.template`

## Directory Structure

```
mcp-setup-guide/
├── README.md                      # Main documentation
├── configs/
│   ├── claude-config.json         # MCP server configuration
│   └── secrets.env.template       # Token template (copy to secrets.env)
├── scripts/
│   └── setup.sh                   # One-command installer
├── docs/                          # Detailed guides
│   ├── 01-prerequisites.md
│   ├── 02-installation.md
│   ├── 04-security.md
│   ├── 05-api-reference.md
│   └── 06-troubleshooting.md
├── examples/                      # API query examples
│   ├── github-queries.md
│   └── sonar-queries.md
└── .claude/                       # Claude Code customizations
    ├── README.md
    ├── agents/                    # AI personas
    │   ├── pr-reviewer.md
    │   ├── code-quality.md
    │   └── tech-lead.md
    ├── commands/                  # Slash commands
    │   ├── pr-check.md
    │   ├── sonar-scan.md
    │   ├── jira-ticket.md
    │   └── create-doc.md
    └── skills/                    # Integration guides
        ├── sonarqube-integration/
        ├── jira-integration/
        └── confluence-integration/
```

## Team Standards

### Security
- Never commit tokens to git
- Use Personal Access Tokens (PATs)
- Rotate tokens every 90 days
- File permissions: 600 on secrets.env

### Code Quality
- SonarQube quality gate must pass
- Coverage target: 80% minimum
- No critical or blocker issues
- Document architecture decisions

### Documentation
- API changes → Update Confluence
- Runbooks for all critical processes
- ADRs for major architectural decisions
- README for every repository

## MCP Server Configuration

The `.claude/agents/`, `.claude/commands/`, and `.claude/skills/` directories are automatically recognized by Claude Code and provide:

- **Agents:** Specialized AI personas for PR review, code quality, and technical leadership
- **Commands:** Quick actions with `/command` syntax
- **Skills:** Detailed integration guides for tools

## Common Workflows

### 1. Daily Development
```
/pr-check 123                    # Review PR before merge
/sonar-scan backend              # Check code quality
/jira-ticket "Fix bug"           # Create tracking ticket
```

### 2. Documentation
```
/create-doc "API Guide"          # Create Confluence page
Search Confluence for "auth"   # Find existing docs
Update deployment runbook      # Modify existing page
```

### 3. Code Review
```
Switch to pr-reviewer agent      # Change persona
Review PR #456                   # Comprehensive review
Check SonarQube issues           # Quality verification
```

### 4. Architecture
```
Switch to tech-lead agent        # Change persona
Review service architecture      # Design evaluation
Create ADR for decision          # Document decision
```

## Environment Variables

Required (set in `configs/secrets.env`):

```bash
# GitHub Enterprise
GITHUB_URL=https://github.your-company.com
GITHUB_TOKEN=ghp_xxx

# SonarQube
SONAR_URL=https://sonar.your-company.com
SONAR_TOKEN=squ_xxx

# JIRA
JIRA_URL=https://jira.your-company.com
JIRA_TOKEN=xxx

# Confluence
CONFLUENCE_URL=https://confluence.your-company.com
CONFLUENCE_TOKEN=xxx
```

## Troubleshooting

See `docs/06-troubleshooting.md` for:
- Installation issues
- Token problems
- Network connectivity
- API errors

## Contributing

Customize for your organization:
1. Update URLs in examples
2. Add team-specific standards
3. Create additional agents/commands
4. Share with your team

## Support

- Documentation: `docs/` directory
- Examples: `examples/` directory
- Issues: Open GitHub issue
- Updates: Watch repository

---

**Remember:** This is a template. Customize it to your team's specific needs and standards.
