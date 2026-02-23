# Troubleshooting

Common issues and solutions.

## Installation Issues

### "npx: command not found"

**Cause:** npm not installed or not in PATH

**Solution:**
```bash
# Check if node is installed
which node || echo "Node not found"

# Install Node.js 18+
# macOS
brew install node

# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

---

### "Cannot find module '@modelcontextprotocol/server-fetch'"

**Cause:** npx cache issue

**Solution:**
```bash
# Clear npx cache
rm -rf ~/.npm/_npx

# Try again
npx -y @modelcontextprotocol/server-fetch
```

---

## Configuration Issues

### "Environment variable GITHUB_TOKEN not set"

**Cause:** Secrets not loaded

**Solution:**
```bash
# Source the secrets file
source configs/secrets.env

# Verify
env | grep GITHUB
```

---

### "Permission denied on secrets.env"

**Cause:** Wrong file permissions

**Solution:**
```bash
# Fix permissions
chmod 600 configs/secrets.env

# Verify
ls -la configs/secrets.env
# Should show: -rw-------
```

---

## MCP Server Issues

### Filesystem MCP: "Path not found"

**Cause:** Wrong path in config

**Solution:**
```bash
# Check the path exists
ls -la /path/to/your/repos

# Update config
nano configs/claude-config.json
```

---

### Fetch MCP: "Connection refused"

**Cause:** Cannot reach on-prem tools

**Solution:**
```bash
# Test connectivity
curl -I https://github.your-company.com
curl -I https://sonar.your-company.com

# If fails, check VPN/proxy
# Contact IT for network access
```

---

### Git MCP: "Not a git repository"

**Cause:** Not in a git directory

**Solution:**
```bash
# Navigate to git repo
cd /path/to/your/git/repo

# Or use filesystem MCP to browse first
```

---

## API Issues

### "401 Unauthorized" from GitHub

**Cause:** Invalid or expired token

**Solution:**
```bash
# Test token
curl -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://github.your-company.com/api/v3/user

# If fails, regenerate token
```

---

### "403 Forbidden" from SonarQube

**Cause:** Insufficient permissions

**Solution:**
- Check token has "Browse" permission
- Try with admin token to verify
- Contact SonarQube admin

---

### "404 Not Found" from JIRA

**Cause:** Wrong URL or ticket doesn't exist

**Solution:**
```bash
# Test base URL
curl -H "Authorization: Bearer $JIRA_TOKEN" \
  $JIRA_URL/rest/api/2/myself

# Check ticket exists in browser
```

---

## Claude-Specific Issues

### "MCP server not found"

**Cause:** Config not loaded

**Solution:**
```bash
# Check config location
ls -la ~/.config/claude/
ls -la ~/.claude/

# Copy to correct location
cp configs/claude-config.json ~/.config/claude/
# or
cp configs/claude-config.json ~/.claude/
```

---

### "Server crashed"

**Cause:** MCP server error

**Solution:**
```bash
# Restart Claude
exit
claude

# Check logs
claude config get mcpServers
```

---

## Network Issues

### Corporate Proxy

If behind corporate proxy:

```bash
# Set proxy for npx
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=http://proxy.company.com:8080

# Then run npx
npx -y @modelcontextprotocol/server-fetch
```

---

### SSL Certificate Issues

```bash
# Temporarily disable (not recommended for prod)
npm config set strict-ssl false

# Better: Add corp CA cert
npm config set cafile /path/to/corp-ca.crt
```

---

## Getting Help

### Check Logs

```bash
# Claude logs
ls -la ~/.config/claude/logs/

# MCP server output
# Run manually to see errors:
npx -y @modelcontextprotocol/server-fetch 2>&1
```

### Test Individual Components

```bash
# Test secrets loaded
source configs/secrets.env
echo $GITHUB_URL

# Test npx
npx --version

# Test MCP server
npx -y @modelcontextprotocol/server-fetch --help
```

### Debug Mode

Run Claude with debug output:
```bash
DEBUG=mcp* claude
```

---

## Quick Diagnostic Script

Run this to check everything:

```bash
#!/bin/bash
echo "=== MCP Diagnostic ==="

echo -n "Node.js: "
node --version || echo "❌ NOT FOUND"

echo -n "npx: "
npx --version || echo "❌ NOT FOUND"

echo -n "Claude: "
which claude || echo "❌ NOT FOUND"

echo ""
echo "=== Environment ==="
env | grep -E "GITHUB|SONAR|JIRA|CONFLUENCE" | cut -d= -f1

echo ""
echo "=== Secrets File ==="
ls -la configs/secrets.env 2>/dev/null || echo "❌ NOT FOUND"

echo ""
echo "=== Config ==="
ls -la ~/.config/claude/mcp-config.json 2>/dev/null || \
ls -la ~/.claude/mcp-config.json 2>/dev/null || \
echo "❌ NOT FOUND"

echo ""
echo "=== Network ==="
curl -s -o /dev/null -w "%{http_code}" $GITHUB_URL 2>/dev/null || echo "❌"
```

---

## Still Stuck?

1. Check [docs/05-api-reference.md](05-api-reference.md) for API details
2. Review [docs/04-security.md](04-security.md) for token issues
3. Ask your IT team about network access
4. Open issue in this repo with diagnostic output
