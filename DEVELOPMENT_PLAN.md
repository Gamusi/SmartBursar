# SmartBursar Development Plan

This is the actionable roadmap for one developer, organized into phases and daily checkpoints.

## Day 1 — Scaffold and Ping

Goal: have a working app you can run, even if it only shows a status page.

### Tasks

- [ ] Set up Tauri shell with React frontend
- [ ] Create minimal Rust IPC manager (message dispatch via stdin/stdout)
- [ ] Create Python sidecar stub with JSON-RPC echo handler
- [ ] Add React status page (displays "Connected" or "Disconnected")
- [ ] Test the ping/pong loop manually
- [ ] Add `bun run dev` and `bun run prod` scripts
- [ ] Document the setup in `README`

At end of Day 1:
- `bun run dev` starts the full stack: Tauri + React + Python
- React shows a "Status: Connected" message
- You can see JSON-RPC messages flowing in the terminal

---

## Phase 1 — Core MVP

Goal: functional student registry, payment collection, expense recording, and cashbook persistence.

### Checkpoint P1.1 — student CRUD

- [ ] Define SQLAlchemy Student model
- [ ] Add Alembic migration for students table
- [ ] Create `students.create` IPC method (JSON-RPC)
- [ ] Create `students.list` IPC method
- [ ] Create `students.get` IPC method
- [ ] Create `students.update` IPC method
- [ ] Create `students.delete` IPC method
- [ ] Add test for student service layer
- [ ] Build React page: Student List
- [ ] Build React page: Create Student (form)
- [ ] Wire frontend to IPC methods
- [ ] Test end-to-end: create a student in the UI, verify it appears in the list

### Checkpoint P1.2 — payment collection

- [ ] Define SQLAlchemy Payment model
- [ ] Define SQLAlchemy Receipt model
- [ ] Add Alembic migrations
- [ ] Create PaymentService with business logic:
  - validate student exists
  - validate amount is positive
  - generate receipt number
  - create payment record and receipt record
- [ ] Create `payments.create` IPC method
- [ ] Create `payments.list` IPC method
- [ ] Create `payments.getStudentBalance` IPC method
- [ ] Add tests for payment business rules
- [ ] Build React page: Payment Collection (search student, input amount, submit)
- [ ] Wire frontend to payment IPC methods
- [ ] Test end-to-end: record a payment, verify receipt number was generated, verify balance was updated

### Checkpoint P1.3 — expense recording

- [ ] Define SQLAlchemy Expense model
- [ ] Add Alembic migration
- [ ] Create ExpenseService with business logic
- [ ] Create `expenses.create` IPC method
- [ ] Create `expenses.list` IPC method
- [ ] Add tests
- [ ] Build React page: Expense Entry (description, amount, approval)
- [ ] Wire frontend to expense IPC methods
- [ ] Test end-to-end

### Checkpoint P1.4 — cashbook automation

- [ ] Define SQLAlchemy CashbookEntry model
- [ ] Add Alembic migration
- [ ] Create CashbookService with automatic entry creation:
  - payment recorded → debit entry
  - expense recorded → credit entry
  - deposit recorded → debit entry
- [ ] Integrate cashbook creation into payment, expense, and deposit services
- [ ] Create `cashbook.list` IPC method (with date range filter)
- [ ] Create `cashbook.getBalance` IPC method
- [ ] Add tests for cashbook logic
- [ ] Build React page: Cashbook Viewer (list entries, show running balance)
- [ ] Wire frontend to cashbook IPC methods
- [ ] Test end-to-end: record payment → see cashbook entry created automatically

### Checkpoint P1.5 — dashboard

