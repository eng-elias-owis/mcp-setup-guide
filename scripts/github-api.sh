#!/bin/bash
# github-api.sh - GitHub Enterprise API wrapper
# Usage: ./github-api.sh <endpoint>
# Example: ./github-api.sh repos/org/backend/pulls

set -e

# Check env vars
if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_TOKEN not set"
    echo "Load secrets first: source scripts/load-mcp-secrets.sh"
    exit 1
fi

if [ -z "$GITHUB_URL" ]; then
    echo "Error: GITHUB_URL not set"
    exit 1
fi

ENDPOINT=${1:-"user"}
API_VERSION="${2:-v3}"

# Build full URL
BASE_URL="${GITHUB_URL}/api/${API_VERSION}"
FULL_URL="${BASE_URL}/${ENDPOINT}"

# Make request
curl -s \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "${FULL_URL}"
