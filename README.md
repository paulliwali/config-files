# AI Development Environment Configuration

Configuration files for reproducing the AI development environment on VM instances.

## Quick Start

```bash
git clone https://github.com/paulliwali/config-files
cd config-files
chmod +x setup.sh
./setup.sh
```

See [CLAUDE.md](CLAUDE.md) for detailed setup instructions and troubleshooting.

## What's Included

### `.claude/` Directory
Templates and configuration to copy to new dev environments:
- **CLAUDE.md** - Coding style guidelines template (copy to project roots for consistent Claude Code behavior)
- **settings.local.json** - Claude Code user settings (permissions, output style, hooks)
- **settings.local.template.json** - Template for per-repo Claude settings
- **(future) agents/** - Custom agent configurations
- **(future) commands/** - Custom slash commands

### Scripts
- **setup.sh** - Automated setup script for quick environment restoration

### Legacy Tools
- **Conda Environments** - Data science and ML environment YAML files
- **Terminal Config** - Hyper terminal configuration (.hyper.js)
- **Editor Settings** - VS Code settings (settings.json)

## Security Note

This repository does NOT contain:
- API keys or authentication tokens
- Credentials or secrets
- Session-specific data

These must be configured separately after cloning.
