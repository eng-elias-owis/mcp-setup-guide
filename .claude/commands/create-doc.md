# /create-doc

Create documentation page in Confluence for a feature or API.

## Usage

```
/create-doc "API Authentication Guide"
/create-doc "Database Migration Process" --space=TEAM
```

## Steps

1. Generate documentation from code/context
2. Format in Confluence wiki markup
3. Create page in appropriate space
4. Set parent page if specified
5. Return page URL

## Options

| Option | Description | Default |
|--------|-------------|---------|
| --space | Confluence space key | TEAM |
| --parent | Parent page title | none |
| --template | Doc template type | api, guide, process | api |

## Templates

### API Template
- Overview
- Endpoints
- Request/Response examples
- Error codes

### Guide Template  
- Introduction
- Prerequisites
- Step-by-step instructions
- Troubleshooting

### Process Template
- Purpose
- Roles & responsibilities
- Workflow diagram
- Checklist

## Output

- Page title
- Confluence URL
- Edit link

## Example

```
> /create-doc "Payment API v2" --template=api

📝 Created: Payment API v2
🔗 URL: https://confluence.company.com/display/TEAM/Payment+API+v2

📄 Sections:
   - Overview
   - Authentication
   - POST /v2/payments
   - GET /v2/payments/{id}
   - Error Handling

✅ Ready for team review
```
