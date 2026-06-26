# SmartBursar — Starting Guidelines

This document outlines the different ways to start and run the application during development.

---

## 1. Frontend Development (Mock Mode)
**Best for:** UI/UX development, building new screens, and state management without worrying about the backend.

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Ensure `.env` is set to mock mode:
   ```env
   VITE_MOCK_MODE=true
   ```
3. Start the Vite development server:
   ```bash
   bun dev
   ```
4. Open your browser to `http://localhost:1420`.

---

## 2. Frontend Connected to Backend
**Best for:** Integration testing and verifying real data flows.

### Step A: Start the Backend
1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Activate your virtual environment and start the FastAPI server:
   ```bash
   # Standard FastAPI start (example)
   python -m uvicorn app.main:app --reload --port 8000
   ```

### Step B: Start the Frontend
1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Update `.env` to disable mock mode:
   ```env
   VITE_MOCK_MODE=false
   VITE_API_BASE_URL=http://localhost:8000/api/v1
   ```
3. Start the dev server:
   ```bash
   bun dev
   ```

---

## 3. Full Desktop Application (Tauri Shell)
**Best for:** Testing native features like printing, file system access, and the overall "feel" of the desktop app.

1. Ensure the backend is configured to run as a sidecar (see `src-tauri/tauri.conf.json`).
2. From the project root or frontend directory:
   ```bash
   bun tauri dev
   ```
*This command compiles the Rust shell, starts the frontend dev server, and launches the native window.*

---

## Summary of Configuration (.env)

| Variable | Description | Recommended Value |
|---|---|---|
| `VITE_API_BASE_URL` | The endpoint for the FastAPI backend | `http://localhost:8000/api/v1` |
| `VITE_MOCK_MODE` | Enable/Disable mock data interceptors | `true` (UI Dev) / `false` (Integration) |

---

## Troubleshooting

- **Port Conflicts:** Ensure port `1420` (Frontend) and `8000` (Backend) are free.
- **Dependency Issues:** Run `bun install` in `frontend` if you encounter missing types or modules.
- **Tauri Errors:** Ensure you have the [Tauri prerequisites](https://tauri.app/v1/guides/getting-started/prerequisites) installed (Rust, WebKit2GTK, etc.).
