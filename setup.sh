#!/bin/bash

# AI Development Environment Setup Script
# Symlinks config-files repo into ~/.claude/ and ~/
# Re-run safely at any time — existing files are backed up.

set -e

echo "=========================================="
echo "  AI Development Environment Setup"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Repository location: $SCRIPT_DIR"
echo ""

# --- Install / update Claude Code ---
echo "Checking for Claude Code installation..."
if command -v claude &> /dev/null; then
    echo -e "${GREEN}✓ Claude Code found (auto-updates in background)${NC}"
else
    echo "Claude Code not found. Installing via native installer..."
    curl -fsSL https://install.anthropic.com | sh
    echo -e "${GREEN}✓ Claude Code installed${NC}"
fi
echo ""

# --- Symlink helper ---
# Usage: create_symlink <source> <target>
# Handles:
#   - Already correct symlink → skip
#   - Existing file/dir → backup with timestamp, then link
#   - Wrong symlink → replace
#   - Nothing there → link
create_symlink() {
    local src="$1"
    local target="$2"

    # Already correct
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then
        echo -e "${GREEN}✓ $(basename "$target") (already linked)${NC}"
        return
    fi

    # Existing file or wrong symlink — back up
    if [ -e "$target" ] || [ -L "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
        mv "$target" "$backup"
        echo -e "${YELLOW}  Backed up existing $(basename "$target") → $(basename "$backup")${NC}"
    fi

    ln -s "$src" "$target"
    echo -e "${GREEN}✓ $(basename "$target") → $src${NC}"
}

# --- Create directory structure ---
echo "Creating directory structure..."
mkdir -p ~/.claude/plugins
mkdir -p ~/.claude-sessions
echo -e "${GREEN}✓ Directories ready${NC}"
echo ""

# --- Symlink .claude/ files ---
echo "Linking .claude/ configuration..."

# settings.json
create_symlink "$SCRIPT_DIR/.claude/settings.json" "$HOME/.claude/settings.json"

# All CLAUDE*.md files
for file in "$SCRIPT_DIR/.claude"/CLAUDE*.md; do
    if [ -f "$file" ]; then
        create_symlink "$file" "$HOME/.claude/$(basename "$file")"
    fi
done
echo ""

# --- Symlink scripts to ~/ ---
echo "Linking scripts to ~/..."

for script in discord-notify.sh discord-bridge.py claude-session get-channel-id.py init-all-sessions.sh; do
    if [ -f "$SCRIPT_DIR/$script" ]; then
        create_symlink "$SCRIPT_DIR/$script" "$HOME/$script"
    else
        echo -e "${YELLOW}⚠ $script not found in repo${NC}"
    fi
done
echo ""

# --- Symlink plugin config ---
echo "Linking plugin configuration..."

if [ -f "$SCRIPT_DIR/known_marketplaces.json" ]; then
    create_symlink "$SCRIPT_DIR/known_marketplaces.json" "$HOME/.claude/plugins/known_marketplaces.json"
fi

# Symlink custom-skills plugin directory
if [ -d "$SCRIPT_DIR/plugins/custom-skills" ]; then
    create_symlink "$SCRIPT_DIR/plugins/custom-skills" "$HOME/.claude/plugins/custom-skills"
fi
echo ""

# --- Done ---
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
echo "   - Required for hooks (Discord notifications) to work"
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
echo "All files are symlinked — edits in ~/.claude/ flow back to the repo."
echo "Commit and push to propagate changes to other instances."
echo ""
