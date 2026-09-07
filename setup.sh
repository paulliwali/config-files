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

# --- Install / update Hermes Agent ---
echo "Checking for Hermes Agent installation..."
if command -v hermes &> /dev/null; then
    echo -e "${GREEN}✓ Hermes Agent found${NC}"
else
    echo "Hermes Agent not found. Installing..."
    curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
    echo -e "${GREEN}✓ Hermes Agent installed${NC}"
fi

# --- Symlink Hermes config ---
echo "Linking Hermes configuration..."
mkdir -p "$HOME/.hermes"
create_symlink "$SCRIPT_DIR/hermes/config.yaml" "$HOME/.hermes/config.yaml"
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
echo -e "${GREEN}✓ Directories ready${NC}"
echo ""

# --- Symlink .claude/ files ---
echo "Linking .claude/ configuration..."

# settings.json
create_symlink "$SCRIPT_DIR/.claude/settings.json" "$HOME/.claude/settings.json"

# Global CLAUDE.md only — project-specific rules live in each project's own CLAUDE.md
create_symlink "$SCRIPT_DIR/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# agents directory (custom agent definitions)
if [ -d "$SCRIPT_DIR/.claude/agents" ]; then
    if [ -L "$HOME/.claude/agents" ] && [ "$(readlink "$HOME/.claude/agents")" = "$SCRIPT_DIR/.claude/agents" ]; then
        echo -e "${GREEN}✓ agents (already linked)${NC}"
    else
        [ -e "$HOME/.claude/agents" ] && mv "$HOME/.claude/agents" "$HOME/.claude/agents.backup.$(date +%Y%m%d%H%M%S)"
        ln -s "$SCRIPT_DIR/.claude/agents" "$HOME/.claude/agents"
        echo -e "${GREEN}✓ agents → $SCRIPT_DIR/.claude/agents${NC}"
    fi
fi

# memory — project memory symlinked back into repo so it's tracked in git
ENCODED_PATH=$(echo "$SCRIPT_DIR" | tr '/' '-')
MEMORY_PROJECT="$HOME/.claude/projects/$ENCODED_PATH"
mkdir -p "$MEMORY_PROJECT"
create_symlink "$SCRIPT_DIR/memory" "$MEMORY_PROJECT/memory"
echo ""

# --- Symlink scripts to ~/ ---
echo "Linking scripts to ~/..."

for script in discord-notify.sh; do
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

# --- Brew tools (modern CLI) ---
echo "Checking for modern CLI tools..."
if command -v brew &> /dev/null; then
    for tool in zoxide eza bat fd; do
        if ! command -v "$tool" &> /dev/null; then
            echo "Installing $tool..."
            brew install "$tool"
        else
            echo -e "${GREEN}✓ $tool (already installed)${NC}"
        fi
    done
    if ! fc-list | grep -qi "JetBrainsMono"; then
        echo "Installing JetBrainsMono Nerd Font..."
        brew install --cask font-jetbrains-mono-nerd-font
    else
        echo -e "${GREEN}✓ JetBrainsMono Nerd Font (already installed)${NC}"
    fi
else
    echo -e "${YELLOW}⚠ brew not found — skipping tool installs${NC}"
fi
echo ""

# --- Dotfiles ---
echo "Linking dotfiles..."
mkdir -p ~/.config
create_symlink "$SCRIPT_DIR/dotfiles/zshrc"         "$HOME/.zshrc"
create_symlink "$SCRIPT_DIR/dotfiles/zprofile"      "$HOME/.zprofile"
create_symlink "$SCRIPT_DIR/dotfiles/starship.toml" "$HOME/.config/starship.toml"
mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
create_symlink "$SCRIPT_DIR/dotfiles/iterm2/Default.json" \
    "$HOME/Library/Application Support/iTerm2/DynamicProfiles/Default.json"
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
echo "3. Create your secrets file from the example template:"
echo -e "   ${YELLOW}cp $SCRIPT_DIR/dotfiles/secrets.example ~/.secrets${NC}"
echo "   Then edit ~/.secrets with your actual credentials."
echo ""
echo "4. Set iTerm2 font (one-time):"
echo "   - Open iTerm2 → Preferences → Profiles → select 'Catppuccin Mocha'"
echo "   - The profile is auto-loaded from DynamicProfiles"
echo ""
echo "5. (Optional) Set up Discord notifications:"
echo -e "   ${YELLOW}~/discord-notify.sh${NC} uses a hardcoded webhook URL —"
echo "   edit the script directly if you need to change it"
echo ""
echo "6. Authenticate Hermes with your provider:"
echo -e "   ${YELLOW}hermes auth add nous${NC}"
echo "   Then verify with: hermes doctor"
echo ""
echo "7. Import a previous Claude Code setup (if any):"
echo -e "   ${YELLOW}hermes import-agent claude-code${NC}  # memory, allowlist, MCP, skills"
echo ""
echo "All files are symlinked — edits flow back to the repo."
echo "Commit and push to propagate changes to other instances."
echo ""
