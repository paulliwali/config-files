# Claude Code Guidelines

Core preferences for all sessions. Load topic files as needed.

## Communication
- Ask clarifying questions when requirements are ambiguous
- Be direct and concise
- Explain trade-offs for architectural decisions

## Quick Reference
- **Indentation**: 4 spaces
- **Python deps**: Use `uv`
- **Git**: Conventional commits (feat:, fix:, refactor:, docs:, test:, chore:)
- **Comments**: Minimal - only when "why" isn't obvious

## Workflow

### Plan-First Approach
1. **Plan before coding** - Always create a plan before implementing
2. **Iterate with Q&A** - Clarify and refine the plan through questions
3. **Document in PLAN.md** - Write and update plans in the project's `PLAN.md` file
4. **Then implement** - Only write code after the plan is clear and agreed upon

### Session Continuity
- Keep project `CLAUDE.md` and `PLAN.md` up to date so parallel sessions or new sessions can pick up work
- When creating a new project or initializing a project's `CLAUDE.md`, also create a `PLAN.md` file
- Update these files as work progresses to maintain context across sessions

### Config Evolution
This repo is symlinked into `~/.claude/` — edits propagate automatically.
When you notice opportunities to improve the dev environment, proactively suggest:
- **CLAUDE.md / topic files**: Update when users express coding preferences or conventions
- **settings.json**: Update for permission or hook changes
- **custom-skills plugin**: Add commands to `plugins/custom-skills/commands/` or skills to `plugins/custom-skills/skills/` when a reusable workflow emerges
- Always confirm with user before editing config-files
- Remind user to commit + push so other instances receive the updates

## Topic Files
Load these into context when relevant:
- `CLAUDE.python.md` - Python-specific guidelines
- `CLAUDE.typescript.md` - TypeScript/JavaScript guidelines
- `CLAUDE.frontend.md` - Frontend project guidelines
- `CLAUDE.git.md` - Git workflow details
- `CLAUDE.testing.md` - Testing approach
