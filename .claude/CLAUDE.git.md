# Git Workflow

## Commit Style
- Small, atomic commits - one logical change per commit
- Use conventional commit prefixes:

| Prefix | Use for |
|--------|---------|
| `feat:` | New features |
| `fix:` | Bug fixes |
| `refactor:` | Code changes (no new features or fixes) |
| `docs:` | Documentation only |
| `test:` | Adding or updating tests |
| `chore:` | Maintenance, dependencies, config |

## Commit Messages
- Imperative mood: "Add feature" not "Added feature"
- First line: concise summary (50 chars or less)
- Body (if needed): explain why, not what

## Examples
```
feat: add user authentication flow

fix: handle null response from API

refactor: extract validation logic to separate module

docs: update README with setup instructions

chore: update dependencies
```

## Branches
- `main` - stable, production-ready
- `feat/<name>` - feature development
- `fix/<name>` - bug fixes
