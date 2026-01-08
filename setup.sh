#!/bin/bash

# AI Development Environment Setup Script
# This script restores Claude Code configuration from the config-files repository

set -e  # Exit on error

echo "=========================================="
echo "  AI Development Environment Setup"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Claude Code is installed
echo "Checking for Claude Code installation..."
if ! command -v claude-code &> /dev/null; then
    echo -e "${RED}ERROR: Claude Code is not installed or not in PATH${NC}"
    echo ""
    echo "Please install Claude Code first:"
    echo "  npm install -g @anthropic/claude-code"
    echo ""
    echo "Or visit: https://github.com/anthropics/claude-code"
    exit 1
fi
echo -e "${GREEN}✓ Claude Code found${NC}"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Repository location: $SCRIPT_DIR"
echo ""

# Create Claude directory structure if it doesn't exist
echo "Setting up Claude directory structure..."
mkdir -p ~/.claude/plugins
echo -e "${GREEN}✓ Directory structure created${NC}"
echo ""

# Copy configuration files
echo "Copying configuration files..."

# Copy settings.local.json
if [ -f "$SCRIPT_DIR/settings.local.json" ]; then
    cp "$SCRIPT_DIR/settings.local.json" ~/.claude/settings.local.json
    chmod 600 ~/.claude/settings.local.json
    echo -e "${GREEN}✓ Copied settings.local.json${NC}"
else
    echo -e "${YELLOW}⚠ Warning: settings.local.json not found in repository${NC}"
fi

# Copy known_marketplaces.json
if [ -f "$SCRIPT_DIR/known_marketplaces.json" ]; then
    cp "$SCRIPT_DIR/known_marketplaces.json" ~/.claude/plugins/known_marketplaces.json
    chmod 600 ~/.claude/plugins/known_marketplaces.json
    echo -e "${GREEN}✓ Copied known_marketplaces.json${NC}"
else
    echo -e "${YELLOW}⚠ Warning: known_marketplaces.json not found in repository${NC}"
fi

# Copy discord-notify.sh hook script
if [ -f "$SCRIPT_DIR/discord-notify.sh" ]; then
    cp "$SCRIPT_DIR/discord-notify.sh" ~/discord-notify.sh
    chmod 755 ~/discord-notify.sh
    echo -e "${GREEN}✓ Copied discord-notify.sh (hook script)${NC}"
else
    echo -e "${YELLOW}⚠ Warning: discord-notify.sh not found in repository${NC}"
fi

# Copy discord-bridge.py script
if [ -f "$SCRIPT_DIR/discord-bridge.py" ]; then
    cp "$SCRIPT_DIR/discord-bridge.py" ~/discord-bridge.py
    chmod 755 ~/discord-bridge.py
    echo -e "${GREEN}✓ Copied discord-bridge.py${NC}"
else
    echo -e "${YELLOW}⚠ Warning: discord-bridge.py not found in repository${NC}"
fi

echo ""
echo -e "${GREEN}=========================================="
echo "  Setup Complete!"
echo "==========================================${NC}"
echo ""
echo "Next steps:"
echo ""
echo "1. Configure your Claude API key (if not already done):"
echo "   ${YELLOW}claude-code auth login${NC}"
echo ""
echo "2. ${YELLOW}IMPORTANT:${NC} Accept workspace trust when you start Claude Code"
echo "   - This is required for hooks (Discord notifications) to work"
echo "   - You'll be prompted on first run in your project directory"
echo ""
echo "3. Verify your setup:"
echo "   ${YELLOW}claude-code --version${NC}"
echo ""
echo "4. (Optional) Refresh plugin marketplace:"
echo "   ${YELLOW}claude-code plugins refresh${NC}"
echo ""
echo "For more information, see CLAUDE.md in this repository."
echo ""
