# SmartBursar Developer Setup

This document describes the local development environment and the commands to start SmartBursar in the current repo.

## Prerequisites

- Git
- Node.js 20+ or compatible
- npm or yarn
- Python 3.11+
- Rust + Cargo (required for Tauri shell only)

## Clone the repository

```powershell
git clone <repo-url>
cd SmartBursar
```

## Frontend setup

1. Open a terminal in `frontend`
2. Install dependencies:
   ```powershell
   npm install
   ```
3. Start the frontend in mock mode:
   ```powershell
   npm run dev
   ```

## Backend setup

The backend is structured as a Python FastAPI app under `backend/app/`.

1. Create and activate a virtual environment:
   ```powershell
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1
   ```
2. Install dependencies as needed. There is no requirements file yet, but the backend is expected to use FastAPI, SQLAlchemy, and Pydantic.

## Running the backend

Start the backend service from `backend` using Uvicorn:

```powershell
uvicorn app.main:app --reload --port 8000
```

If `app.main` does not exist yet, use the backend scaffolding available in `backend/app/`.

## Running the full app shell

When native integration is required, use Tauri dev mode:

```powershell
cd frontend
npm run tauri dev
```

Use this only after the frontend and backend flows are working in development.

## Notes

- The frontend should be run from the `frontend` directory.
- The backend service should expose a local API endpoint, typically `http://localhost:8000/api/v1`.
- Keep the documentation in `docs/developer` and `docs/product` as your source of truth for workflows and architecture.
