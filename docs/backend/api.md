# Backend API Guide

## Principles

- Keep endpoints small and predictable.
- Model API behavior around real school tasks.
- Return clear JSON responses with consistent status codes.
- Validate input at the boundary using Pydantic.

## Versioning

Use an explicit API version prefix, for example:
- `GET /api/v1/students`
- `POST /api/v1/payments`

## Recommended routes

All routes are prefixed with `/api/v1`.

### Institution
- `GET /institution` — Get school profile details
- `POST /institution/setup` — First-run configurations
- `PUT /institution` — Update details

### Academic Structure
- `GET /academic-years` — List all academic years
- `POST /academic-years` — Create a new academic year
- `POST /academic-years/{id}/generate-terms` — Generate terms for standard calendar
- `GET /terms` / `POST /terms` — Manage terms list
- `PUT /terms/{id}/open` / `/close` / `/freeze` — Manage term states
- `GET /classes` / `POST /classes` / `PUT /classes/{id}` — Manage classes

### Students
- `GET /students` / `POST /students` — List and register students
- `GET /students/{id}` / `PUT /students/{id}` — Get/edit student details
- `PUT /students/{id}/status` — Enforce student status transitions (dropout, transfer)
- `POST /students/import` — Import student registry from Excel spreadsheet

### Fee Management
- `GET /fee-categories` / `POST /fee-categories` — Custom fee categories (e.g. tuition, meals)
- `GET /fee-structures` / `POST /fee-structures` — Manage structured fees per class per term
- `GET /students/{id}/adjustments` / `POST /students/{id}/adjustments` — Register bursaries and fee waivers

### Payments
- `GET /payments` / `POST /payments` — List payments and record new collections
- `GET /payments/{id}` — View payment details
- `PUT /payments/{id}/void` — Void a payment (requires reason, triggers cashbook correction)
- `GET /payments/receipt/{number}` — Lookup transaction by receipt number
- `GET /students/{id}/balance` — Get outstanding balances breakdown

### Expenses
- `GET /expenses` / `POST /expenses` — List and record expenditures
- `PUT /expenses/{id}/submit` / `/approve` / `/reject` — Expense workflow transitions
- `PUT /expenses/{id}/mark-paid` — Complete expenditure payment (creates cashbook entry)

### Staff & Payroll
- `GET /staff` / `POST /staff` / `PUT /staff/{id}` — Manage employee directory
- `GET /staff-payments` / `POST /staff-payments` — List and record salary payments
- `PUT /staff-payments/{id}/approve` — Approve monthly salary disbursement
- `PUT /staff-payments/{id}/mark-paid` — Disburse payment (creates cashbook entry)

### Reports (Supports `?format=pdf` query param)
- `GET /reports/daily-collection` — Daily collection breakdown
- `GET /reports/fee-balances` — Outstanding student balances
- `GET /reports/student-statement/{id}` — PDF ledger of single student transactions
- `GET /reports/cashbook` — Running ledger within date range
- `GET /reports/income-expenditure` — Simple income statement
- `GET /reports/term-summary` — Term financial status summary
- `GET /reports/payroll` — Monthly payroll report

### Users & Authentication
- `POST /auth/login` / `/logout` — Session management
- `GET /users` / `POST /users` / `PUT /users/{id}/deactivate` — RBAC control (Admin only)

## Error handling

- Use `400` for bad requests
- Use `404` for missing resources
- Use `422` for validation errors
- Use `500` only for unexpected failures

## Notes

Simple APIs are easier to maintain and test.
Avoid adding generic query features until the product needs them.
