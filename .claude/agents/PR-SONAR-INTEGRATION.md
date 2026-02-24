# PR + SonarQube Integration Guide

How to use PR Reviewer and SonarQube agents together to read PR changes, analyze issues, and suggest fixes.

## The Workflow

### Scenario: Review PR with SonarQube Issues

```bash
# Step 1: Start with PR Reviewer
Switch to pr-reviewer agent
"Review PR #123 in backend repository"
```

**PR Reviewer does:**
1. Fetches PR details from GitHub
2. Gets changed files
3. Fetches SonarQube analysis for the PR
4. Identifies new issues
5. Reads affected code (filesystem MCP)
6. Suggests fixes

---

## Complete Example

### User Request:
```
"Review PR #456 in auth-service and fix any SonarQube issues"
```

### Step-by-Step Process:

#### 1. Get PR Information
```bash
GET ${GITHUB_URL}/api/v3/repos/org/auth-service/pulls/456
Authorization: Bearer ${GITHUB_TOKEN}
```

Response:
```json
{
  "number": 456,
  "title": "Add user authentication",
  "head": { "ref": "feature/auth", "sha": "abc123" },
  "base": { "ref": "main" },
  "user": { "login": "john.doe" },
  "additions": 150,
  "deletions": 20,
  "changed_files": 5
}
```

#### 2. Get Changed Files
```bash
GET ${GITHUB_URL}/api/v3/repos/org/auth-service/pulls/456/files
Authorization: Bearer ${GITHUB_TOKEN}
```

Response:
```json
[
  {
    "filename": "src/main/java/AuthController.java",
    "status": "modified",
    "additions": 80,
    "deletions": 10,
    "patch": "@@ -35,10 +35,90 @@ public class..."
  },
  {
    "filename": "src/main/java/UserService.java",
    "status": "added",
    "additions": 60,
    "deletions": 0
  }
]
```

#### 3. Get SonarQube Analysis

**Quality Gate:**
```bash
GET ${SONAR_URL}/api/qualitygates/project_status?
  projectKey=auth-service&
  pullRequest=456
Authorization: Basic ${SONAR_TOKEN}:
```

**New Issues:**
```bash
GET ${SONAR_URL}/api/issues/search?
  componentKeys=auth-service&
  pullRequest=456&
  resolved=false
Authorization: Basic ${SONAR_TOKEN}:
```

Response:
```json
{
  "issues": [
    {
      "key": "AX8xyz123",
      "rule": "java:S2259",
      "severity": "BLOCKER",
      "component": "auth-service:src/main/java/AuthController.java",
      "line": 42,
      "message": "A NullPointerException might be thrown...",
      "type": "BUG"
    },
    {
      "key": "AX8xyz124",
      "rule": "java:S2095",
      "severity": "CRITICAL",
      "component": "auth-service:src/main/java/UserService.java",
      "line": 25,
      "message": "Use try-with-resources or close this...",
      "type": "BUG"
    }
  ]
}
```

#### 4. Read Affected Code

**Use filesystem MCP:**
```
Read src/main/java/AuthController.java starting from line 35 to 50
```

Current code:
```java
public String authenticate(String username, String password) {
    User user = userRepository.findByUsername(username);  // Line 42
    if (user.getPassword().equals(password)) {          // NPE risk!
        return generateToken(user);
    }
    return null;
}
```

**Read second issue:**
```
Read src/main/java/UserService.java starting from line 20 to 35
```

Current code:
```java
public List<User> loadUsers() {
    InputStream is = new FileInputStream("users.csv");  // Line 25
    return csvParser.parse(is);  // Resource leak!
}
```

#### 5. Analyze and Suggest Fixes

**Issue 1: NullPointerException (java:S2259)**

**Problem:** `user` may be null if username not found

**Fix:**
```java
public String authenticate(String username, String password) {
    User user = userRepository.findByUsername(username);
    if (user == null) {
        throw new AuthenticationException("User not found: " + username);
    }
    if (user.getPassword().equals(password)) {
        return generateToken(user);
    }
    throw new AuthenticationException("Invalid credentials");
}
```

**Issue 2: Resource Leak (java:S2095)**

**Problem:** InputStream not closed

**Fix:**
```java
public List<User> loadUsers() {
    try (InputStream is = new FileInputStream("users.csv")) {
        return csvParser.parse(is);
    } catch (IOException e) {
        throw new UserLoadException("Failed to load users", e);
    }
}
```

#### 6. Generate Review Report

