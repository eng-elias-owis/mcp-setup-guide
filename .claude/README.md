# Claude Code Agents, Commands & Skills

This directory contains Claude Code customization files for enhanced productivity.

## Structure

```
.claude/
├── agents/           # Specialized AI agents
│   ├── pr-reviewer.md
│   ├── code-quality.md
│   └── tech-lead.md
├── commands/         # Slash commands
│   ├── pr-check.md
│   ├── sonar-scan.md
│   ├── jira-ticket.md
│   └── create-doc.md
├── skills/           # Skills and capabilities
│   ├── sonarqube-integration/
│   ├── jira-integration/
│   └── confluence-integration/
└── CLAUDE.md         # Project context
```

## Quick Reference

| Type | File | Purpose |
|------|------|---------|
| **Agent** | `agents/*.md` | Specialized AI personas |
| **Command** | `commands/*.md` | Quick actions with `/command` |
| **Skill** | `skills/*/` | Reusable tool integrations |
| **Context** | `CLAUDE.md` | Project-wide knowledge |

## Usage

### Agents
```
Switch to the pr-reviewer agent
```

### Commands
```
/pr-check
/sonar-scan backend
/jira-ticket "Fix auth bug"
```

### Skills
Automatically loaded when relevant files are detected.

---

See individual directories for detailed documentation.
