# Confluence Integration Skill

This skill enables Claude to create, search, and update Confluence pages.

## Overview

Integrate with your on-prem Confluence Server/Data Center for documentation management.

## Configuration

Requires these environment variables:
```bash
export CONFLUENCE_URL="https://confluence.your-company.com"
export CONFLUENCE_TOKEN="your_personal_access_token"
```

## Capabilities

### 1. Search Pages
```
Find the API authentication documentation
```

### 2. Get Page Content
```
Show me the content of the "Onboarding Guide" page
```

### 3. Create Page
```
Create a new page for the payment API documentation
```

### 4. Update Page
```
Update the deployment guide with the new Docker steps
```

### 5. List Child Pages
```
Show all pages under the Engineering space
```

## API Endpoints

| Purpose | Endpoint |
|---------|----------|
| Get page | `/rest/api/content/{id}` |
| Search | `/rest/api/content?spaceKey={key}&title~{title}` |
| Create | `/rest/api/content` (POST) |
| Update | `/rest/api/content/{id}` (PUT) |
| Get children | `/rest/api/content/{id}/child/page` |
| Get spaces | `/rest/api/space` |

## Authentication

```
Authorization: Bearer ${CONFLUENCE_TOKEN}
```

## Storage Format

Confluence uses **Storage Format** (XML-like):

```xml
<h1>Page Title</h1>
<p>This is a paragraph with <strong>bold</strong> text.</p>
<code>const example = "code block";</code>
<ul>
  <li>Item 1</li>
  <li>Item 2</li>
</ul>
<table>
  <tr><th>Header</th></tr>
  <tr><td>Cell</td></tr>
</table>
```

## Request Examples

### Search Pages
```bash
GET ${CONFLUENCE_URL}/rest/api/content?
  spaceKey=TEAM&
  title~API+Documentation&
  expand=space,body.view
```

### Get Page with Content
```bash
GET ${CONFLUENCE_URL}/rest/api/content/123456?
  expand=body.storage,version
```

### Create Page
```bash
POST ${CONFLUENCE_URL}/rest/api/content
Content-Type: application/json

{
  "type": "page",
  "title": "API Authentication Guide",
  "space": {"key": "TEAM"},
  "body": {
    "storage": {
      "value": "<h1>API Authentication</h1><p>Guide content...</p>",
      "representation": "storage"
    }
  },
  "ancestors": [{"id": 789012}]  // Optional parent page
}
```

### Update Page
```bash
PUT ${CONFLUENCE_URL}/rest/api/content/123456
Content-Type: application/json

{
  "type": "page",
  "title": "Updated Title",
  "body": {
    "storage": {
      "value": "<h1>Updated Content</h1>",
      "representation": "storage"
    }
  },
  "version": {"number": 3}  // Must increment
}
```

## Response Format

### Page Created
```json
{
  "id": "123456",
  "type": "page",
  "status": "current",
  "title": "API Authentication Guide",
  "space": {"key": "TEAM"},
  "_links": {
    "webui": "/display/TEAM/API+Authentication+Guide"
  }
}
```

### Search Results
```json
{
  "results": [
    {
      "id": "123456",
      "title": "API Authentication Guide",
      "type": "page",
      "_links": {
        "webui": "/display/TEAM/API+Authentication+Guide"
      }
    }
  ]
}
```

## Common Space Keys

| Team | Key |
|------|-----|
| Engineering | ENG |
| Product | PROD |
| DevOps | DEVOPS |
| QA | QA |

## Page Templates

### API Documentation Template
```xml
<h1>{API Name}</h1>

<h2>Overview</h2>
<p>{Brief description}</p>

<h2>Authentication</h2>
<p>{Auth method and example}</p>

<h2>Endpoints</h2>

<h3>POST /path</h3>
<p><strong>Description:</strong> {What it does}</p>

<p><strong>Request:</strong></p>
<code>{"example": "request"}</code>

<p><strong>Response:</strong></p>
<code>{"example": "response"}</code>

<h2>Error Codes</h2>
<table>
  <tr><th>Code</th><th>Description</th></tr>
  <tr><td>400</td><td>Bad Request</td></tr>
</table>
```

### Runbook Template
```xml
<h1>{Runbook Title}</h1>

<ac:structured-macro ac:name="info">
  <ac:rich-text-body>
    <p><strong>Last Updated:</strong> {Date}</p>
    <p><strong>Owner:</strong> {Team/Individual}</p>
  </ac:rich-text-body>
</ac:structured-macro>

<h2>Purpose</h2>
<p>{What this runbook addresses}</p>

<h2>Prerequisites</h2>
<ul>
  <li>Access to {system}</li>
  <li>{Tool} permissions</li>
</ul>

<h2>Procedure</h2>

<h3>Step 1: {Action}</h3>
<ol>
  <li>First action</li>
  <li>Second action</li>
</ol>

<h3>Step 2: {Action}</h3>

<h2>Troubleshooting</h2>
<table>
  <tr><th>Symptom</th><th>Solution</th></tr>
  <tr><td>Problem</td><td>Fix</td></tr>
</table>

<h2>Escalation</h2>
<p>If issues persist, contact: {Contact info}</p>
```

## Macro Shortcuts

| You Want | Storage Format |
|----------|----------------|
| Info box | `<ac:structured-macro ac:name="info"><ac:rich-text-body>...` |
| Warning | `<ac:structured-macro ac:name="warning"><ac:rich-text-body>...` |
| Code block | `<ac:structured-macro ac:name="code"><ac:parameter ac:name="language">java</ac:parameter><ac:plain-text-body>...` |
| Expand | `<ac:structured-macro ac:name="expand"><ac:parameter ac:name="title">Click to expand</ac:parameter><ac:rich-text-body>...` |

## Error Handling

| Status | Cause | Solution |
|--------|-------|----------|
| 401 | Invalid token | Regenerate PAT |
| 403 | No create permission | Request from space admin |
| 409 | Version conflict | Get latest, increment version |
| 400 | Invalid storage format | Check XML is well-formed |

## Best Practices

1. **Use templates** - Consistent structure
2. **Set parent pages** - Organize hierarchically
3. **Add labels** - Enable filtering
4. **Version in comments** - Major changes
5. **Link from code** - Reference in README

## Content Conversion

### Markdown → Confluence

| Markdown | Confluence |
|----------|------------|
| `# Heading` | `<h1>Heading</h1>` |
| `**bold**` | `<strong>bold</strong>` |
| `` `code` `` | `<code>code</code>` |
| ```` ```java ```` | `<ac:structured-macro ac:name="code">...` |
| `- item` | `<ul><li>item</li></ul>` |

## Troubleshooting

### "Page not found"
- Check page ID or title
- Verify space key is correct
- Page may have been deleted

### "Version conflict"
- Fetch current version first
- Increment version number
- Re-apply your changes

### "Storage format invalid"
- Validate XML structure
- Escape special characters: `&lt;`, `&gt;`, `&amp;`
- Use CDATA for code blocks

### "No permission"
- Verify token has Write permission
- Check space permissions
- May need space admin approval
