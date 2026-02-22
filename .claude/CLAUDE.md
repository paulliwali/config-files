# Global Preferences

- Be direct and concise; ask when requirements are ambiguous
- Indentation: 4 spaces
- Git: conventional commits (feat:, fix:, refactor:, docs:, test:, chore:)
- Comments: only when "why" isn't obvious
- Python deps: use `uv`

Project-specific rules live in each project's own `CLAUDE.md`.
Accumulated preferences and learnings are in `memory/`.

## Config Evolution
This repo symlinks into `~/.claude/` — edits propagate automatically.
Confirm with user before editing; remind to commit + push so other instances stay in sync.
