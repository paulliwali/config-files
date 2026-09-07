# Hermes Agent Configuration

Portable config for [Hermes Agent](https://hermes-agent.nousresearch.com/docs/).
`~/.hermes/config.yaml` is **symlinked** to this file — edits in either place
flow to the other, and the repo captures them for new installs.

## What's here

| Source | Target | Purpose |
|--------|--------|---------|
| `hermes/config.yaml` | `~/.hermes/config.yaml` | Main Hermes config (model, display, toolsets) |

## Current choices

- **Model**: `deepseek/deepseek-v4-flash` via Nous Portal
- **Skin**: `mono` — clean grayscale, minimal aesthetic
  (built-in; no custom skin file needed)
- **Interface**: `cli` (default terminal UI)
- **Import from Claude Code**: `hermes import-agent claude-code` brought over
  the global CLAUDE.md prefs (→ MEMORY.md) and the Bash allowlist
  (→ `command_allowlist` in config.yaml)
- **MCP**: `context7` (npx @upstash/context7-mcp) — declared in config.yaml
- **Shell hooks**: `pre_tool_call` + `post_tool_call` fire
  `~/discord-notify.sh` (Discord notifications on terminal/file/clarify/todo
  activity; `hooks_auto_accept: true`)

## Machine-local setup (not in this repo)

- LSP servers: `hermes lsp install typescript bash-language-server yaml-language-server`
  (pyright ships installed; elixir-ls is manual — `brew install elixir-ls`)
- `context7` MCP pulls its npm package on first use; no env needed

## Setting up on a new machine

The repo's `setup.sh` symlinks dotfiles into place. For Hermes specifically:

```bash
# 1. Install Hermes
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

# 2. Clone config-files (if not already)
git clone https://github.com/paulliwali/config-files
cd config-files

# 3. Symlink the Hermes config into place
mkdir -p ~/.hermes
ln -s "$PWD/hermes/config.yaml" ~/.hermes/config.yaml

# 4. Authenticate with your provider
hermes auth add nous
```

## Notes

- No secrets live in this file — API keys go in `~/.hermes/.env` (gitignored),
  matching the repo's `~/.secrets` pattern.
- The `display.skin: mono` line is what makes the terminal look minimal.
  Switch back with `hermes config set display.skin default`.
- Font for the terminal itself (iTerm2) is FiraCode Nerd Font 13pt, set in
  iTerm2 Preferences — see `dotfiles/iterm2/` and the README.
