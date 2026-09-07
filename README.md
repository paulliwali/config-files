# AI Development Environment Configuration

Portable dotfiles for Claude Code environments. Files are **symlinked** (not copied) so edits in `~/.claude/` flow back to the repo automatically.

## Quick Start

```bash
git clone https://github.com/paulliwali/config-files
cd config-files
chmod +x setup.sh
./setup.sh
```

`setup.sh` is idempotent — re-run at any time to pick up new files. Existing files are backed up with a timestamp before being replaced.

## What Gets Symlinked

### `~/.claude/` (Claude Code config)

| Source | Target | Purpose |
|--------|--------|---------|
| `.claude/settings.json` | `~/.claude/settings.json` | Permissions, hooks, plugins, status line |
| `.claude/CLAUDE*.md` | `~/.claude/CLAUDE*.md` | Coding guidelines & topic files |
| `.claude/agents/` | `~/.claude/agents/` | Custom agent definitions |
| `known_marketplaces.json` | `~/.claude/plugins/known_marketplaces.json` | Plugin marketplace config |
| `plugins/custom-skills/` | `~/.claude/plugins/custom-skills/` | Custom slash commands & skills |
| `memory/` | `~/.claude/projects/<encoded-path>/memory/` | Persistent Claude memories (tracked in git) |

## Settings Architecture

- **`settings.json`** (global, symlinked) — permissions, plugins, status line.

## Custom Skills Plugin

```
plugins/custom-skills/
  .claude-plugin/plugin.json    # Plugin metadata
  commands/                     # User-invocable slash commands
  skills/                       # Model-invoked skills
```

Add markdown files to `commands/` or `skills/` — see `plugins/custom-skills/README.md` for format details.

## Updating

Since everything is symlinked, just edit files in place and commit:

```bash
cd ~/config-files   # or wherever you cloned it
git add -A && git commit -m "feat: update settings"
git push
```

Other instances pick up changes with `git pull`.

## Terminal Setup (Catppuccin Mocha)

A minimal hacker aesthetic: dark background, Catppuccin Mocha colors, clean single-line prompt.

### Aesthetic choices
- **Color scheme**: [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) — `#1e1e2e` background, `#cdd6f4` text
- **Font**: JetBrainsMono Nerd Font 13pt (installed via `brew --cask`)
- **Prompt**: starship — `~/code/project main* ❯` — single line, no language versions, no powerline chrome
- **Shell**: zsh + oh-my-zsh (git, zsh-completions, zsh-autosuggestions, zsh-syntax-highlighting)

### Modern CLI tools (installed by `setup.sh`)
| Command | Replaces | Notes |
|---------|----------|-------|
| `eza` | `ls` | Icons, git status column |
| `bat` | `cat` | Syntax highlighting |
| `fd` | `find` | Faster, friendlier syntax |
| `zoxide` | `cd` | Smart directory jumping |

### What gets symlinked

| Source | Target |
|--------|--------|
| `dotfiles/zshrc` | `~/.zshrc` |
| `dotfiles/zprofile` | `~/.zprofile` |
| `dotfiles/starship.toml` | `~/.config/starship.toml` |
| `dotfiles/iterm2/Default.json` | `~/Library/Application Support/iTerm2/DynamicProfiles/Default.json` |

### One-time manual steps (new machine)
1. `./setup.sh` — symlinks files, installs tools and font
2. Copy secrets: `cp dotfiles/secrets.example ~/.secrets` and fill in real values
3. Open iTerm2 → Preferences → Profiles → select **Catppuccin Mocha** (auto-loaded)
4. Set font in iTerm2 if not already applied: JetBrainsMono Nerd Font, 13pt

### Secrets management
All credentials stay in `~/.secrets` (gitignored). See `dotfiles/secrets.example` for the template.

---

## Security Note

This repository does **not** contain API keys, tokens, or credentials. Configure those separately after cloning.
