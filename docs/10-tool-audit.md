# Tool Audit Report

**Date:** 2026-02-24  
**Repository:** mcp-setup-guide  
**Purpose:** Identify archived tools and suggest alternatives

---

## Executive Summary

| Status | Count | Tools |
|--------|-------|-------|
| ✅ **ACTIVE** | 5 | filesystem, memory, git, sequential-thinking, time |
| ⚠️ **ARCHIVED** | 1 | fetch |
| 🆕 **ADDED** | 4 | API agent guides (github, sonar, jira, confluence) |

---

## MCP Server Status

### ✅ ACTIVE - Official MCP Servers

#### 1. @modelcontextprotocol/server-filesystem
**Status:** ✅ ACTIVE  
**Install:** `npx -y @modelcontextprotocol/server-filesystem /path`  
**Purpose:** Browse and search local files  
**Use Case:** Navigate project structure, read files  
**Alternative:** None needed - working perfectly

#### 2. @modelcontextprotocol/server-memory
**Status:** ✅ ACTIVE  
**Install:** `npx -y @modelcontextprotocol/server-memory`  
**Purpose:** Persistent knowledge graph  
**Use Case:** Remember context across Claude sessions  
**Alternative:** None needed - working perfectly

#### 3. @modelcontextprotocol/server-git
**Status:** ✅ ACTIVE  
**Install:** `npx -y @modelcontextprotocol/server-git`  
**Purpose:** Git repository operations  
**Use Case:** Check commit history, status, diffs  
**Alternative:** None needed - working perfectly  
**Note:** For GitHub operations, use `gh` CLI or API agents

#### 4. @modelcontextprotocol/server-sequentialthinking
**Status:** ✅ ACTIVE  
**Install:** `npx -y @modelcontextprotocol/server-sequentialthinking`  
**Purpose:** Dynamic problem-solving  
**Use Case:** Complex reasoning, step-by-step analysis  
**Alternative:** None needed - working perfectly

#### 5. @modelcontextprotocol/server-time
**Status:** ✅ ACTIVE  
**Install:** `npx -y @modelcontextprotocol/server-time`  
**Purpose:** Time and timezone conversions  
**Use Case:** Time calculations, timezone handling  
**Alternative:** None needed - working perfectly

---

### ⚠️ ARCHIVED - No Longer Maintained

#### ❌ @modelcontextprotocol/server-fetch
**Status:** ❌ ARCHIVED (May 2025)  
**Original Purpose:** HTTP requests to APIs  
**Why Archived:** Moved to servers-archived repo by MCP team  
**Impact:** Cannot be installed via npx anymore

**Alternatives:**

| Alternative | Method | Pros | Cons |
|-------------|--------|------|------|
| **Claude Built-in Fetch** | Native | No setup, works immediately | No persistent headers |
| **API Agents** | `.claude/agents/` | Full documentation, guided | Requires agent switch |
| **Shell Scripts** | `scripts/*.sh` | Customizable, works with env vars | Need to execute manually |
| **GitHub CLI (gh)** | External tool | Rich features for GitHub | Only for GitHub |
| **HTTPie (xh)** | `npm install -g httpie` | Modern, user-friendly | Another dependency |

**Recommended Approach:**
1. Use **Claude's built-in fetch** for simple requests
2. Use **API agents** for complex operations (they provide endpoint docs)
3. Use **shell scripts** for repetitive tasks (provided in `scripts/`)

---

## API Integration Agents (NEW)

Instead of a generic fetch MCP, we now provide specialized API agents:

### 1. GitHub API Agent
**Location:** `.claude/agents/github-api-agent.md`  
**Purpose:** Explain GitHub Enterprise API endpoints  
**Use:** `Switch to github-api-agent` then use Claude's fetch  
**Coverage:** PRs, Issues, Commits, Search, Repositories  
**Status:** ✅ ACTIVE

### 2. SonarQube API Agent
**Location:** `.claude/agents/sonarqube-api-agent.md`  
**Purpose:** Explain SonarQube quality metrics and issues API  
**Use:** `Switch to sonarqube-api-agent` then use Claude's fetch  
**Coverage:** Quality gates, Issues, Metrics, Hotspots, Rules  
**Status:** ✅ ACTIVE

### 3. JIRA API Agent
**Location:** `.claude/agents/jira-api-agent.md`  
**Purpose:** Explain JIRA Server API and JQL queries  
**Use:** `Switch to jira-api-agent` then use Claude's fetch  
**Coverage:** Issues, Search (JQL), Projects, Transitions, Comments  
**Status:** ✅ ACTIVE

### 4. Confluence API Agent
**Location:** `.claude/agents/confluence-api-agent.md`  
**Purpose:** Explain Confluence Server API for documentation  
**Use:** `Switch to confluence-api-agent` then use Claude's fetch  
**Coverage:** Pages, Spaces, Search (CQL), Storage format, Labels  
**Status:** ✅ ACTIVE

---

## Shell Script Wrappers (NEW)

For command-line API access:

### 1. scripts/github-api.sh
**Status:** ✅ ACTIVE  
**Purpose:** GitHub Enterprise API wrapper  
**Use:** `./github-api.sh repos/org/backend/pulls`  
**Requires:** `GITHUB_TOKEN`, `GITHUB_URL` env vars

