#!/bin/bash
# confluence-create.sh - Create Confluence page
# Usage: ./confluence-create.sh <space> <title> [parent-id]
# Example: ./confluence-create.sh TEAM "API Documentation" 123456

set -e

# Check env vars
if [ -z "$CONFLUENCE_TOKEN" ]; then
    echo "Error: CONFLUENCE_TOKEN not set"
    echo "Load secrets first: source scripts/load-mcp-secrets.sh"
    exit 1
fi

if [ -z "$CONFLUENCE_URL" ]; then
    echo "Error: CONFLUENCE_URL not set"
    exit 1
fi

SPACE=$1
TITLE=$2
PARENT_ID=$3

if [ -z "$SPACE" ] || [ -z "$TITLE" ]; then
    echo "Usage: $0 <space-key> <title> [parent-page-id]"
    echo "Example: $0 ENG 'API Guide' 123456"
    exit 1
fi

echo "Creating page in space $SPACE..."

# Build JSON
if [ -n "$PARENT_ID" ]; then
    ANCESTORS=", \"ancestors\": [{\"id\": ${PARENT_ID}}]"
else
    ANCESTORS=""
fi

# Create simple content
CONTENT="<h1>${TITLE}</h1><p>Created via MCP automation.</p>"

# Create page
RESPONSE=$(curl -s -X POST \
  -H "Authorization: Bearer ${CONFLUENCE_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{
    \"type\": \"page\",
    \"title\": \"${TITLE}\",
    \"space\": {\"key\": \"${SPACE}\"},
    \"body\": {
      \"storage\": {
        \"value\": \"${CONTENT}\",
        \"representation\": \"storage\"
      }
    }${ANCESTORS}
  }" \
  "${CONFLUENCE_URL}/rest/api/content")

# Parse response
if command -v python3 &> /dev/null; then
    echo "$RESPONSE" | python3 -c "
import sys, json
data = json.load(sys.stdin)
if 'id' in data:
    print(f\"✅ Created: {data['title']}\")
    print(f\"🔗 URL: {data['_links']['webui']}\")
    print(f\"📄 ID: {data['id']}\")
else:
    print(f\"❌ Error: {data.get('message', data)}\")
"
else
    echo "$RESPONSE"
fi
