# Tauri Reference

## Role of Tauri

Tauri provides the native desktop shell for SmartBursar.
It hosts the frontend UI and enables system integration like printing and file access.

## Key points

- Use Tauri for packaging the app as a native desktop executable.
- Keep the frontend and backend code separate.
- Use Tauri only for native concerns, not for business logic.

## Recommended workflow

- Develop the frontend in the browser or Vite dev server.
- Develop the backend as a local FastAPI service.
- Use `tauri dev` only when testing native integration.

## Deployment

- Target Windows first.
- Keep packaging configuration minimal.
- Document the build and release steps clearly.
