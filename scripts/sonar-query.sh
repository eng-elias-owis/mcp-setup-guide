#!/bin/bash
# sonar-query.sh - SonarQube API wrapper
# Usage: ./sonar-query.sh <project-key> [metrics]
# Example: ./sonar-query.sh backend coverage,bugs,vulnerabilities

set -e

# Check env vars
if [ -z "$SONAR_TOKEN" ]; then
    echo "Error: SONAR_TOKEN not set"
    echo "Load secrets first: source scripts/load-mcp-secrets.sh"
    exit 1
fi

if [ -z "$SONAR_URL" ]; then
    echo "Error: SONAR_URL not set"
    exit 1
fi

PROJECT_KEY=$1
METRICS=${2:-"coverage,bugs,vulnerabilities,code_smells"}

if [ -z "$PROJECT_KEY" ]; then
    echo "Usage: $0 <project-key> [metrics]"
    echo "Example: $0 auth-service coverage,bugs"
    exit 1
fi

echo "Querying SonarQube for project: $PROJECT_KEY"
echo ""

# Quality Gate Status
echo "=== Quality Gate ==="
curl -s -u "${SONAR_TOKEN}:" \
  "${SONAR_URL}/api/qualitygates/project_status?projectKey=${PROJECT_KEY}" | \
  python3 -m json.tool 2>/dev/null || cat

echo ""
echo "=== Metrics ==="
curl -s -u "${SONAR_TOKEN}:" \
  "${SONAR_URL}/api/measures/component?component=${PROJECT_KEY}&metricKeys=${METRICS}" | \
  python3 -m json.tool 2>/dev/null || cat

echo ""
echo "=== Critical Issues ==="
curl -s -u "${SONAR_TOKEN}:" \
  "${SONAR_URL}/api/issues/search?componentKeys=${PROJECT_KEY}&severities=CRITICAL,BLOCKER&resolved=false&ps=10" | \
  python3 -m json.tool 2>/dev/null || cat
