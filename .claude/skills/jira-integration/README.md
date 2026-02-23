# JIRA Integration Skill

This skill enables Claude to interact with your on-prem JIRA Server/Data Center.

## Overview

Create, search, and update JIRA tickets directly from Claude.

## Configuration

Requires these environment variables:
```bash
export JIRA_URL="https://jira.your-company.com"
export JIRA_TOKEN="your_personal_access_token"
```

## Capabilities

### 1. Create Ticket
```
Create a bug ticket for the login timeout issue
```

### 2. Search Tickets
```
Find all open tickets assigned to me in the AUTH project
```

### 3. Get Ticket Details
```
Show details for AUTH-1234
```

### 4. Update Status
```
Move AUTH-1234 to "In Progress"
```

### 5. Add Comment
```
Comment on AUTH-1234: "Working on the fix, ETA tomorrow"
```

## API Endpoints

| Purpose | Endpoint |
|---------|----------|
| Get issue | `/rest/api/2/issue/{key}` |
| Search (JQL) | `/rest/api/2/search?jql={query}` |
| Create | `/rest/api/2/issue` (POST) |
| Update | `/rest/api/2/issue/{key}` (PUT) |
| Transitions | `/rest/api/2/issue/{key}/transitions` |
| Comment | `/rest/api/2/issue/{key}/comment` (POST) |

## Authentication

```
Authorization: Bearer ${JIRA_TOKEN}
```

## Common JQL Queries

### My Open Tickets
```sql
assignee = currentUser() AND status != Done
```

### High Priority Bugs
```sql
project = AUTH AND type = Bug AND priority in (High, Critical, Blocker) AND status != Done
```

### Tickets in Sprint
```sql
project = AUTH AND sprint in openSprints()
```

### Recently Created
```sql
project = AUTH AND created >= -7d
```

### Tickets by Label
```sql
project = AUTH AND labels = "security"
```

## Request Examples

### Create Issue
```bash
POST ${JIRA_URL}/rest/api/2/issue
Content-Type: application/json
Authorization: Bearer ${JIRA_TOKEN}

{
  "fields": {
    "project": {"key": "AUTH"},
    "summary": "Login timeout bug",
    "description": "Users are logged out after 5 minutes",
    "issuetype": {"name": "Bug"},
    "priority": {"name": "High"},
    "labels": ["security", "urgent"]
  }
}
```

### Search with JQL
```bash
GET ${JIRA_URL}/rest/api/2/search?
  jql=project=AUTH+AND+assignee=currentUser()+AND+status!=Done&
  fields=summary,status,priority
```

### Add Comment
```bash
POST ${JIRA_URL}/rest/api/2/issue/AUTH-1234/comment
Content-Type: application/json

{
  "body": "Deployed fix to staging, ready for testing"
}
```

## Response Format

### Issue Created
```json
{
  "id": "10001",
  "key": "AUTH-1234",
  "self": "https://jira.company.com/rest/api/2/issue/10001"
}
```

### Search Results
```json
{
  "issues": [
    {
      "key": "AUTH-1234",
      "fields": {
        "summary": "Login timeout bug",
        "status": {"name": "In Progress"},
        "priority": {"name": "High"}
      }
    }
  ]
}
```

## Issue Types

| Type | Use For |
|------|---------|
| Bug | Defects, errors |
| Task | General work |
| Story | User stories |
| Improvement | Enhancements |
| Epic | Large features |

## Priority Levels

| Priority | Response Time |
|----------|---------------|
| Blocker | Immediate |
| Critical | 4 hours |
| High | 24 hours |
| Medium | 3 days |
| Low | Next sprint |

## Error Handling

| Status | Cause | Solution |
|--------|-------|----------|
| 401 | Invalid token | Regenerate PAT |
| 403 | Wrong permissions | Request access |
| 404 | Issue not found | Check issue key |
| 400 | Invalid fields | Check field names |

## Best Practices

1. **Use descriptive summaries** - "Fix login bug" → "Fix: Session timeout after 5 min on auth service"
2. **Add labels** - For filtering and reporting
3. **Link to PRs** - Include PR number in comments
4. **Update status** - Keep tickets current
5. **Close with resolution** - Add comment when closing

## Ticket Templates

### Bug Template
```
**Description:**
[What happened]

**Steps to Reproduce:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected:**
[What should happen]

**Actual:**
[What actually happened]

**Environment:**
- Version: [version]
- Browser: [if applicable]

**Screenshots:**
[If applicable]
```

### Feature Template
```
**Description:**
[What should be built]

**User Story:**
As a [role], I want [feature] so that [benefit]

**Acceptance Criteria:**
- [ ] Criteria 1
- [ ] Criteria 2
- [ ] Criteria 3

**Technical Notes:**
[Any implementation details]
```

## Troubleshooting

### "Cannot create issue"
- Verify JIRA_TOKEN has Create Issues permission
- Check project key is correct
- Ensure required fields are provided

### "JQL search returns empty"
- Use URL encoding: `+` for spaces, `%3D` for `=`
- Check field names match JIRA (case-sensitive)
- Verify user has Browse Projects permission

### "Transitions not working"
- Get available transitions first: `/issue/{key}/transitions`
- Transition IDs vary by workflow
- Use transition ID, not name
