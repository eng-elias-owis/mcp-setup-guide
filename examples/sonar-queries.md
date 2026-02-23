# SonarQube API Examples

Examples of using Fetch MCP with SonarQube Server.

## Get Project Issues

```
Get all critical issues for project auth-service from SonarQube
```

Claude constructs:
```bash
GET https://sonar.company.com/api/issues/search?componentKeys=auth-service&severities=CRITICAL,BLOCKER&ps=100
Authorization: Basic ${SONAR_TOKEN}:
```

## Check Quality Gate

```
Is the backend project passing the quality gate?
```

Claude constructs:
```bash
GET https://sonar.company.com/api/qualitygates/project_status?projectKey=backend
Authorization: Basic ${SONAR_TOKEN}:
```

## Get Code Coverage

```
What's the code coverage for the auth-service project?
```

Claude constructs:
```bash
GET https://sonar.company.com/api/measures/component?component=auth-service&metricKeys=coverage,line_coverage,branch_coverage
Authorization: Basic ${SONAR_TOKEN}:
```

## List Security Hotspots

```
Show me security hotspots that need review in the backend project
```

Claude constructs:
```bash
GET https://sonar.company.com/api/hotspots/search?projectKey=backend&status=TO_REVIEW&ps=100
Authorization: Basic ${SONAR_TOKEN}:
```

## Get All Projects

```
List all projects in SonarQube
```

Claude constructs:
```bash
GET https://sonar.company.com/api/projects/search?ps=500
Authorization: Basic ${SONAR_TOKEN}:
```

## Get Issue Details

```
Show me details for issue AWsJlZ... in Sonar
```

Claude constructs:
```bash
GET https://sonar.company.com/api/issues/search?issues=AWsJlZ...&additionalFields=comments,transitions
Authorization: Basic ${SONAR_TOKEN}:
```

## Get Duplications

```
Show code duplications in the backend project
```

Claude constructs:
```bash
GET https://sonar.company.com/api/measures/component?component=backend&metricKeys=duplicated_lines_density,duplicated_blocks
Authorization: Basic ${SONAR_TOKEN}:
```

## Get Complexity Metrics

```
What are the complexity metrics for auth-service?
```

Claude constructs:
```bash
GET https://sonar.company.com/api/measures/component?component=auth-service&metricKeys=complexity,cognitive_complexity,sonarjava_feedback_edge
Authorization: Basic ${SONAR_TOKEN}:
```

## Filter by Issue Type

```
Find all security vulnerabilities in the backend
```

Claude constructs:
```bash
GET https://sonar.company.com/api/issues/search?componentKeys=backend&types=VULNERABILITY&ps=100
Authorization: Basic ${SONAR_TOKEN}:
```

## Get New Code Issues

```
Show issues in new code for this sprint
```

Claude constructs:
```bash
GET https://sonar.company.com/api/issues/search?componentKeys=backend&sinceLeakPeriod=true&ps=100
Authorization: Basic ${SONAR_TOKEN}:
```

## Common Patterns

### High Severity Only
```bash
GET /api/issues/search?componentKeys=PROJECT&severities=CRITICAL,BLOCKER,MAJOR
```

### Specific Rule
```bash
GET /api/issues/search?componentKeys=PROJECT&rules=java:S106
```

### Assigned to Me
```bash
GET /api/issues/search?componentKeys=PROJECT&assignees=myusername
```

### Recently Created
```bash
GET /api/issues/search?componentKeys=PROJECT&createdAfter=2026-01-01
```

---

## Metrics Reference

| Metric | Key | Description |
|--------|-----|-------------|
| Coverage | `coverage` | Line coverage % |
| Bugs | `bugs` | Number of bugs |
| Vulnerabilities | `vulnerabilities` | Security issues |
| Code Smells | `code_smells` | Maintainability issues |
| Complexity | `complexity` | Cyclomatic complexity |
| Duplications | `duplicated_lines_density` | % duplicated lines |

---

## Tips

- Use `ps=100` (page size) to get more results per request
- Add `resolved=false` to show only unresolved issues
- Use `facetMode=count` to get aggregation counts
- Combine multiple metrics with comma: `metricKeys=coverage,bugs,vulnerabilities`
