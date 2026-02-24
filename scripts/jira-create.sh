#!/bin/bash
# jira-create.sh - Create JIRA ticket
# Usage: ./jira-create.sh <project> <summary> [type] [priority]
# Example: ./jira-create.sh AUTH "Fix login timeout" Bug High

set -e

# Check env vars
if [ -z "$JIRA_TOKEN" ]; then
    echo "Error: JIRA_TOKEN not set"
    echo "Load secrets first: source scripts/load-mcp-secrets.sh"
    exit 1
fi

if [ -z "$JIRA_URL" ]; then
    echo "Error: JIRA_URL not set"
    exit 1
fi

PROJECT=$1
SUMMARY=$2
TYPE=${3:-Bug}
PRIORITY=${4:-Medium}

if [ -z "$PROJECT" ] || [ -z "$SUMMARY" ]; then
    echo "Usage: $0 <project> <summary> [type] [priority]"
    echo "Example: $0 AUTH 'Fix login bug' Bug High"
    exit 1
fi

echo "Creating $TYPE ticket in $PROJECT..."

# Create issue
RESPONSE=$(curl -s -X POST \
  -H "Authorization: Bearer ${JIRA_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{
    \"fields\": {
      \"project\": {\"key\": \"${PROJECT}\"},
      \"summary\": \"${SUMMARY}\",
      \"issuetype\": {\"name\": \"${TYPE}\"},
      \"priority\": {\"name\": \"${PRIORITY}\"}
    }
  }" \
  "${JIRA_URL}/rest/api/2/issue")

# Parse response
if command -v python3 &> /dev/null; then
    echo "$RESPONSE" | python3 -c "
import sys, json
data = json.load(sys.stdin)
if 'key' in data:
    print(f\"✅ Created: {data['key']}\")
    print(f\"🔗 URL: {data['self'].replace('/rest/api/2/issue/', '/browse/')}\")
else:
    print(f\"❌ Error: {data.get('errorMessages', data)}\")
"
else
    echo "$RESPONSE"
fi
