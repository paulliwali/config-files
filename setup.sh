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
if ! command -v claude &> /dev/null; then
    echo -e "${RED}ERROR: Claude Code is not installed or not in PATH${NC}"
    echo ""
    echo "Please install Claude Code first:"
    echo "  npm install -g @anthropic-ai/claude-code"
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

# Copy CLAUDE.md guideline files from .claude directory
if [ -d "$SCRIPT_DIR/.claude" ]; then
    # Copy all CLAUDE*.md files
    for file in "$SCRIPT_DIR/.claude"/CLAUDE*.md; do
        if [ -f "$file" ]; then
            cp "$file" ~/.claude/
            echo -e "${GREEN}✓ Copied $(basename "$file")${NC}"
        fi
    done
else
    echo -e "${YELLOW}⚠ Warning: .claude directory not found in repository${NC}"
fi

# Copy settings.local.json
if [ -f "$SCRIPT_DIR/.claude/settings.local.json" ]; then
    cp "$SCRIPT_DIR/.claude/settings.local.json" ~/.claude/settings.local.json
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

# Copy claude-session management script
if [ -f "$SCRIPT_DIR/claude-session" ]; then
    cp "$SCRIPT_DIR/claude-session" ~/claude-session
    chmod 755 ~/claude-session
    echo -e "${GREEN}✓ Copied claude-session (session manager)${NC}"
else
    echo -e "${YELLOW}⚠ Warning: claude-session not found in repository${NC}"
fi

# Copy get-channel-id.py utility
if [ -f "$SCRIPT_DIR/get-channel-id.py" ]; then
    cp "$SCRIPT_DIR/get-channel-id.py" ~/get-channel-id.py
    chmod 755 ~/get-channel-id.py
    echo -e "${GREEN}✓ Copied get-channel-id.py${NC}"
else
    echo -e "${YELLOW}⚠ Warning: get-channel-id.py not found in repository${NC}"
fi

# Copy init-all-sessions.sh auto-start script
if [ -f "$SCRIPT_DIR/init-all-sessions.sh" ]; then
    cp "$SCRIPT_DIR/init-all-sessions.sh" ~/init-all-sessions.sh
    chmod 755 ~/init-all-sessions.sh
    echo -e "${GREEN}✓ Copied init-all-sessions.sh${NC}"
else
    echo -e "${YELLOW}⚠ Warning: init-all-sessions.sh not found in repository${NC}"
fi

# Create .claude-sessions directory for session configs
mkdir -p ~/.claude-sessions
echo -e "${GREEN}✓ Created .claude-sessions directory${NC}"

echo ""
echo -e "${GREEN}=========================================="
echo "  Setup Complete!"
echo "==========================================${NC}"
echo ""
echo "Next steps:"
echo ""
echo "1. Configure your Claude API key (if not already done):"
echo -e "   ${YELLOW}claude auth login${NC}"
echo ""
echo -e "2. ${YELLOW}IMPORTANT:${NC} Accept workspace trust when you start Claude Code"
echo "   - This is required for hooks (Discord notifications) to work"
echo "   - You'll be prompted on first run in your project directory"
echo ""
echo "3. Set up environment variables for Discord integration:"
echo -e "   ${YELLOW}export DISCORD_BOT_TOKEN=\"your-bot-token\"${NC}"
echo -e "   ${YELLOW}export DISCORD_WEBHOOK_URL=\"your-webhook-url\"${NC}"
echo "   (Add these to ~/.bashrc for persistence)"
echo ""
echo "4. (Optional) Set up multi-session management:"
echo -e "   ${YELLOW}~/claude-session add${NC}  # Add a new repository session"
echo -e "   ${YELLOW}~/claude-session list${NC}  # List all configured sessions"
echo ""
echo "5. Verify your setup:"
echo -e "   ${YELLOW}claude --version${NC}"
echo ""
echo "Installed CLAUDE.md guideline files to ~/.claude/"
echo "These will be loaded by Claude Code for consistent coding style."
echo ""
echo "For complete documentation, see CLAUDE.md in this repository."
echo ""
