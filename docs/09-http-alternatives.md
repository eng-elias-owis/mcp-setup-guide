# HTTP Request Alternatives (No Fetch MCP Required)

Since the official `@modelcontextprotocol/server-fetch` has been **archived**, here are working alternatives for making HTTP requests in Claude Code.

## 🥇 Option 1: Claude's Built-in Fetch (Recommended)

**Claude Code has native HTTP capabilities!**

```bash
# In Claude - just ask:
"GET https://api.github.com/repos/myorg/backend/issues"

"POST to https://jira.company.com/rest/api/2/issue with body:
{
  \"fields\": {
    \"project\": {\"key\": \"AUTH\"},
    \"summary\": \"Test issue\",
    \"issuetype\": {\"name\": \"Bug\"}
  }
}"
```

**✅ Pros:**
- Works immediately - no setup
- No MCP server needed
- Handles JSON automatically

**❌ Cons:**
- Can't save default headers
- Must specify full URLs each time
- No environment variable substitution

---

## 🥈 Option 2: Use `curl` via Filesystem + Bash

Since you have `filesystem` and `git` MCPs, use shell commands:

### Step 1: Create a request script

Create `scripts/api-call.sh`:

```bash
#!/bin/bash
# api-call.sh - Helper for API calls

API_BASE=${API_BASE:-"https://api.github.com"}
TOKEN=${TOKEN:-$GITHUB_TOKEN}

curl -s -H "Authorization: Bearer $TOKEN" \
     -H "Accept: application/vnd.github+json" \
     "$API_BASE/$1"
```

### Step 2: Call from Claude

```bash
# In Claude:
"Run the script scripts/api-call.sh with 'repos/org/repo/pulls'"
```

Claude uses **filesystem MCP** to read the script, then you execute it.

---

## 🥉 Option 3: HTTPIE (http) via npx

**httpie** is a user-friendly HTTP client:

```bash
# Install once
npm install -g httpie

# Or use via npx
npx httpie get https://api.github.com/user "Authorization:Bearer $GITHUB_TOKEN"
```

### Claude Config:

```json
{
  "mcpServers": {
    "httpie": {
      "command": "npx",
      "args": ["-y", "httpie"]
    }
  }
}
```

**⚠️ Note:** httpie as MCP server is experimental. Better to use as CLI tool.

---

## 🔧 Option 4: Simple Node.js Script (Custom MCP)

For your on-prem tools, create a simple wrapper:

### `scripts/github-api.js`

```javascript
#!/usr/bin/env node
const https = require('https');

const token = process.env.GITHUB_TOKEN;
const baseUrl = process.env.GITHUB_URL || 'https://api.github.com';
const endpoint = process.argv[2];

const options = {
  hostname: baseUrl.replace('https://', '').replace('http://', ''),
  path: `/api/v3/${endpoint}`,
  method: 'GET',
  headers: {
    'Authorization': `Bearer ${token}`,
    'User-Agent': 'Claude-MCP'
  }
};

const req = https.request(options, (res) => {
  let data = '';
  res.on('data', (chunk) => data += chunk);
  res.on('end', () => console.log(data));
});

req.on('error', (e) => console.error(e));
req.end();
```

### Usage in Claude:

```bash
"Run: node scripts/github-api.js repos/org/backend/pulls"
```

---

## 🎯 Option 5: Use `xh` (Modern curl Alternative)

**xh** is a fast, friendly HTTP client:

```bash
# Install globally
npm install -g xh

# Or use via npx
npx xh get https://api.github.com/user Authorization:"Bearer $GITHUB_TOKEN"
```

**Example for SonarQube:**
```bash
npx xh get https://sonar.company.com/api/issues/search \
  componentKeys==backend \
  severities==CRITICAL \
  "Authorization:Basic $(echo -n '$SONAR_TOKEN:' | base64)"
```

---

## 💡 Recommended Approach for Your Stack

### For GitHub Enterprise:

**Option A - Use GitHub CLI (gh):**
```bash
# Already in your repo
gh pr list --repo org/backend
gh issue list --repo org/backend --label bug
```

Claude can run `gh` commands directly via the **filesystem + git** context.

**Option B - Native fetch in Claude:**
```bash
"List open PRs in backend repo using GET https://github.company.com/api/v3/repos/org/backend/pulls"
```

### For SonarQube:

**Create a simple wrapper script:**

`scripts/sonar-query.sh`:
```bash
#!/bin/bash
PROJECT=$1
METRICS=${2:-"coverage,bugs,vulnerabilities"}

curl -s -u "$SONAR_TOKEN:" \
  "https://sonar.company.com/api/measures/component?component=$PROJECT&metricKeys=$METRICS"
```

**Usage in Claude:**
```bash
"Run scripts/sonar-query.sh with project backend"
```

### For JIRA:

**Use native fetch or create wrapper:**

`scripts/jira-create.sh`:
```bash
#!/bin/bash
PROJECT=$1
SUMMARY=$2
TYPE=${3:-Bug}

curl -s -X POST \
  -H "Authorization: Bearer $JIRA_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"fields\": {
      \"project\": {\"key\": \"$PROJECT\"},
      \"summary\": \"$SUMMARY\",
      \"issuetype\": {\"name\": \"$TYPE\"}
    }
  }" \
  "https://jira.company.com/rest/api/2/issue"
```

---

## 🚀 Quick Win: Hybrid Approach

Since you already have these MCPs working:
- ✅ **filesystem** - Browse files
- ✅ **git** - Git operations  
- ✅ **memory** - Persistent context

**You don't need a dedicated HTTP MCP!**

Just use:
1. **Claude's native fetch** for simple requests
2. **Shell scripts** (run via filesystem context) for complex operations
3. **GitHub CLI (gh)** for GitHub operations

### Example Workflow:

```bash
# In Claude
"Check SonarQube quality for backend project"

→ Claude uses native fetch or runs your wrapper script

"Get the output and show me critical issues"

→ Claude parses JSON and presents results
```

---

## 📝 Updated Claude Config (Without Fetch MCP)

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/your/projects/path"]
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

**No fetch MCP needed!** Use Claude's built-in capabilities + shell scripts.

---

## 🔧 Shell Scripts Provided

This repo now includes helper scripts:

| Script | Purpose | Usage |
|--------|---------|-------|
| `scripts/api-call.sh` | Generic API wrapper | Customize for your endpoints |
| `scripts/github-api.js` | GitHub-specific | Node.js wrapper |
| `scripts/sonar-query.sh` | SonarQube queries | GET metrics/issues |
| `scripts/jira-create.sh` | JIRA ticket creation | POST new issues |
| `scripts/curl-wrapper-mcp.sh` | Generic curl wrapper | Flexible HTTP |

---

## ✅ Summary

| Method | Best For | Setup |
|--------|----------|-------|
| **Claude native fetch** | Quick queries | None ✅ |
| **Shell scripts** | Complex workflows | Create once, reuse |
| **GitHub CLI (gh)** | GitHub operations | Already installed? |
| **xh/httpie** | Modern HTTP client | `npm install -g` |

**Recommendation:** Start with **Claude's native fetch** + **custom shell scripts** for your specific endpoints.

---

**See `scripts/` directory for ready-to-use wrappers!**
