#!/bin/bash
# curl-wrapper-mcp.sh
# Simple HTTP wrapper using curl - works with npx via npx-shell-cli or directly
# Usage: Add to claude config as a command

METHOD=${1:-GET}
URL=$2
HEADERS=${3:-}
BODY=${4:-}

if [ -z "$URL" ]; then
    echo "Usage: curl-wrapper-mcp.sh <METHOD> <URL> [HEADERS] [BODY]"
    echo "Example: curl-wrapper-mcp.sh GET https://api.github.com/user"
    exit 1
fi

# Build curl command
CURL_CMD="curl -s -w '\nHTTP_CODE:%{http_code}'"

# Add method
if [ "$METHOD" != "GET" ]; then
    CURL_CMD="$CURL_CMD -X $METHOD"
fi

# Add headers if provided
if [ -n "$HEADERS" ]; then
    # Parse JSON headers
    CURL_CMD="$CURL_CMD -H '$HEADERS'"
fi

# Add body if provided
if [ -n "$BODY" ]; then
    CURL_CMD="$CURL_CMD -d '$BODY'"
fi

# Add URL
CURL_CMD="$CURL_CMD '$URL'"

# Execute
eval $CURL_CMD
