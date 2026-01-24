# Testing Guidelines

## Philosophy
- Test critical paths and edge cases
- Aim for confidence, not coverage metrics
- Tests should be maintainable - don't over-mock

## What to Test
- Core business logic
- Edge cases and error conditions
- Integration points (APIs, databases)
- User-facing workflows

## What to Skip
- Trivial getters/setters
- Framework code (trust the framework)
- Implementation details that may change

## Test Naming
Use descriptive names that explain expected behavior:
```python
# Good
def test_user_login_fails_with_invalid_password():
    ...

# Bad
def test_login():
    ...
```

## Structure
```
# Arrange - set up test data
# Act - perform the action
# Assert - verify the result
```

## Python
- Use `pytest` as the test runner
- Fixtures for reusable test data
- `pytest-cov` only when coverage info is specifically needed

## TypeScript/JavaScript
- Use `vitest` or `jest`
- Prefer integration tests for React components (testing-library)
