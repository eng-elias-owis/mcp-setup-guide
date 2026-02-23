# Security Best Practices

Secure token management for enterprise environments.

## 🔐 Core Principles

1. **Never commit tokens to git**
2. **Use environment variables**
3. **Restrict file permissions**
4. **Rotate tokens regularly**
5. **Use least-privilege access**

---

## Token Storage Methods

### Method 1: Environment Variables (Recommended)

**File:** `configs/secrets.env`

```bash
export GITHUB_TOKEN="ghp_xxxxxxxx"
export SONAR_TOKEN="squ_xxxxxxxx"
export JIRA_TOKEN="xxxxxxxx"
export CONFLUENCE_TOKEN="xxxxxxxx"
```

**Secure it:**
```bash
chmod 600 configs/secrets.env
```

**Load in shell:**
```bash
source configs/secrets.env
```

**Auto-load (optional):**
Add to `~/.bashrc`:
```bash
source /path/to/mcp-setup-guide/configs/secrets.env
```

---

### Method 2: macOS Keychain

**Store token:**
```bash
security add-generic-password -s "mcp-github-token" -a "$USER" -w "ghp_xxx"
```

**Retrieve in script:**
```bash
export GITHUB_TOKEN=$(security find-generic-password -s "mcp-github-token" -w)
```

**Update secrets.env:**
```bash
export GITHUB_TOKEN=$(security find-generic-password -s "mcp-github-token" -w)
```

---

### Method 3: 1Password / Bitwarden CLI

**1Password:**
```bash
export GITHUB_TOKEN=$(op item get "GitHub MCP" --field password)
```

**Bitwarden:**
```bash
export GITHUB_TOKEN=$(bw get password "GitHub MCP")
```

---

## File Permissions

### Required Permissions

```bash
# Secrets file - only owner can read/write
chmod 600 configs/secrets.env

# Template - readable by all, not sensitive
chmod 644 configs/secrets.env.template

# Scripts - executable by owner
chmod 755 scripts/*.sh
```

### Verify Permissions

```bash
ls -la configs/
# Should show:
# -rw------- secrets.env       (600)
# -rw-r--r-- secrets.env.template (644)
```

---

## Token Scope & Permissions

### GitHub Enterprise

**Minimum scopes:**
- `repo` - Repository access
- `read:org` - Organization read
- `read:user` - User read

**Avoid:**
- `admin:org` - Too broad
- `delete_repo` - Destructive

---

### SonarQube

**Minimum permissions:**
- Browse projects
- Read issues
- Read measures

**Avoid:**
- Admin access
- Quality gate admin

---

### JIRA

**Minimum permissions:**
- Browse projects
- Create issues
- Edit own issues
- Add comments

**Avoid:**
- Project admin
- Delete all issues

---

### Confluence

**Minimum permissions:**
- Read content
- Create own content
- Edit own content

**Avoid:**
- Space admin
- Delete all pages

---

## Token Rotation

### Why Rotate?

- Limit exposure if leaked
- Compliance requirements
- Follows security best practices

### Rotation Schedule

| Token Type | Rotation Frequency |
|------------|-------------------|
| GitHub | Every 90 days |
| SonarQube | Every 90 days |
| JIRA | Every 90 days |
| Confluence | Every 90 days |

### Rotation Script

Use `scripts/rotate-tokens.sh`:

```bash
#!/bin/bash
# Token Rotation Helper

echo "Token Rotation Checklist"
echo "======================="
echo ""
echo "GitHub:"
echo "  1. Go to: https://github.company.com/settings/tokens"
echo "  2. Delete old 'claude-mcp' token"
echo "  3. Create new token"
echo "  4. Update GITHUB_TOKEN in configs/secrets.env"
echo ""
echo "SonarQube:"
echo "  1. Go to: https://sonar.company.com/account/security"
echo "  2. Revoke old token"
echo "  3. Create new token"
echo "  4. Update SONAR_TOKEN in configs/secrets.env"
echo ""
# ... etc for JIRA and Confluence
```

---

## .gitignore Protection

**Ensure .gitignore includes:**

```gitignore
# Secrets
configs/secrets.env
*.env
.env
secrets/

# MCP cache
.mcp/

# Claude config with tokens (if you copy it)
claude-config-local.json
```

**Verify:**
```bash
git check-ignore -v configs/secrets.env
# Should show: .gitignore:line_number:configs/secrets.env
```

---

## Audit & Compliance

### Who Has Access?

Document in team wiki:
- Who has tokens
- What scopes granted
- Last rotation date

### Audit Log

Check your tool's audit logs:
- GitHub: `https://github.company.com/settings/security-log`
- SonarQube: Administration > System > Logs
- JIRA: System > Audit Log

---

## Incident Response

### If Token Leaked

1. **Immediately revoke** in the tool's settings
2. **Rotate all tokens** (precaution)
3. **Check audit logs** for unauthorized access
4. **Review code/repos** where token appeared
5. **Document incident** for compliance

### If Committed to Git

1. **Revoke token immediately**
2. **Delete from git history:**
   ```bash
   git filter-branch --force --index-filter \
   'git rm --cached --ignore-unmatch configs/secrets.env' \
   --prune-empty --tag-name-filter cat -- --all
   ```
3. **Force push (careful!):**
   ```bash
   git push origin --force --all
   ```
4. **Notify team** to rebase/clean local copies

---

## Quick Security Checklist

- [ ] `secrets.env` has 600 permissions
- [ ] `secrets.env` is in `.gitignore`
- [ ] Tokens use least-privilege scopes
- [ ] Tokens rotated in last 90 days
- [ ] Not using passwords (only PATs)
- [ ] No tokens in shell history
- [ ] Audit logs reviewed monthly

---

## Next Steps

→ Go to [05-api-reference.md](05-api-reference.md) for API usage examples
