#!/bin/bash

# MCP Setup Script
# Run this to quickly set up MCP servers for on-prem development

set -e

echo "🚀 MCP Setup Guide - Installation Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check prerequisites
echo "📋 Checking prerequisites..."

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js not found. Please install Node.js 18+${NC}"
    exit 1
fi

NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo -e "${RED}❌ Node.js version $NODE_VERSION found. Need 18+${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Node.js $(node --version) found${NC}"

# Check npx
if ! command -v npx &> /dev/null; then
    echo -e "${RED}❌ npx not found. Please install npm${NC}"
    exit 1
fi

echo -e "${GREEN}✅ npx found${NC}"

# Check Claude
if ! command -v claude &> /dev/null; then
    echo -e "${YELLOW}⚠️  Claude Code not found in PATH${NC}"
    echo "   Make sure Claude Code is installed: npm install -g @anthropic-ai/claude-code"
fi

echo ""
echo "📦 Installing MCP servers..."
echo ""

# Test installing each MCP server
echo "Testing filesystem MCP..."
npx -y @modelcontextprotocol/server-filesystem --help > /dev/null 2>&1 && echo -e "${GREEN}✅ filesystem MCP ready${NC}" || echo -e "${YELLOW}⚠️  filesystem MCP test failed${NC}"

echo "Testing fetch MCP..."
npx -y @modelcontextprotocol/server-fetch --help > /dev/null 2>&1 && echo -e "${GREEN}✅ fetch MCP ready${NC}" || echo -e "${YELLOW}⚠️  fetch MCP test failed${NC}"

echo "Testing memory MCP..."
npx -y @modelcontextprotocol/server-memory --help > /dev/null 2>&1 && echo -e "${GREEN}✅ memory MCP ready${NC}" || echo -e "${YELLOW}⚠️  memory MCP test failed${NC}"

echo "Testing git MCP..."
npx -y @modelcontextprotocol/server-git --help > /dev/null 2>&1 && echo -e "${GREEN}✅ git MCP ready${NC}" || echo -e "${YELLOW}⚠️  git MCP test failed${NC}"

echo ""
echo "⚙️  Setting up configuration..."

# Create configs directory if it doesn't exist
mkdir -p configs

# Copy secrets template if secrets.env doesn't exist
if [ ! -f configs/secrets.env ]; then
    cp configs/secrets.env.template configs/secrets.env
    echo -e "${YELLOW}📝 Created configs/secrets.env from template${NC}"
    echo -e "${YELLOW}   Please edit this file with your actual tokens${NC}"
else
    echo -e "${GREEN}✅ configs/secrets.env already exists${NC}"
fi

# Set permissions
chmod 600 configs/secrets.env 2>/dev/null || true
chmod 600 configs/secrets.env.template 2>/dev/null || true

echo ""
echo "🎯 Next Steps:"
echo "============="
echo ""
echo "1. Edit configs/secrets.env with your tokens:"
echo "   nano configs/secrets.env"
echo ""
echo "2. Update the filesystem path in configs/claude-config.json:"
echo "   Change '/path/to/your/repos' to your actual projects directory"
echo ""
echo "3. Copy the MCP config to Claude:"
echo "   mkdir -p ~/.config/claude"
echo "   cp configs/claude-config.json ~/.config/claude/mcp-config.json"
echo ""
echo "4. Start using:"
echo "   source configs/secrets.env"
echo "   claude"
echo ""
echo "📚 See docs/ directory for detailed guides"
echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