### 2. scripts/sonar-query.sh
**Status:** ✅ ACTIVE  
**Purpose:** SonarQube metrics and quality gate checks  
**Use:** `./sonar-query.sh backend coverage,bugs`  
**Requires:** `SONAR_TOKEN`, `SONAR_URL` env vars

### 3. scripts/jira-create.sh
**Status:** ✅ ACTIVE  
**Purpose:** Create JIRA tickets from command line  
**Use:** `./jira-create.sh AUTH "Fix bug" Bug High`  
**Requires:** `JIRA_TOKEN`, `JIRA_URL` env vars

### 4. scripts/confluence-create.sh
**Status:** ✅ ACTIVE  
**Purpose:** Create Confluence pages  
**Use:** `./confluence-create.sh TEAM "API Guide"`  
**Requires:** `CONFLUENCE_TOKEN`, `CONFLUENCE_URL` env vars

---

## External Tools (Recommended)

### GitHub CLI (gh)
**Status:** ✅ ACTIVE (External tool)  
**Install:** `npm install -g gh` or download from github.com  
**Purpose:** Rich GitHub operations  
**Use:** `gh pr list`, `gh issue create`  
**Alternative to:** GitHub API agent for simple operations  
**Recommendation:** Install if not already present

### HTTPie (http or xh)
**Status:** ✅ ACTIVE (External tool)  
**Install:** `npm install -g httpie`  
**Purpose:** User-friendly HTTP client  
**Use:** `http GET api.example.com Authorization:"Bearer token"`  
**Alternative to:** curl for manual API testing  
**Recommendation:** Optional - for manual debugging

---

## Deprecated/Removed Tools

| Tool | Status | Reason | Replacement |
|------|--------|--------|-------------|
| `@modelcontextprotocol/server-fetch` | ❌ ARCHIVED | Moved to archived repo | Claude built-in fetch + API agents |
| `@modelcontextprotocol/server-postgres` | ❌ ARCHIVED | Community alternatives exist | Use Fetch MCP with SQL API or database CLI |
| `@modelcontextprotocol/server-puppeteer` | ❌ ARCHIVED | Complex, few use cases | Browser MCP or external tools |

---

## Updated Configuration

### What's Changed

**Before:**
```json
{
  "mcpServers": {
    "fetch": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-fetch"] }
  }
}
```

**After:**
```json
{
  "mcpServers": {
    "filesystem": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path"] },
    "memory": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-memory"] },
    "git": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-git"] },
    "sequential-thinking": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-sequentialthinking"] }
  }
}
```

**HTTP requests:** Use Claude's built-in fetch with guidance from API agents

---

## Migration Guide

### If you were using Fetch MCP:

**Option 1: Switch to API Agent (Recommended)**
```bash
# Instead of relying on fetch MCP, use the agent:
"Switch to github-api-agent"
"List open PRs in backend repo"
```

**Option 2: Use Claude's Built-in Fetch**
```bash
# Direct fetch (no MCP needed):
"GET https://github.company.com/api/v3/repos/org/backend/pulls"
```

**Option 3: Use Shell Scripts**
```bash
# Run wrapper script:
./scripts/github-api.sh repos/org/backend/pulls
```

---

## Recommendations

### For New Users:
1. Use the 4 core MCPs: filesystem, memory, git, sequential-thinking
2. Use **API agents** for API operations (they provide documentation + fetch)
3. Use **shell scripts** for repetitive CLI tasks

### For Existing Users:
1. Remove fetch MCP from config (it's archived)
2. Start using API agents: `.claude/agents/*-api-agent.md`
3. Try Claude's built-in fetch for simple requests
4. Use shell scripts for complex workflows

### For API Operations:
1. **Simple requests:** Claude's built-in fetch
2. **Complex queries:** API agents (github-api-agent, sonarqube-api-agent, etc.)
3. **Repetitive tasks:** Shell scripts (scripts/*.sh)
4. **GitHub-specific:** GitHub CLI (gh)

---

## Files Updated in This Audit

| File | Change |
|------|--------|
| `configs/claude-config.json` | Removed fetch MCP, added notes about alternatives |
| `.claude/agents/github-api-agent.md` | NEW - GitHub API documentation |
| `.claude/agents/sonarqube-api-agent.md` | NEW - SonarQube API documentation |
| `.claude/agents/jira-api-agent.md` | NEW - JIRA API documentation |
| `.claude/agents/confluence-api-agent.md` | NEW - Confluence API documentation |
| `scripts/github-api.sh` | NEW - GitHub API wrapper script |
| `scripts/sonar-query.sh` | NEW - SonarQube query script |
| `scripts/jira-create.sh` | NEW - JIRA ticket creation script |
| `scripts/confluence-create.sh` | NEW - Confluence page creation script |
| `docs/09-http-alternatives.md` | NEW - Guide for HTTP without fetch MCP |
| `docs/10-tool-audit.md` | NEW - This audit report |

---

## Maintenance Schedule

**Quarterly:**
- Check MCP server status on npm/registry
- Update agent documentation with new API features
- Review shell scripts for improvements

**When MCP Team Announces Changes:**
- Immediately check for archived tools
- Update configs and documentation
- Notify users of alternatives

---

## Contact & Updates

- Repository: https://github.com/eng-elias-owis/mcp-setup-guide
- Issues: Open GitHub issue for tool problems
- Updates: Watch repository for changes

---

**Audit Complete** ✅  
**All archived tools removed, alternatives provided**  
**4 new API agents added for enhanced functionality**