- [ ] Create `dashboard.summary` IPC method (returns counts, balances, today's total)
- [ ] Build React Dashboard page (shows key metrics)
- [ ] Wire to IPC method
- [ ] Test

### Checkpoint P1.6 — staff & payroll

- [ ] Define SQLAlchemy Staff and StaffPayment models
- [ ] Add Alembic migrations
- [ ] Create StaffService with monthly payroll disbursement logic (enforce unique monthly payments)
- [ ] Create `staff.create`, `staff.list`, `staff.update` IPC methods
- [ ] Create `staffPayments.disburse`, `staffPayments.list` IPC methods
- [ ] Add tests for payroll business rules
- [ ] Build React pages: Staff Directory and Monthly Payroll
- [ ] Wire to IPC methods
- [ ] Test end-to-end: record staff payment, verify automatic cashbook debit entry

**End of Phase 1 checklist:**
- ✅ Students and staff can be registered
- ✅ Payments can be recorded and receipts generated
- ✅ Expenses and staff payroll can be recorded
- ✅ Cashbook entries are automatic
- ✅ Basic dashboard shows status
- ✅ All data persists to SQLite
- ✅ App is stable enough to use for a full day

---

## Phase 2 — Cashbook and Reports

Goal: make daily and term reporting useful.

### Checkpoint P2.1 — daily collection report

- [ ] Create ReportService with PDF generation (ReportLab)
- [ ] Implement daily collection report logic (sum payments for a date)
- [ ] Create `reports.dailyCollection` IPC method
- [ ] Build React page: Reports (date picker, generate button)
- [ ] Wire frontend to report IPC
- [ ] Test PDF output
- [ ] Add ability to save PDF to a user-selected location

### Checkpoint P2.2 — student statement report

- [ ] Implement student statement report logic
- [ ] Create `reports.studentStatement` IPC method
- [ ] Wire to React
- [ ] Test

### Checkpoint P2.3 — term summary

- [ ] Implement term summary report logic
- [ ] Create `reports.termSummary` IPC method
- [ ] Wire to React
- [ ] Test

### Checkpoint P2.4 — receipt generation and printing

- [ ] Ensure receipt PDF can be printed
- [ ] Add print dialog integration (Tauri native)
- [ ] Test printing from React UI

**End of Phase 2 checklist:**
- ✅ Reports are generated as PDFs
- ✅ User can print receipts and reports
- ✅ Daily collections are clear and auditable

---

## Phase 3 — Offline Polish

Goal: make the app reliable and maintainable.

### Checkpoint P3.1 — backup and restore

- [ ] Create BackupService (encrypts SQLite, saves to user location)
- [ ] Create `backup.create` IPC method
- [ ] Create `backup.restore` IPC method
- [ ] Build React page: Settings (backup/restore buttons)
- [ ] Wire to IPC
- [ ] Test encryption and restoration

### Checkpoint P3.2 — Excel import

- [ ] Create ExcelImportService (reads students from .xlsx)
- [ ] Create `import.studentsFromExcel` IPC method
- [ ] Build React page: Import (file picker, validation preview, confirm)
- [ ] Wire to IPC
- [ ] Test with sample Excel file

### Checkpoint P3.3 — error handling and validation

- [ ] Review all error responses in Python
- [ ] Ensure IPC errors are user-friendly
- [ ] Add validation at API layer (not just database)
- [ ] Build error display in React UI
- [ ] Test edge cases (duplicate student ID, negative payment, etc.)

### Checkpoint P3.4 — performance and testing

- [ ] Run app on low-spec Windows machine
- [ ] Optimize SQLite queries if needed
- [ ] Add integration tests for core flows
- [ ] Test large datasets (1000+ students)

**End of Phase 3 checklist:**
- ✅ User can backup and restore data
- ✅ User can import students from Excel
- ✅ Error messages are clear
- ✅ App feels fast even on low-spec hardware

---

## Phase 4 — Packaging and Release

Goal: deliver a native desktop build.

### Checkpoint P4.1 — Tauri build

- [ ] Test `bun tauri build` for Windows
- [ ] Create installer
- [ ] Test installation on clean Windows 10 machine
- [ ] Create uninstall logic

### Checkpoint P4.2 — Release notes and docs

- [ ] Write first user guide (PDF or markdown)
- [ ] Document system requirements
- [ ] Create release notes for v1.0.0
- [ ] Add troubleshooting section

**End of Phase 4 checklist:**
- ✅ App can be installed on a Windows machine
- ✅ User can run it without developer tools
- ✅ First release is documented and ready for schools

---

## Phase 5 — Maintainable Growth

Goal: keep the product simple and reliable.

### Ongoing

- [ ] Before adding a new feature, ask: "Does this solve today's problem?"
- [ ] Document decisions in `docs/product/decisions.md`
- [ ] Keep the IPC protocol and service layer clean
- [ ] Add tests for any new business logic
- [ ] Keep the React UI simple and predictable
- [ ] Refactor only when clarity improves

---

## Daily checkpoint template

At the end of each day, update this file with:

```
### Day N

Completed:
- (task from above)

In-progress:
- (task)

Blockers:
- (none, or describe)

Notes:
- (anything important)
```

---

## Reference

**Primary files:**
- `docs/product/runtime-architecture.md` — how components communicate
- `docs/product/decisions.md` — architectural decisions
- `docs/developer/development-roadmap.md` — high-level feature phases
- `docs/backend/api.md` — IPC method naming and contract

**Development workflow:**
- Create a feature branch: `git checkout -b feature/students-crud`
- Implement, test, and self-review
- Merge when the feature works and the code is clear
- Update `DEVELOPMENT_PLAN.md` with daily notes

**Quick reference:**

| Tool | Purpose |
|---|---|
| Python | Business logic, database, reports |
| Rust | Process management, IPC, OS integration |
| React | UI rendering and state |
| SQLite | Persistent data storage |
| IPC (JSON-RPC) | Communication between React and Python |

