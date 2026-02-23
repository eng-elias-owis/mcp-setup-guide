#!/bin/bash
# Load MCP secrets into environment variables for Git Bash
# Usage: source scripts/load-mcp-secrets.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SECRET_FILE="$SCRIPT_DIR/../configs/secrets.env"

if [ ! -f "$SECRET_FILE" ]; then
    echo "[X] secrets.env not found at: $SECRET_FILE"
    return 1
fi

echo "Loading secrets from configs/secrets.env..."
echo ""

# Read and export each variable
while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    
    # Extract variable name and value
    if [[ "$line" =~ ^([A-Z_]+)=(.+)$ ]]; then
        var_name="${BASH_REMATCH[1]}"
        var_value="${BASH_REMATCH[2]}"
        
        # Remove quotes if present
        var_value="${var_value%\"}"
        var_value="${var_value#\"}"
        
        export "$var_name=$var_value"
        echo "Set $var_name"
    fi
done < "$SECRET_FILE"

echo ""
echo "[OK] All secrets loaded!"
echo "Start Claude with: claude"
echo ""