```markdown
## PR Review #456: Add user authentication

**Author:** @john.doe  
**Branch:** feature/auth → main  
**SonarQube Quality Gate:** ❌ FAIL (2 new issues)

### New Issues Found

#### 🔴 BLOCKER: NullPointerException Risk
**File:** `src/main/java/AuthController.java:42`
**Rule:** java:S2259
**Problem:** User may be null before calling getPassword()

**Current Code:**
```java
User user = userRepository.findByUsername(username);
if (user.getPassword().equals(password)) {  // NPE if user is null
```

**Suggested Fix:**
```java
User user = userRepository.findByUsername(username);
if (user == null) {
    throw new AuthenticationException("User not found: " + username);
}
if (user.getPassword().equals(password)) {
```

---

#### 🔴 CRITICAL: Resource Leak  
**File:** `src/main/java/UserService.java:25`
**Rule:** java:S2095
**Problem:** InputStream not closed, resource leak

**Current Code:**
```java
InputStream is = new FileInputStream("users.csv");
return csvParser.parse(is);  // Leaks if exception thrown
```

**Suggested Fix:**
```java
try (InputStream is = new FileInputStream("users.csv")) {
    return csvParser.parse(is);
} catch (IOException e) {
    throw new UserLoadException("Failed to load users", e);
}
```

### Action Items
- [ ] Fix NPE risk in AuthController.java
- [ ] Fix resource leak in UserService.java  
- [ ] Add unit tests for null user case
- [ ] Run SonarQube scan to verify fixes

### Verdict
**🔴 Request Changes** - Security issues must be fixed before merge
```

---

## Advanced: Auto-Fix Suggestions

### For Simple Issues, Provide Exact Fix

```java
// SonarQube Issue: java:S1128 (Unused import)
// File: AuthController.java, Line 3

// BEFORE:
import java.util.Date;
import java.time.LocalDateTime;  // This is used
import java.util.List;           // This is NOT used

// AFTER (suggested fix):
import java.time.LocalDateTime;
import java.util.List;  // Remove this line
```

### For Complex Issues, Provide Options

```java
// SonarQube Issue: java:S3776 (Cognitive complexity)
// Multiple approaches available

// Option 1: Extract method (recommended)
// Option 2: Use early returns
// Option 3: Stream API refactor
```

---

## Integration with Other Tools

### Create JIRA Ticket for Issue

After identifying issues:
```bash
Switch to jira-api-agent
"Create ticket for AuthController NPE issue in AUTH project"
```

### Document Fix in Confluence

```bash
Switch to confluence-api-agent  
"Create page 'Authentication Security Review' in TEAM space"
```

### Check Test Coverage

```bash
Switch to sonarqube-api-agent
"Check coverage for AuthController in auth-service project"
```

---

## Quick Reference: Common PR + SonarQube Commands

### Basic PR Review
```bash
# Review PR with SonarQube analysis
Switch to pr-reviewer agent
"Review PR #123 in backend repository"
```

### Deep Issue Analysis
```bash
# Get detailed issue information
Switch to sonarqube-api-agent
"Get details for issue AX8xyz123 in backend project"

# Read affected code
"Read src/main/java/Auth.java around line 42"

# Suggest fix
"Suggest fix for NPE issue at line 42"
```

### Fix Multiple Issues
```bash
# Get all critical issues
Switch to sonarqube-api-agent
"List all critical issues in backend project that are new in PR #123"

# Batch analyze
"Analyze all null pointer issues and suggest fixes"
```

---

## Automation Script

Save as `scripts/review-pr.sh`:

```bash
#!/bin/bash
# review-pr.sh - Automated PR review with SonarQube

PR_NUMBER=$1
REPO=$2
PROJECT_KEY=$3

if [ -z "$PR_NUMBER" ] || [ -z "$REPO" ] || [ -z "$PROJECT_KEY" ]; then
    echo "Usage: $0 <pr-number> <repo> <sonar-project-key>"
    exit 1
fi

echo "Reviewing PR #$PR_NUMBER in $REPO..."

# Get PR info
gh pr view $PR_NUMBER --repo $REPO --json number,title,headRefName,baseRefName

# Get SonarQube analysis
echo "SonarQube Quality Gate:"
curl -s -u "$SONAR_TOKEN:" \
  "$SONAR_URL/api/qualitygates/project_status?projectKey=$PROJECT_KEY&pullRequest=$PR_NUMBER" | \
  python3 -c "import sys,json; d=json.load(sys.stdin); print(d['projectStatus']['status'])"

# Get new issues
echo "New Issues:"
curl -s -u "$SONAR_TOKEN:" \
  "$SONAR_URL/api/issues/search?componentKeys=$PROJECT_KEY&pullRequest=$PR_NUMBER&resolved=false" | \
  python3 -c "import sys,json; d=json.load(sys.stdin); print(f\"Found {d['total']} issues\")"
```

---

## Best Practices

### 1. Always Read Code Before Suggesting
```bash
# Bad: Suggest fix without reading
# Good: Read first, then suggest
"Read src/main/java/Auth.java lines 35-50"
"The user object can be null, suggest null check"
```

### 2. Provide Before/After
Always show:
- Current problematic code
- Fixed code
- Why the fix works

### 3. Consider Side Effects
```
"This fix handles null, but what about:
- Empty username?
- Whitespace in username?
- Case sensitivity?"
```

### 4. Test Suggestions
```
"After applying this fix, verify:
1. Run unit tests
2. Run SonarQube scan
3. Check no new issues introduced"
```

---

## Troubleshooting

### "SonarQube shows no issues for PR"
- PR analysis may not be configured
- Check: `sonar.pullrequest.key=${PR_NUMBER}` in CI
- May need to trigger analysis manually

### "Cannot read file"
- File path may be different in filesystem vs SonarQube
- SonarQube: `src/main/java/Auth.java`
- Filesystem: May need full path
- Try: Read `src/main/java/Auth.java` or full absolute path

### "Issue location doesn't match code"
- Code may have changed since SonarQube scan
- Re-run SonarQube analysis
- Check `textRange` for exact offset

---

## Summary

The agents work together:

1. **pr-reviewer agent**: Fetches PR, gets SonarQube analysis
2. **sonarqube-api-agent**: Reads issue details, gets rule info
3. **filesystem MCP**: Reads actual code
4. **Combined**: Suggests specific, contextual fixes

**Result:** Automated PR review with actionable fix suggestions! 🎉
