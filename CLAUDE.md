# Claude Code AI Development Environment

## Overview
This repository contains configuration files for reproducing the AI development environment on new VM instances. After a VM reboot or fresh setup, you can clone this repository and restore your Claude Code configuration quickly.

## What's Included

### Claude Code Configuration Files
- `settings.local.json` - Claude Code user settings (permissions, output style, etc.)
- `known_marketplaces.json` - MCP plugin marketplace configuration
- `setup.sh` - Automated setup script to restore the environment

### Legacy Configuration Files
- Various conda environment YAML files for data science and ML workflows
- `.hyper.js` - Hyper terminal configuration
- `settings.json` - VS Code settings

## Quick Start

### Prerequisites
- Claude Code CLI installed ([Installation guide](https://github.com/anthropics/claude-code))
- Git configured
- API key for Claude (stored separately, not in this repo)

### Setup Instructions

1. Clone this repository:
   ```bash
   git clone https://github.com/paulliwali/config-files
   cd config-files
   ```

2. Run the automated setup script:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

3. Configure your API key (if not already done):
   ```bash
   # This file is NOT tracked in the repo for security
   # You'll need to set this up separately
   claude auth login
   ```

4. **Accept workspace trust** when starting Claude Code:
   - When you first run Claude Code in your project directory, you'll be prompted to trust the workspace
   - **You must accept this** for hooks (like Discord notifications) to work
   - If you miss the prompt, see "Troubleshooting > Hooks Not Firing" section below

5. Verify the setup:
   ```bash
   claude --version
   ```

## Manual Setup (Alternative)

If you prefer to set up manually:

```bash
# Create Claude directory if it doesn't exist
mkdir -p ~/.claude/plugins

# Copy configuration files
cp settings.local.json ~/.claude/settings.local.json
cp known_marketplaces.json ~/.claude/plugins/known_marketplaces.json

# Set proper permissions
chmod 600 ~/.claude/settings.local.json
chmod 600 ~/.claude/plugins/known_marketplaces.json
```

## MCP Server Configuration

### Official Marketplace
The `known_marketplaces.json` file configures the official Claude plugins marketplace. After restoration, Claude Code will automatically download available plugins from:
- https://github.com/anthropics/claude-plugins-official

### Adding Custom MCP Servers
To add custom MCP servers, you can create a configuration file at `~/.claude/mcp-servers.json`:

```json
{
  "myserver": {
    "command": "node",
    "args": ["/path/to/server.js"],
    "env": {
      "API_KEY": "your-api-key"
    }
  }
}
```

Note: Custom MCP server configurations with sensitive data should NOT be committed to this repository.

## Configuration Details

### settings.local.json
Contains user-specific Claude Code settings:
- `outputStyle` - CLI output formatting preference
- `spinnerTipsEnabled` - Whether to show tips in spinner
- `permissions.allow` - Pre-approved tool permissions:
  - `Bash(git clone:*)` - Allow git clone commands
  - `Bash(find:*)` - Allow find commands
  - `Bash(cat:*)` - Allow cat commands
  - `Bash(bash:*)` - Allow bash commands
- `hooks.PreToolUse` - Commands to run before specific tools execute
  - Currently configured: Discord notification when AskUserQuestion is called
  - Requires: `~/discord-notify.sh` script to be present

### discord-notify.sh
Discord webhook integration that sends notifications when Claude asks questions:
- **Location**: `~/discord-notify.sh` (copied by setup.sh)
- **Purpose**: Sends Discord notifications when Claude uses the AskUserQuestion tool
- **Configuration**: Update `WEBHOOK_URL` with your Discord webhook URL
- **How it works**:
  1. Reads hook input from stdin (JSON format)
  2. Extracts the question text from tool_input
  3. Sends formatted notification to Discord
  4. Logs activity to `/tmp/discord-notify.log`
- **Note**: Requires workspace trust to be accepted in Claude Code

### known_marketplaces.json
Configures plugin marketplaces:
- Source repository location
- Installation path
- Last update timestamp

## Security Notes

### Files NOT Tracked (Sensitive)
The following files contain sensitive data and are explicitly excluded via `.gitignore`:
- `.claude.json` - API keys and authentication tokens
- `.credentials.json` - Service credentials
- `*.backup` - Backup files that may contain sensitive data

### Best Practices
1. Never commit API keys or authentication tokens
2. Use environment variables for sensitive configuration
3. Keep `.gitignore` updated to prevent accidental commits
4. Use git-crypt or similar tools if you need to track encrypted secrets

## Troubleshooting

### Claude Code Not Recognized After Setup
```bash
# Check if Claude Code is in PATH
which claude

# Reinstall if necessary
npm install -g @anthropic-ai/claude-code
```

### Settings Not Applied
```bash
# Verify file permissions
ls -la ~/.claude/settings.local.json

# Should be -rw------- (600)
chmod 600 ~/.claude/settings.local.json
```

### Plugin Marketplace Not Loading
```bash
# Check marketplace configuration
cat ~/.claude/plugins/known_marketplaces.json

# Force marketplace refresh
claude plugins refresh
```

### Hooks Not Firing
If hooks (like discord-notify.sh) are not executing:

1. **Check workspace trust** - Hooks require workspace trust to be accepted:
   ```bash
   # Check trust status in ~/.claude.json
   grep hasTrustDialogAccepted ~/.claude.json

   # Should show: "hasTrustDialogAccepted": true
   ```

2. **Enable workspace trust manually** (if needed):
   ```bash
   # Edit ~/.claude.json and set hasTrustDialogAccepted to true
   # in the project section for your working directory
   ```

3. **Verify hook script exists and is executable**:
   ```bash
   ls -la ~/discord-notify.sh
   # Should show: -rwxr-xr-x (executable permissions)

   chmod 755 ~/discord-notify.sh  # Fix if needed
   ```

4. **Check debug logs**:
   ```bash
   # View Claude Code debug logs
   tail -f ~/.claude/debug/latest

   # View hook-specific logs
   tail -f /tmp/discord-notify.log
   ```

## Updating Configuration

After making changes to your Claude Code setup:

```bash
# Copy updated files back to the repository
cp ~/.claude/settings.local.json ~/config-files/
cp ~/.claude/plugins/known_marketplaces.json ~/config-files/
cp ~/discord-notify.sh ~/config-files/

# IMPORTANT: If discord-notify.sh contains a webhook URL,
# make sure to remove or anonymize it before committing!

# Commit changes
cd ~/config-files
git add settings.local.json known_marketplaces.json discord-notify.sh CLAUDE.md setup.sh
git commit -m "Update Claude Code configuration"
git push
```

## Additional Resources

- [Claude Code Documentation](https://github.com/anthropics/claude-code)
- [MCP Server Guide](https://modelcontextprotocol.io)
- [Anthropic API Documentation](https://docs.anthropic.com)

## Support

For issues with this configuration setup, check:
1. File permissions are correctly set (600 for config files)
2. Claude Code is properly installed and in PATH
3. API credentials are configured separately
4. Repository is cloned to expected location

For Claude Code issues, see: https://github.com/anthropics/claude-code/issues
