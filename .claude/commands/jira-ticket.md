# /jira-ticket

Create a JIRA ticket with proper formatting and details.

## Usage

```
/jira-ticket "Fix login timeout bug"
/jira-ticket "Add OAuth2 support" --type=feature --priority=high
```

## Steps

1. Parse ticket title and options
2. Determine project from context or default
3. Set appropriate issue type
4. Add description template
5. Create ticket via JIRA API
6. Return ticket number and URL

## Options

| Option | Values | Default |
|--------|--------|---------|
| --type | bug, feature, task, improvement | bug |
| --priority | blocker, critical, major, minor, trivial | major |
| --project | Project key | AUTH |
| --assignee | Username | Current user |

## Output

- Ticket number (e.g., AUTH-1234)
- Ticket URL
- Confirmation message

## Example

```
> /jira-ticket "Session timeout doesn't redirect to login"

🎫 Created: AUTH-1234
🔗 URL: https://jira.company.com/browse/AUTH-1234

📋 Details:
   - Type: Bug
   - Priority: Major
   - Status: Open
   - Assignee: @you

✅ Next steps:
   1. Add reproduction steps
   2. Estimate effort
   3. Link to PR when ready
```
