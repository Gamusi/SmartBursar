# SmartBursar — Day 1 Scaffold Setup

This is your first working SmartBursar app. It communicates via IPC over pipes, runs offline, and has a status page for testing connectivity.

## What you have now

✅ **Python sidecar** (`backend/sidecar.py`) — JSON-RPC 2.0 message handler  
✅ **Rust Tauri shell** (`src-tauri/src/main.rs`) — IPC manager and process host  
✅ **React status page** (`frontend/src/pages/status/Status.jsx`) — Tests ping/pong  
✅ **Development roadmap** (`DEVELOPMENT_PLAN.md`) — Full task list for all phases  

## Prerequisites

On your Windows/Linux/Mac dev machine, ensure you have:

- **Node.js** 18+ or **Bun**
- **Python** 3.11+
- **Rust** toolchain (for Tauri)
- **Tauri CLI** (installed automatically by `tauri dev`)

## Quick start

### 1. Install Python dependencies (backend)

```bash
cd backend
pip install -r requirements.txt
```

### 2. Install frontend dependencies

```bash
cd frontend
bun install
# or: npm install
```

### 3. Run the dev stack

From the `frontend` directory:

```bash
bun tauri dev
```

This will:
1. Compile the Rust shell
2. Start the React Vite dev server
3. Open a native Tauri window
4. Ready for you to navigate to the status page

### 4. Test the IPC connection

When the window opens:
1. The app will try to auto-navigate to `/status`
2. Click **"Check Status"** — you should see `connected`
3. Click **"Test Ping"** — you should see a JSON response from Python
4. Check the terminal for logs from the sidecar

---

## What happens under the hood

```
React Store (UI state)
         ↓
Tauri Invoke (window.invoke)
         ↓
Rust IPC Manager
         ↓
JSON-RPC Message
         ↓
Python Sidecar (stdin/stdout)
         ↓
SQLite (future)
```

No HTTP. No ports. No firewalls. Just local pipes.

---

## The IPC protocol

Request from React:
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "ping.echo",
  "params": {"message": "Hello"}
}
```

Response from Python:
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {"echo": "Hello", "pong": true}
}
```

Error response:
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "error": {"code": -32601, "message": "Method not found"}
}
```

---

## File structure (what's new)

```
backend/
├── sidecar.py                    <-- NEW: Python IPC handler
├── requirements.txt              <-- NEW: Python deps
└── app/
    ├── __init__.py               <-- NEW: Package marker
    ├── api/
    ├── models/
    ├── schemas/
    ├── services/
    ├── reports/
    └── utils/

src-tauri/
└── src/
    └── main.rs                   <-- NEW: Rust IPC & Tauri commands

frontend/
└── src/
    └── pages/
        └── status/
            └── Status.jsx        <-- NEW: Day 1 test page
```

---

## Troubleshooting

### "Python: command not found"
```bash
# Verify Python is installed
python --version
# or
python3 --version
```

### "Tauri CLI not found"
```bash
# Install from Bun
bun add -D @tauri-apps/cli

# Or from Cargo
cargo install tauri-cli
```

### "ERR_FILE_NOT_FOUND: No such file"
Make sure you're running from the `frontend` directory:
```bash
cd frontend
bun tauri dev
```

### Port 1420 already in use
Edit `src-tauri/tauri.conf.json` and change the `devPath` or host settings.

### React shows blank/not loading
- Check the browser console (press F12 in the window)
- Verify Vite dev server is running (should see it in terminal)
- Try refreshing the page

### IPC shows "tauri-unavailable"
- Make sure you used `bun tauri dev`, not just `bun dev`
- The Tauri IPC API is only available in the native window

---

## Next steps (from DEVELOPMENT_PLAN.md)

Once the status page shows `connected`:

1. **P1.1 — Student CRUD**
   - Build SQLAlchemy Student model
   - Add IPC methods: `students.create`, `students.list`, `students.get`, etc.
   - Create React Student List page

2. **P1.2 — Payment Collection**
   - Add Payment model and receipt generation
   - Implement `payments.create` IPC method
   - Create React Payment Collection page

3. **P1.3 — Expenses**
   - Add Expense model
   - Implement `expenses.create` IPC method
   - Create React Expense Entry page

4. **P1.4 — Cashbook Automation**
   - Auto-create cashbook entries from payments/expenses
   - Add `cashbook.list` and `cashbook.getBalance` IPC methods
   - Create React Cashbook Viewer page

5. **P1.5 — Dashboard**
   - Build summary metrics page
   - Wire to `dashboard.summary` IPC method

---

## Development workflow

1. **Edit code** (Python, Rust, React)
2. **Hot reload** — React/Vite auto-reload on changes
3. **For Rust changes** — restart `bun tauri dev`
4. **Test through status page** or your new feature pages
5. **Commit regularly** — `git add . && git commit -m "feat: ..."`

---

## References

- **Roadmap:** [DEVELOPMENT_PLAN.md](../DEVELOPMENT_PLAN.md)
- **Architecture:** [docs/product/runtime-architecture.md](../docs/product/runtime-architecture.md)
- **Decisions:** [docs/product/decisions.md](../docs/product/decisions.md)
- **Tauri docs:** https://tauri.app/
- **JSON-RPC 2.0 spec:** https://www.jsonrpc.org/specification

Happy coding! 🚀

