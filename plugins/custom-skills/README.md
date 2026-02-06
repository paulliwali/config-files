# Custom Skills Plugin

Custom slash commands and model-invoked skills for Claude Code.

## Structure

```
commands/     # User-invocable slash commands (e.g., /my-command)
skills/       # Model-invoked skills (Claude decides when to use them)
```

## Adding a Slash Command

Create a markdown file in `commands/` with a frontmatter block:

```markdown
---
name: my-command
description: Short description shown in /help
---

Prompt template that Claude will follow when the user runs /my-command.
```

## Adding a Skill

Create a markdown file in `skills/` with a frontmatter block:

```markdown
---
name: my-skill
description: When Claude should invoke this skill
---

Instructions for Claude when this skill is triggered.
```

## Deployment

After adding or modifying commands/skills, commit and push to `config-files`.
Other instances will pick up changes on next `git pull` (files are symlinked via `setup.sh`).
