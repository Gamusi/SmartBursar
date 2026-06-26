# SmartBursar Coding Standards

## Core checklist

Every change should answer three questions:
- Does it solve today's problem?
- Is it easy to understand six months from now?
- Does it improve the user experience?

If the answer is no, keep it out until it is necessary.

## Naming and structure

- Use clear names for functions, variables, and routes.
- Prefer explicitness over clever shortcuts.
- Keep modules small and focused.
- Separate business logic from I/O and presentation.

## Code style

- Keep functions short and purpose-driven.
- Avoid deep nesting; return early when it improves clarity.
- Use plain objects and simple data shapes where possible.
- Favor composition over complex inheritance or abstractions.

## Comments and documentation

- Document why something exists, not what it does.
- Use README/docs for architecture and decisions.
- Keep inline comments for non-obvious business rules.

## Testing

- Core business rules must have tests.
- Start with simple deterministic tests for the smallest units.
- Do not over-test insignificant implementation details.
