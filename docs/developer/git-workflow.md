# SmartBursar Git Workflow

## One-developer workflow

This project is built by a single developer. The workflow is:

1. Idea
2. Specification
3. Implementation
4. Self Review
5. AI Review
6. Manual Testing
7. Merge
8. Release Notes

The reviewer is you, supported by AI.

## Branch strategy

Use descriptive feature branches:
- `feature/student-crud`
- `feature/payment-collection`
- `fix/cashbook-balance`
- `chore/docs-update`

Keep branches small and focused.

## Commit conventions

Use simple conventional commits:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `chore:` for maintenance
- `refactor:` for code cleanup
- `test:` for test additions

Example:
- `feat: add student create endpoint`
- `fix: correct cashbook entry amount`

## Pull requests

A PR is a record of the change, not a gate.

- Write a short description of what was changed.
- Explain why the change was made.
- List any manual testing steps.
- Link to related architecture or decision docs if needed.

## Review process

- Self-review first: verify the change meets the three core questions.
- Use AI for a second pass: code quality, edge cases, and docs.
- Run the app and confirm the user flow manually.
- Merge when the change is clear and complete.
