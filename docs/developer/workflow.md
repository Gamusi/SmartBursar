# SmartBursar Developer Workflow

This document explains how to move from idea to implementation to release.

## Development cycle

1. Idea
2. Specification
3. Implementation
4. Self Review
5. AI Review
6. Manual Testing
7. Merge
8. Release Notes

## Use the development roadmap

The roadmap is a practical guide to the product. It exists to help coordinate building the application and tracking milestones.

## Feature delivery

- Keep features small and valuable.
- Build one useful loop at a time.
- Prefer solving the school’s next real need over implementing a broad training task.
- Use the IPC-first runtime architecture as the primary delivery model.

### Runtime architecture

The primary runtime path is:

React → Tauri Invoke → Rust → stdin/stdout JSON-RPC → Python

FastAPI remains optional, not required, and should be treated as a secondary transport adapter.

## Documentation expectations

- Record important decisions in `docs/product/decisions.md`.
- Keep architecture notes in `docs/product/architecture.md` and `docs/backend`.
- Capture developer workflow and coding principles in `docs/developer`.

## Testing and validation

- Validate the user flow manually on the target platform.
- Use tests for core business rules.
- Keep test coverage focused on reliability, not on covering every line.
