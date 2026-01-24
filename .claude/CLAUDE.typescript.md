# TypeScript/JavaScript Guidelines

## Naming
- `camelCase` for variables and functions
- `PascalCase` for classes, interfaces, types, components
- `UPPER_SNAKE_CASE` for constants

## Code Style
- 4 spaces indentation
- Prefer TypeScript over JavaScript when possible
- Use `const` by default, `let` when reassignment needed
- Prefer arrow functions for callbacks
- Use template literals for string interpolation

## Types
- Prefer interfaces over type aliases for object shapes
- Avoid `any` - use `unknown` if type is truly unknown
- Let TypeScript infer types when obvious

## Error Handling
- Log errors with context before rethrowing or handling
- Use try/catch at boundaries (API calls, user input)
- Prefer early returns to reduce nesting

## Imports
- Group imports: external packages, then internal modules
- Use named exports over default exports
