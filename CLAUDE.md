# Claude Code AI Development Environment

## Overview
This repository contains configuration files for reproducing the AI development environment on new VM instances. After a VM reboot or fresh setup, you can clone this repository and restore your Claude Code configuration quickly.

## What's Included

### Claude Code Configuration Files
- `settings.local.json` - Claude Code user settings (permissions, output style, hooks)
- `settings.local.template.json` - Template for per-repo Claude settings
- `known_marketplaces.json` - MCP plugin marketplace configuration
- `setup.sh` - Automated setup script to restore the environment

### Multi-Session Management Tools
- `claude-session` - Session manager for multiple Claude Code instances across different repos
- `discord-bridge.py` - Discord bot for remote interaction with Claude sessions
- `get-channel-id.py` - Utility to list Discord channels and their IDs
- `init-all-sessions.sh` - Auto-start script for all enabled sessions

### Notification Scripts
- `discord-notify.sh` - Discord webhook integration for real-time notifications
- `discord-bridge-template.py` - Template for Discord bridge configuration

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

## Multi-Session Management

The `claude-session` tool allows you to manage multiple Claude Code instances across different repositories, each with its own Discord channel for remote interaction.

### Features
- **Multiple Sessions**: Run Claude Code in different repos simultaneously
- **Discord Integration**: Each session gets its own Discord channel for remote control
- **Tmux Sessions**: Each session runs in a dedicated tmux session
- **Auto-start**: Automatically start all enabled sessions on VM boot
- **Process Management**: Start, stop, restart, and monitor sessions

### Quick Setup

1. **Install dependencies** (if not already done):
   ```bash
   # Create Python virtual environment
   python3 -m venv ~/bot-env
   source ~/bot-env/bin/activate
   pip install discord.py pyyaml setproctitle
   ```

2. **Set environment variables**:
   ```bash
   # Add to ~/.bashrc
   export DISCORD_BOT_TOKEN="your-bot-token-here"
   export DISCORD_WEBHOOK_URL="your-webhook-url-here"
   ```

3. **Find your Discord channel IDs**:
   ```bash
   source ~/bot-env/bin/activate
   python3 ~/get-channel-id.py
   ```

4. **Add a new session**:
   ```bash
   ~/claude-session add
   # Follow the interactive prompts
   ```

5. **Initialize the repository**:
   ```bash
   ~/claude-session init-repo <repo-name>
   ```

6. **Start the session**:
   ```bash
   ~/claude-session start <repo-name>
   ```

### Available Commands

```bash
# List all configured sessions with detailed status
claude-session list

# Quick status overview
claude-session status

# Start a session (creates tmux session and starts Discord bot)
claude-session start <repo-name>

# Stop a session (stops Discord bot, keeps tmux session)
claude-session stop <repo-name>

# Restart a session
claude-session restart <repo-name>

# View logs for a session
claude-session logs <repo-name>

# Initialize Claude Code settings in a repository
claude-session init-repo <repo-name>

# Add a new session (interactive wizard)
claude-session add
```

### Session Configuration

Each session is configured via a YAML file in `~/.claude-sessions/<repo-name>.yaml`:

```yaml
# Claude Code Session Configuration
repo_name: my-project
repo_path: /root/my-project
tmux_session: claude-myproject
discord_channel_id: 123456789012345678
discord_bot_token_env: DISCORD_BOT_TOKEN
webhook_url_env: DISCORD_WEBHOOK_URL
enabled: true
```

### Discord Bot Commands

Once a session is running, you can interact with it via Discord:

**Special Commands:**
- `!screen` - Capture and display terminal output
- `!yes` or `!y` - Send "y" + Enter
- `!no` or `!n` - Send "n" + Enter
- `!enter` or `!e` - Press Enter
- `!up`, `!down`, `!left`, `!right` - Navigation keys
- `!esc` - Escape key
- `!tab` - Tab key
- `!bs` - Backspace
- `!c` - Ctrl+C (cancel)

**Text Input:**
- Any other text sent to the channel is typed into the terminal followed by Enter
- Perfect for menu selections, answering prompts, etc.

### Auto-start on Boot

To automatically start all enabled sessions when the VM boots:

1. Make the init script executable:
   ```bash
   chmod +x ~/init-all-sessions.sh
   ```

2. Add to your startup script (e.g., `~/.bashrc` or systemd):
   ```bash
   # Add to ~/.bashrc (runs on login)
   ~/init-all-sessions.sh

   # OR create a systemd service for automatic startup
   ```

### Workflow Example

```bash
# 1. Set up a new project session
claude-session add
# Enter: repo name, path, tmux session, Discord channel ID

# 2. Initialize Claude Code in the repository
claude-session init-repo my-project

# 3. Start the session
claude-session start my-project

# 4. Check status
claude-session status

# 5. From Discord, interact with your session:
#    - Type commands directly in the Discord channel
#    - Use !screen to see the terminal
#    - Use !y or !n to answer prompts

# 6. View logs if needed
claude-session logs my-project
```

### discord-bridge.py

The Discord bridge allows you to control your Claude Code sessions remotely via Discord. Key features:

- **Config File Support**: Use YAML config files for multiple sessions
- **Process Titles**: Easy identification with `ps` (requires setproctitle)
- **Screen Capture**: View terminal output with smart truncation
- **Menu Navigation**: Navigate CLI menus with simple commands
- **Tmux Integration**: Sends commands directly to tmux sessions

### get-channel-id.py

Utility script to help you find Discord channel IDs for your sessions:

```bash
source ~/bot-env/bin/activate
python3 ~/get-channel-id.py
```

This will:
- Connect to Discord with your bot token
- List all servers and channels your bot can access
- Show which channels are already configured for sessions
- Display usage instructions

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
