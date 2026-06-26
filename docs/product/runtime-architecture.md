# SmartBursar Runtime Architecture

SmartBursar is a single-machine desktop application. Its runtime architecture should reflect that reality.

## Runtime layers

### React — presentation only

React is responsible for:
- rendering pages and components
- collecting user input
- presenting state
- consuming typed IPC methods
- responding to events

React should not know about SQLite, business rules, or file locations.

### Rust — host and integration layer

Rust is responsible for:
- starting and supervising the Python engine
- keeping Python alive and restarting if it fails
- managing IPC over stdin/stdout
- dispatching events to the UI
- accessing files and native OS integration

Rust should not contain school finance logic.
It should only host the runtime.

### Python — application engine

Python is responsible for:
- authentication
- business rules
- SQLite access
- migrations
- CSV imports
- Excel import/export
- ReportLab PDF generation
- background workers
- domain validation and accounting logic

Python is the single source of truth for the business domain.

## Transport and protocol

### Primary transport: stdin/stdout pipes

- No HTTP server required
- No localhost binding or port conflicts
- No firewall or socket management overhead
- Works on Windows, Linux, and macOS

### Protocol: structured JSON-RPC over pipes

Each message should include:
- `jsonrpc` version
- `id`
- `method`
- `params`
- `result` or `error`

Example request:

```json
{
  "jsonrpc": "2.0",
  "id": 184,
  "method": "payments.create",
  "params": {
    "student_id": 17,
    "amount": 250000
  }
}
```

Example success response:

```json
{
  "jsonrpc": "2.0",
  "id": 184,
  "result": {
    "receipt_number": "R-000482"
  }
}
```

Example error response:

```json
{
  "jsonrpc": "2.0",
  "id": 184,
  "error": {
    "code": 4021,
    "message": "Payment exceeds outstanding balance."
  }
}
```

## Background workers

Background work should be event-driven, not polling.

Flow:
- Python worker finishes work
- Python writes an event to stdout
- Rust receives and dispatches the event
- React updates state immediately

This avoids polling, reduces SQLite contention, and improves responsiveness.

## FastAPI as an optional adapter

FastAPI can coexist as a transport adapter, not as the runtime engine.

- Primary runtime: IPC over pipes
- Secondary transport: HTTP via FastAPI for development, testing, or future remote use

The service layer should remain agnostic to transport.
That means the same business service can be invoked via:
- IPC adapter
- HTTP adapter

## Technology roles

- Python: application engine / domain logic
- Rust: process and IPC host
- React: UI presentation
- SQLite: persistent data store

## Why this architecture

- It matches the deployment model: one machine, one database.
- It eliminates network-like complexity from the runtime.
- It keeps responsibilities clean and avoids duplicated behavior.
- It provides a stable path to production without HTTP.
