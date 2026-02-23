# SonarQube Integration Skill

This skill enables Claude to interact with your on-prem SonarQube Server for code quality analysis.

## Overview

Query SonarQube metrics, issues, and quality gates directly from Claude using the Fetch MCP.

## Configuration

Requires these environment variables:
```bash
export SONAR_URL="https://sonar.your-company.com"
export SONAR_TOKEN="squ_your_token_here"
```

## Capabilities

### 1. Check Quality Gate
```
Is the backend project passing the quality gate?
```

### 2. Find Issues
```
Show me critical issues in auth-service
```

### 3. Get Coverage
```
What's the code coverage for the payment module?
```

### 4. Security Hotspots
```
List security hotspots that need review
```

## API Endpoints

| Purpose | Endpoint |
|---------|----------|
| Project status | `/api/qualitygates/project_status?projectKey={key}` |
| Issues | `/api/issues/search?componentKeys={key}` |
| Metrics | `/api/measures/component?component={key}&metricKeys={metrics}` |
| Hotspots | `/api/hotspots/search?projectKey={key}` |

## Authentication

```
Authorization: Basic ${SONAR_TOKEN}:
```

Note: The colon after the token is required for Basic auth.

## Common Metrics

```javascript
const metrics = [
  "coverage",              // Line coverage %
  "bugs",                  // Number of bugs
  "vulnerabilities",       // Security issues
  "code_smells",          // Maintainability issues
  "complexity",           // Cyclomatic complexity
  "duplicated_lines_density", // Duplication %
  "test_errors",          // Test failures
  "test_failures",        // Failed tests
  "tests"                 // Total tests
];
```

## Example Queries

### Get Project Summary
```bash
GET ${SONAR_URL}/api/measures/component?
  component=backend&
  metricKeys=coverage,bugs,vulnerabilities,code_smells,complexity
```

### Find Critical Issues
```bash
GET ${SONAR_URL}/api/issues/search?
  componentKeys=backend&
  severities=CRITICAL,BLOCKER&
  resolved=false
```

### Get Coverage Trend
```bash
GET ${SONAR_URL}/api/measures/search_history?
  component=backend&
  metrics=coverage&
  ps=1000
```

## Response Format

### Quality Gate Response
```json
{
  "projectStatus": {
    "status": "OK",  // or "ERROR"
    "conditions": [
      {
        "status": "OK",
        "metricKey": "coverage",
        "actualValue": "82.5",
        "errorThreshold": "80.0"
      }
    ]
  }
}
```

### Issues Response
```json
{
  "issues": [
    {
      "key": "AWsJlZ...",
      "rule": "java:S106",
      "severity": "MAJOR",
      "component": "backend:src/Main.java",
      "line": 42,
      "message": "Replace this use of System.out..."
    }
  ]
}
```

## Error Handling

| Status | Cause | Solution |
|--------|-------|----------|
| 401 | Invalid token | Check SONAR_TOKEN |
| 403 | Insufficient permissions | Contact SonarQube admin |
| 404 | Project not found | Verify project key |
| 500 | Server error | Retry or contact admin |

## Best Practices

1. **Always check quality gate** before merging PRs
2. **Review new issues** in the leak period (new code)
3. **Set coverage targets** per project
4. **Address security hotspots** promptly
5. **Schedule regular scans** in CI/CD

## Troubleshooting

### "Cannot connect to SonarQube"
- Verify SONAR_URL is correct
- Check network/VPN access
- Test: `curl ${SONAR_URL}/api/system/status`

### "401 Unauthorized"
- Regenerate token in SonarQube
- Ensure token has Browse permission
- Use `Basic ${TOKEN}:` format

### "Empty results"
- Project key is case-sensitive
- Project may not be analyzed yet
- Check analysis date in SonarQube UI
