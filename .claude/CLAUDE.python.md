# Python Guidelines

## Dependency Management
- Use `uv` for all dependency management (not pip, poetry, or conda)
- `uv init` for new projects
- `uv add <package>` to add dependencies
- `uv sync` to install from lockfile

## Naming
- `snake_case` for variables, functions, modules
- `PascalCase` for classes
- `UPPER_SNAKE_CASE` for constants

## Code Style
- 4 spaces indentation
- Type hints for function signatures
- Docstrings only for public APIs or complex functions
- Prefer f-strings for string formatting

## Error Handling
- Log errors with context (relevant variables, state)
- Use structured logging (e.g., `logging` module or `structlog`)
- Let exceptions bubble up unless there's a specific recovery action

## Project Structure
```
project/
├── src/
│   └── package_name/
│       ├── __init__.py
│       └── ...
├── tests/
├── pyproject.toml
└── README.md
```
