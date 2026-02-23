# API Reference

Common API calls for your on-prem tools via Fetch MCP.

## GitHub Enterprise

### Authentication

```
Authorization: Bearer ${GITHUB_TOKEN}
```

### List Open PRs

```bash
GET ${GITHUB_URL}/api/v3/repos/ORG/REPO/pulls?state=open
```

### Get PR Details

```bash
GET ${GITHUB_URL}/api/v3/repos/ORG/REPO/pulls/123
```

### List Repository Issues

```bash
GET ${GITHUB_URL}/api/v3/repos/ORG/REPO/issues?state=open&labels=bug
```

### Get File Content

```bash
GET ${GITHUB_URL}/api/v3/repos/ORG/REPO/contents/path/to/file.js?ref=main
```

### Search Code

```bash
GET ${GITHUB_URL}/api/v3/search/code?q=TODO+repo:ORG/REPO
```

---

## SonarQube

### Authentication

```
Authorization: Basic ${SONAR_TOKEN}:
```

### List Projects

```bash
GET ${SONAR_URL}/api/projects/search?ps=100
```

### Get Project Issues

```bash
GET ${SONAR_URL}/api/issues/search?componentKeys=PROJECT_KEY&severities=CRITICAL,BLOCKER
```

### Get Quality Gate Status

```bash
GET ${SONAR_URL}/api/qualitygates/project_status?projectKey=PROJECT_KEY
```

### Get Code Metrics

```bash
GET ${SONAR_URL}/api/measures/component?component=PROJECT_KEY&metricKeys=coverage,bugs,vulnerabilities
```

### Get Hotspots (Security)

```bash
GET ${SONAR_URL}/api/hotspots/search?projectKey=PROJECT_KEY&status=TO_REVIEW
```

---

## JIRA

### Authentication

```
Authorization: Bearer ${JIRA_TOKEN}
```

### Get Issue

```bash
GET ${JIRA_URL}/rest/api/2/issue/PROJ-123
```

### Search Issues (JQL)

```bash
GET "${JIRA_URL}/rest/api/2/search?jql=assignee=currentUser()+AND+status!=Done"
```

### Create Issue

```bash
POST ${JIRA_URL}/rest/api/2/issue
Content-Type: application/json

{
  "fields": {
    "project": {"key": "PROJ"},
    "summary": "Bug in authentication",
    "description": "Users cannot login with valid credentials",
    "issuetype": {"name": "Bug"}
  }
}
```

### Update Issue Status

```bash
POST ${JIRA_URL}/rest/api/2/issue/PROJ-123/transitions
Content-Type: application/json

{
  "transition": {"id": "31"}
}
```

### Add Comment

```bash
POST ${JIRA_URL}/rest/api/2/issue/PROJ-123/comment
Content-Type: application/json

{
  "body": "This issue is being worked on in PR #456"
}
```

---

## Confluence

### Authentication

```
Authorization: Bearer ${CONFLUENCE_TOKEN}
```

### Get Page

```bash
GET ${CONFLUENCE_URL}/rest/api/content/PAGE_ID?expand=body.storage
```

### Search Pages

```bash
GET "${CONFLUENCE_URL}/rest/api/content?spaceKey=TEAM&title~API+Documentation"
```

### Create Page

```bash
POST ${CONFLUENCE_URL}/rest/api/content
Content-Type: application/json

{
  "type": "page",
  "title": "API Documentation",
  "space": {"key": "TEAM"},
  "body": {
    "storage": {
      "value": "<h1>API Docs</h1><p>Documentation here...</p>",
      "representation": "storage"
    }
  }
}
```

### Update Page

```bash
PUT ${CONFLUENCE_URL}/rest/api/content/PAGE_ID
Content-Type: application/json

{
  "type": "page",
  "title": "Updated Title",
  "body": {
    "storage": {
      "value": "<p>Updated content</p>",
      "representation": "storage"
    }
  },
  "version": {"number": 2}
}
```

---

## Using in Claude

### Example: Check SonarQube Issues

```
Use the Fetch MCP to get critical issues from SonarQube for project auth-service
```

Claude will:
```bash
# Construct request
GET ${SONAR_URL}/api/issues/search?componentKeys=auth-service&severities=CRITICAL,BLOCKER

# Add auth header
Authorization: Basic ${SONAR_TOKEN}:
```

### Example: Create JIRA Ticket

```
Create a JIRA bug ticket for the login issue in project AUTH
```

Claude will:
```bash
POST ${JIRA_URL}/rest/api/2/issue
{
  "fields": {
    "project": {"key": "AUTH"},
    "summary": "Login authentication failure",
    "issuetype": {"name": "Bug"}
  }
}
```

---

## Claude Prompt Examples

### GitHub

```
"List open PRs in the backend repository"
"Show me PR #123 details"
"Find TODO comments in the auth service"
```

### SonarQube

```
"Get critical security issues for project auth-service"
"What's the code coverage for the backend?"
"Show me SonarQube hotsp[LLM truncated response]