# Prerequisites

Before setting up MCP servers, ensure you have the following installed and configured.

## Required Software

### 1. Node.js 18+ (Essential)

MCP servers run via `npx`, which requires Node.js.

**Check version:**
```bash
node --version  # Should show v18.x.x or higher
```

**Install if needed:**

**macOS:**
```bash
brew install node
```

**Linux (Ubuntu/Debian):**
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

**Windows:**
Download from [nodejs.org](https://nodejs.org/)

---

### 2. Claude Code (Essential)

You should already have this installed.

**Check:**
```bash
claude --version
```

**If not installed:**
```bash
npm install -g @anthropic-ai/claude-code
```

---

### 3. Git (Required for git MCP)

**Check:**
```bash
git --version
```

**Install:** Usually pre-installed. If not:
- macOS: `brew install git`
- Linux: `sudo apt-get install git`
- Windows: [git-scm.com](https://git-scm.com/)

---

## Access Tokens Required

You'll need Personal Access Tokens (PATs) for your on-prem tools:

### GitHub Enterprise Server

**Create token:**
1. Go to `https://github.your-company.com/settings/tokens`
2. Click "Generate new token"
3. Select scopes: `repo`, `read:org`, `read:user`
4. Copy the token (starts with `ghp_`)

**Token name suggestion:** `claude-mcp`

---

### SonarQube Server

**Create token:**
1. Go to `https://sonar.your-company.com/account/security/`
2. Click "Generate Tokens"
3. Name: `claude-mcp`
4. Copy the token (starts with `squ_`)

**Required permissions:**
- Browse projects
- Read issues
- Read measures

---

### JIRA Server/Data Center
n
**Create Personal Access Token:**
1. Go to `https://jira.your-company.com/secure/ViewProfile.jspa`
2. Click "Personal Access Tokens"
3. Click "Create token"
4. Name: `claude-mcp`
5. Copy the token

**Required permissions:**
- Browse projects
- Create issues
- Edit issues
- Add comments

---

### Confluence Server/Data Center

**Create Personal Access Token:**
1. Go to `https://confluence.your-company.com/plugins/personalaccesstokens/usertokens.action`
2. Click "Create token"
3. Name: `claude-mcp`
4. Copy the token

**Required permissions:**
- Read content
- Create content
- Edit content

---

## Network Requirements

Ensure you can reach your on-prem tools:

```bash
# Test GitHub Enterprise
curl -I https://github.your-company.com

# Test SonarQube
curl -I https://sonar.your-company.com

# Test JIRA
curl -I https://jira.your-company.com

# Test Confluence
curl -I https://confluence.your-company.com
```

All should return HTTP 200 or redirect (3xx).

---

## Security Checklist

Before proceeding:

- [ ] Node.js 18+ installed
- [ ] Claude Code installed
- [ ] Git installed
- [ ] GitHub Enterprise PAT created
- [ ] SonarQube token created
- [ ] JIRA PAT created
- [ ] Confluence PAT created
- [ ] Network access verified
- [ ] Tokens stored securely (not in notes/email)

---

## Next Steps

Once you have everything above:

→ Go to [02-installation.md](02-installation.md)
