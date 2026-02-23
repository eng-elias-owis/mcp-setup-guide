# /sonar-scan

Check SonarQube quality metrics for a project.

## Usage

```
/sonar-scan <project-key>
/sonar-scan backend
/sonar-scan auth-service --critical-only
```

## Steps

1. Query SonarQube for project metrics
2. Check quality gate status
3. List critical/blocker issues
4. Show coverage and duplications
5. Compare to previous scan

## Output

- Quality gate status
- Issue breakdown by severity
- Code coverage %
- Duplication %
- Top issues to fix

## Example

```
> /sonar-scan backend

🔍 SonarQube Report: backend

🚦 Quality Gate: ✅ PASS

📊 Metrics:
   - Coverage: 82% ▲ 3%
   - Duplications: 1.2%
   - Complexity: 8.5 avg
   - Issues: 0 Critical, 2 Major, 12 Minor

🔴 Critical Issues:
   None! 🎉

🟡 Major Issues:
   1. src/api/users.js:45 - Security hotspot
   2. src/db/connection.js:12 - Resource leak

📈 Trend: Improved from last week
```
