# GitHub Enterprise API Examples

Examples of using Fetch MCP with GitHub Enterprise Server.

## List Open PRs

```
Use Fetch MCP to list open PRs in the backend repository
```

Claude constructs:
```bash
GET https://github.company.com/api/v3/repos/your-org/backend/pulls?state=open
Authorization: Bearer ${GITHUB_TOKEN}
```

## Get PR Details

```
Show me details for PR #123 in the backend repo
```

Claude constructs:
```bash
GET https://github.company.com/api/v3/repos/your-org/backend/pulls/123
Authorization: Bearer ${GITHUB_TOKEN}
```

## List Issues with Label

```
Find all bug issues in the auth-service project
```

Claude constructs:
```bash
GET https://github.company.com/api/v3/repos/your-org/auth-service/issues?labels=bug&state=open
Authorization: Bearer ${GITHUB_TOKEN}
```

## Search Code

```
Search for TODO comments in the backend repository
```

Claude constructs:
```bash
GET https://github.company.com/api/v3/search/code?q=TODO+repo:your-org/backend
Authorization: Bearer ${GITHUB_TOKEN}
```

## Get File Content

```
Show me the content of src/auth.js from the main branch
```

Claude constructs:
```bash
GET https://github.company.com/api/v3/repos/your-org/backend/contents/src/auth.js?ref=main
Authorization: Bearer ${GITHUB_TOKEN}
```

## List Repository Commits

```
Show recent commits in the backend repo
```

Claude constructs:
```bash
GET https://github.company.com/api/v3/repos/your-org/backend/commits?sha=main&per_page=10
Authorization: Bearer ${GITHUB_TOKEN}
```

## Check Review Status

```
Who reviewed PR #123?
```

Claude constructs:
```bash
GET https://github.company.com/api/v3/repos/your-org/backend/pulls/123/reviews
Authorization: Bearer ${GITHUB_TOKEN}
```

## Common Patterns

### Filter by Author
```bash
GET /api/v3/repos/ORG/REPO/pulls?state=open&head=ORG:feature-branch
```

### Get Check Runs (CI Status)
```bash
GET /api/v3/repos/ORG/REPO/commits/SHA/check-runs
```

### List Repository Branches
```bash
GET /api/v3/repos/ORG/REPO/branches
```

---

## Tips

- Always specify `state=open` or `state=closed` for clarity
- Use `per_page=100` for larger result sets (max 100)
- Add `?since=YYYY-MM-DDTHH:MM:SSZ` for date filtering
- Use search API for complex queries across repos
