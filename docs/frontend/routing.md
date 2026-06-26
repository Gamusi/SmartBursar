# Frontend Routing Guide

## Routing principles

- Keep routes shallow and predictable.
- Use route paths that map directly to user tasks.
- Avoid deeply nested routes unless the screen hierarchy requires it.

## Suggested route structure

- `/login`
- `/dashboard`
- `/students`
- `/students/:studentId`
- `/payments`
- `/expenses`
- `/cashbook`
- `/reports`

## Navigation rules

- Primary navigation should reflect the main user tasks.
- Keep the sidebar focused on the most important screens.
- Use route-based guards for authenticated access.

## Implementation notes

- Use client-side routing with React Router.
- Keep the app shell separate from page components.
- Keep mock mode and real backend mode consistent in route behavior.
