# SmartBursar — Frontend Architecture and Design Reference

**Project:** SmartBursar  
**Maintained by:** A-Von Computer Solutions  
**Stack:** React + TailwindCSS + Vite inside Tauri desktop shell  
**For:** Frontend Developer reference — complete Phase 1 scope  

---

## How to Use This Document

This is the frontend equivalent of the backend architecture reference. Every screen, every component, every API connection, and every design decision has a place here. Build against this document. When you are unsure where a screen belongs or what data it consumes, come here first.

The frontend connects to the backend via `http://localhost:{PORT}/api/v1/`. During development, use mock data shaped exactly like the real API responses. When the backend is ready, swap the mock for real calls — the shape never changes.

---

## Development Context

The frontend is being developed in parallel by A-Von Computer Solutions, using mock data while the trainee builds the backend. The two will be integrated once the backend reaches Tier 4 and Tier 5 of the training curriculum.

This parallel approach is intentional. The frontend is built against agreed API contract shapes defined in this document. The backend is built to fulfill those same shapes. Integration is a connection step, not a redesign.

**Screen build order:**
1. Authentication (Login)
2. Dashboard
3. Remaining screens sequenced as development progresses

---

## Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| Desktop Shell | Tauri | Native window, system tray, print dialog, file system access |
| UI Framework | React 18 | Component tree, state management |
| Build Tool | Vite | Fast dev server and production bundler |
| Styling | TailwindCSS | Utility-first styling |
| Routing | React Router v6 | Client-side navigation |
| State | Zustand | Lightweight global state (auth, active term, institution) |
| API Client | Axios | HTTP calls to FastAPI backend |
| Forms | React Hook Form | Form state and validation |
| Tables | TanStack Table | Sortable, filterable data tables |
| Date Handling | date-fns | Date formatting and arithmetic |
| PDF Trigger | Tauri shell API | Opens system print dialog on backend-generated PDFs |
| Icons | Lucide React | Consistent icon set |
| Notifications | React Hot Toast | Non-blocking feedback toasts |

**Shell architecture:** The React frontend runs inside the Tauri window. The Python FastAPI backend runs as a sidecar process and connects over a local loopback connection. Tauri handles OS-level operations — file dialogs, print dialogs, system tray. React handles all UI. Python handles all data and business logic.

---

## File Structure

```
frontend/
├── src/
│   ├── main.jsx                        # React entry point
│   ├── App.jsx                         # Root component, router setup
│   │
│   ├── assets/                         # Logos, images, fonts
│   │
│   ├── styles/
│   │   └── globals.css                 # Tailwind directives + custom CSS vars
│   │
│   ├── store/                          # Zustand global state
│   │   ├── authStore.js                # Current user, role, session token
│   │   ├── institutionStore.js         # School name, logo, term structure
│   │   └── termStore.js                # Active academic year and term
│   │
│   ├── hooks/                          # Custom React hooks
│   │   ├── useApi.js                   # Axios wrapper with error handling
│   │   ├── useAuth.js                  # Auth state and role checks
│   │   ├── useTerm.js                  # Active term access
│   │   └── usePrint.js                 # Trigger Tauri print dialog
│   │
│   ├── api/                            # API call definitions (one file per module)
│   │   ├── institution.js
│   │   ├── academic.js
│   │   ├── students.js
│   │   ├── fees.js
│   │   ├── payments.js
│   │   ├── cashbook.js
│   │   ├── banking.js
│   │   ├── expenses.js
│   │   ├── reports.js
│   │   ├── users.js
│   │   └── audit.js
│   │
│   ├── components/                     # Reusable UI components
│   │   ├── layout/
│   │   │   ├── AppShell.jsx            # Sidebar + topbar + main content wrapper
│   │   │   ├── Sidebar.jsx             # Navigation sidebar
│   │   │   ├── Topbar.jsx              # School name, active term, user info
│   │   │   └── PageHeader.jsx          # Title + action buttons per page
│   │   │
│   │   ├── ui/
│   │   │   ├── Button.jsx
│   │   │   ├── Input.jsx
│   │   │   ├── Select.jsx
│   │   │   ├── Modal.jsx
│   │   │   ├── Table.jsx               # Wrapper around TanStack Table
│   │   │   ├── Badge.jsx               # Status badges (paid, pending, voided)
│   │   │   ├── Card.jsx
│   │   │   ├── StatCard.jsx            # Dashboard summary cards
│   │   │   ├── SearchBar.jsx
│   │   │   ├── DatePicker.jsx
│   │   │   ├── ConfirmDialog.jsx       # Destructive action confirmation
│   │   │   ├── EmptyState.jsx          # Empty table/list placeholder
│   │   │   └── LoadingSpinner.jsx
│   │   │
│   │   └── shared/
│   │       ├── StudentPicker.jsx       # Search-and-select a student (used in payments)
│   │       ├── TermBadge.jsx           # Shows current term status
│   │       ├── ReceiptPreview.jsx      # Receipt preview before printing
│   │       ├── RoleGuard.jsx           # Conditionally renders based on user role
│   │       └── PrintButton.jsx         # Triggers Tauri print on a PDF URL
│   │
│   └── pages/                          # One folder per module
│       ├── setup/
│       │   └── SetupWizard.jsx         # First-run institution setup
│       │
│       ├── auth/
│       │   └── Login.jsx
│       │
│       ├── dashboard/
│       │   └── Dashboard.jsx
│       │
│       ├── academic/
│       │   ├── AcademicYears.jsx
│       │   ├── Terms.jsx
│       │   └── Classes.jsx
│       │
│       ├── students/
│       │   ├── StudentList.jsx
│       │   ├── StudentDetail.jsx
│       │   ├── StudentForm.jsx
│       │   └── StudentImport.jsx
│       │
│       ├── fees/
│       │   ├── FeeCategories.jsx
│       │   ├── FeeStructures.jsx
│       │   └── StudentAdjustments.jsx
│       │
│       ├── payments/
│       │   ├── PaymentCollection.jsx   # PRIMARY DAILY-USE SCREEN
│       │   ├── PaymentHistory.jsx
│       │   └── ReceiptLookup.jsx
│       │
│       ├── cashbook/
│       │   └── Cashbook.jsx
│       │
│       ├── banking/
│       │   ├── BankAccounts.jsx
│       │   └── BankDeposits.jsx
│       │
│       ├── expenses/
│       │   ├── ExpenseList.jsx
│       │   ├── ExpenseForm.jsx
│       │   └── ExpenseDetail.jsx
│       │
│       ├── reports/
│       │   └── Reports.jsx
│       │
│       ├── users/
│       │   ├── UserList.jsx
│       │   └── UserForm.jsx
│       │
│       └── audit/
│           └── AuditLog.jsx
```

---

## Design System

### Philosophy

The app is used by bursars and headteachers in Ugandan schools. Many users are not highly technical. The interface must be clean, clear, and forgiving of mistakes. Speed matters — a bursar recording payments during a busy morning does not have time for confusion.

The visual language is professional and trustworthy, not flashy. It should feel like a well-designed banking app, not a startup SaaS product. Every element earns its place.

---



### Theming

Both light and dark mode are fully supported from the start. No dark-only or light-only shortcuts. Every component and color token is designed to render correctly in both modes.

Theming is implemented via CSS custom properties scoped to `[data-theme="light"]` and `[data-theme="dark"]`. The theme toggle writes to a Zustand store and persists to a local config file via Tauri. The app respects the OS system preference on first launch.

Component tokens — surface colors, text colors, border colors, shadow intensities — are all defined as CSS variables. Never hardcode a color that would look wrong in the other mode.

**Light mode palette:**
```
--color-primary:        #1B4F72
--color-primary-light:  #2E86C1
--color-accent:         #1A7A4A
--color-warning:        #B7770D
--color-danger:         #922B21
--color-surface:        #FFFFFF
--color-background:     #F4F6F9
--color-border:         #DDE1E7
--color-text-primary:   #1C2833
--color-text-muted:     #6B7280
```

**Dark mode palette:**
```
--color-primary:        #2E86C1
--color-primary-light:  #5DADE2
--color-accent:         #27AE60
--color-warning:        #F0B429
--color-danger:         #E74C3C
--color-surface:        #1A2235
--color-background:     #0F1623
--color-border:         #1E2D45
--color-text-primary:   #E2E8F0
--color-text-muted:     #64748B
```

---

### Typography

Three fonts are used across the application. All are loaded locally — bundled with the app, never fetched from a CDN at runtime.

**Geist** — primary UI font. Used for body text, labels, inputs, table content, and all general interface copy. Weights 400 and 500.

**Syne** — display and heading font. Used for page titles, section headers, the app title, and any prominent UI element that needs visual weight. Weight 700 and 800. The app title "SmartBursar" uses Syne 800 with `letter-spacing: -0.5px` — the "CashBook" portion rendered in the primary accent color.

**JetBrains Mono** — monospace font. Used for receipt numbers, student IDs, monetary amounts in tables, and any technical or code-style data.

Font size scale:
- xs: 11px — labels, badges, table metadata
- sm: 13px — table body, secondary text
- base: 14px — default body text
- md: 16px — section headings, form labels
- lg: 20px — page titles
- xl: 24px — dashboard stat numbers
- 2xl: 32px — large KPI figures

App title implementation reference:
```jsx
<h1 className="font-extrabold tracking-tight" style={{ fontFamily: 'Syne' }}>
  Smart<span style={{ color: 'var(--color-primary-light)' }}>Bursar</span>
</h1>
```

---

### Spacing

Use Tailwind's default spacing scale. Maintain consistent padding:
- Page outer padding: `px-6 py-5`
- Card inner padding: `p-5`
- Form field gap: `gap-4`
- Section gap: `gap-6`
- Table row height: minimum `h-11`

---

### Status Badges

Used consistently across payments, expenses, students, and terms.

| Status | Color | Usage |
|---|---|---|
| Fully Paid | Green | Payment complete |
| Partial | Amber | Partial payment recorded |
| Unpaid | Red | No payment made |
| Voided | Gray | Voided payment |
| Active | Green | Student enrollment |
| Transferred | Blue | Student transferred |
| Dropout | Orange | Student dropped out |
| Graduate | Purple | Student graduated |
| Draft | Gray | Expense not submitted |
| Pending | Amber | Awaiting approval |
| Approved | Blue | Expense approved |
| Paid | Green | Expense paid |
| Rejected | Red | Expense rejected |
| Open | Green | Term open |
| Closed | Gray | Term closed |
| Frozen | Blue | Term frozen |

---

## Application Layout

### AppShell

The persistent shell wrapping every authenticated screen. Contains:

**Sidebar (left, fixed width 240px):**
- School logo and name at the top
- Navigation items grouped by module (see Navigation Structure below)
- Active term indicator at the bottom of the sidebar showing term label and status
- Current logged-in user name and role
- Logout button

**Topbar (top, full width):**
- Current page title
- Active academic year and term (e.g. "2025 — Term 1")
- Global search bar (searches students by name or ID)
- Notification area (pending expense approvals visible to headteacher)

**Main content area:**
- `PageHeader` component at the top of every page (title + primary action button)
- Scrollable content below

---

### Navigation Structure

Sidebar items are role-controlled. Items the current user cannot access are hidden entirely, not just disabled.

```
Dashboard                           (all roles)

Students
  — Student List                    (all roles)
  — Add Student                     (bursar, data_entry, super_admin)
  — Import from Excel               (bursar, super_admin)

Fees
  — Fee Categories                  (bursar, super_admin)
  — Fee Structures                  (bursar, super_admin)

Payments                            ← PRIMARY SECTION
  — Collect Payment                 (bursar, super_admin)
  — Payment History                 (bursar, headteacher, super_admin)
  — Receipt Lookup                  (bursar, headteacher, super_admin)

Cashbook                            (bursar, headteacher, super_admin)

Banking
  — Bank Accounts                   (bursar, super_admin)
  — Record Deposit                  (bursar, super_admin)

Expenses
  — All Expenses                    (bursar, headteacher, super_admin)
  — New Expense                     (bursar, super_admin)

Reports                             (bursar, headteacher, super_admin)

Settings
  — Academic Structure              (super_admin)
  — Institution Settings            (super_admin)
  — User Management                 (super_admin)
  — Backup & Restore                (super_admin)

Audit Log                           (headteacher, super_admin)
```

---

## Screens — Detailed Description

---

### Setup Wizard (First Run Only)

Triggered automatically when the app launches for the first time and no institution record exists. Cannot be dismissed. Runs as a full-screen overlay with a step indicator.

**Step 1 — School Identity**
Fields: school name, address, phone, email, logo upload (optional).

**Step 2 — Term Structure**
Radio selection: Trimester (3 terms per year) or Semester (2 terms per year). Informational note explaining the choice.

**Step 3 — School Levels**
Checkboxes: Primary (P1–P7), O-Level (S1–S4), A-Level (S5–S6), Tertiary. For Tertiary, additional fields to define year labels and courses.

**Step 4 — First Academic Year**
Input: academic year label (e.g. "2025"). First term is created automatically on completion.

**Step 5 — Admin User**
Create the first Super Admin account. Username and password fields. Password confirmation. Password strength indicator.

**Step 6 — Summary**
Review all entered details before confirming. Edit buttons on each section. Final "Complete Setup" button.

On completion, redirect to Login screen.

---

### Login

Clean centered layout. School logo displayed if already configured. Username and password fields. Login button. No "forgot password" in Phase 1 — password reset is handled by Super Admin.

On successful login, redirect to Dashboard. Store session token in memory (Zustand), never in localStorage.

Role-based redirect: Bursar lands on Payment Collection. Headteacher lands on Dashboard. Data Entry lands on Student List.

---

### Dashboard

Summary view. Data sourced from the active term.

**Stat Cards (top row):**
- Total collected this term (UGX)
- Total outstanding this term (UGX)
- Number of students fully paid
- Number of students with balance
- Cash balance (from cashbook)
- Pending expense approvals (headteacher only)

**Today's Collections (below stat cards):**
Table of today's payments. Columns: time, student name, class, amount, channel, receipt number. Link to full payment history.

**Recent Expenses (below):**
Last 5 expenses with status badges. Link to full expense list.

**Quick Actions (sidebar widget or floating):**
- Collect Payment (bursar)
- Record Deposit (bursar)
- New Expense (bursar)

---

### Student List

Full-width table. Default sort: last name ascending.

**Filters (above table):**
- Search by name or student ID (live search, debounced)
- Filter by class (dropdown, populated from active year classes)
- Filter by status (Active, Transferred, Dropout, Graduate — multi-select)

**Table columns:**
Student ID | Full Name | Class | Guardian | Phone | Balance (UGX) | Status | Actions

Balance column shows outstanding amount for current term. Red if balance > 0, green if fully paid.

Actions column: View, Edit, Collect Payment (shortcut).

**Page header actions:** Add Student | Import from Excel

---

### Student Detail

Two-column layout.

**Left column — Student Info:**
Photo (placeholder if none), full name, student ID, class, date of birth, gender, enrollment status with badge. Guardian details. Edit button.

**Right column — Financial Summary (current term):**
Fee breakdown table: fee category, amount due (after any adjustment), amount paid, balance. Payment plan summary if one exists. Total row at bottom.

**Tabs below:**
- Payment History — all payments for this student across all terms, paginated
- Adjustments — bursary or discount records for this student, with add/remove controls
- Payment Plan — current term plan with installment status

**Actions at top:** Collect Payment | Print Student Statement | Change Status

---

### Student Form (Add / Edit)

Split layout: left for personal details, right for enrollment details.

**Personal details:**
First name, last name, date of birth, gender (dropdown), photo upload (optional).

**Enrollment details:**
Student ID (auto-generated shown as placeholder, editable), class (dropdown grouped by level), guardian name, guardian phone, guardian email (optional).

Validation: all required fields highlighted on submit attempt. No submission until required fields are filled.

---

### Student Import

Step-by-step:

**Step 1 — Upload File**
Drag-and-drop or click to upload `.xlsx` file.

**Step 2 — Column Mapping**
Table showing detected column headers from the file. User maps each detected header to the expected field (name, class, student ID, opening balance). Required mappings highlighted. Optional fields marked.

**Step 3 — Preview**
Table showing first 10 rows as they will be imported. Rows with validation errors highlighted in red with error description. Rows that will be skipped shown with reason.

**Step 4 — Import**
Progress bar. Summary on completion: X imported, Y skipped, Z errors.

---

### Fee Categories

Simple list with add/edit inline or in a slide-over panel.

Columns: Name | Description | Optional (badge) | Active (toggle) | Actions

**Seeded defaults shown on first load if empty:**
Tuition, Development Fee, PTA, Examination Fee, Boarding, Meals, Transport — all editable.

Add/Edit form: name, description, optional checkbox. Cannot delete a category that has fee structures — only deactivate.

---

### Fee Structures

Grid view organized by class. Active term shown in subheader.

**Layout:**
Dropdown at top to select class. Below: table of fee categories with the amount defined for that class in the current term. Empty cells shown as "— Not set" with an add button.

Inline editing of amounts. Save on blur or Enter.

Bulk setup: "Copy from previous term" button if a previous term exists.

---

### Payment Collection (Most Important Screen)

This is the screen the bursar uses dozens of times per day. It must be fast, clear, and error-resistant.

**Layout: two-panel**

**Left panel — Student Selection:**
Large search bar at top. Searches by name or student ID. Results shown as a dropdown list with name, class, and outstanding balance. On selection, panel updates to show selected student card: photo, name, class, total balance for current term.

Below student card: fee breakdown table showing each fee category, amount due, amount paid so far, and remaining balance. Bold total row.

**Right panel — Payment Entry:**

Amount field (large, prominent). UGX prefix shown.

Channel selector (large toggle buttons, not a dropdown):
- Cash
- Bank Slip
- Mobile Money

Channel reference field: appears only for Bank Slip and Mobile Money. Label changes based on channel (Slip Number / Transaction ID).

Payment date: defaults to today, editable.

Fee allocation section: if the amount entered is less than the total balance, a breakdown shows how the amount will be allocated across fee categories. Default allocation order is configurable (Tuition first, then others in order defined). User can manually adjust allocation.

Notes field: optional.

**Action button:** large green "Record Payment + Generate Receipt" button.

**On success:**
- Receipt preview modal appears immediately
- Receipt shows: school name, logo, receipt number (YYYY/T#/NNNN), student name, class, amount, channel, payment date, fee allocation breakdown, recorded-by name, timestamp
- Two buttons: Print Receipt | Close
- Toast notification: "Payment recorded. Receipt [2025/T1/0042]"

**Void payment:**
From payment history. Bursar clicks Void. Confirmation dialog with mandatory reason text field. On confirm, voided payment appears in history with strikethrough and VOIDED badge.

---

### Payment History

Full-width table. Default: current term, today's date range.

**Filters:** Date range | Class | Student search | Channel | Voided (toggle to show/hide)

**Columns:** Receipt No. | Date | Student | Class | Amount | Channel | Recorded By | Status | Actions

Actions: View receipt (print again) | Void (if not already voided)

**Export row at top:** Print Daily Collection Report (opens PDF for current filters)

---

### Receipt Lookup

Single prominent search field. Search by receipt number. Returns full receipt details if found. Print button. Shows voided receipts with clear VOIDED watermark.

---

### Cashbook

Read-only. Cannot be edited by any user through the UI.

**Filter bar:** Date range | Entry type (receipt / expense / deposit / all)

**Table columns:** Date | Description | Debit (in) | Credit (out) | Balance | Reference

Balance column shows running balance after each entry. Color coded: black for debits, red for credits.

**Summary row at top:** Opening Balance | Total In | Total Out | Closing Balance

Print Cashbook Report button at top right.

---

### Bank Accounts

Simple list. Columns: Bank Name | Account Name | Account Number | Active

Add/Edit in slide-over panel.

---

### Bank Deposits

**Filter:** Date range | Bank Account

**Table columns:** Date | Bank Account | Amount | Reference | Deposited By | Actions

Add Deposit button opens form: bank account dropdown, amount, deposit date, reference, notes.

---

### Expense List

**Filter tabs at top:** All | Draft | Pending Approval | Approved | Paid | Rejected

**Table columns:** Date | Description | Category | Payee | Amount | Status | Initiated By | Actions

Actions differ by role and status:
- Bursar on Draft: Edit | Submit for Approval | Delete
- Headteacher on Pending: Approve | Reject
- Bursar on Approved: Mark as Paid | Print Voucher
- Anyone: View Detail

---

### Expense Detail

Full detail view of one expense. Shows all status transitions with timestamps and users. Approval/rejection reason shown prominently if applicable. Print Voucher button.

---

### Expense Form (New / Edit)

Fields: description, category (dropdown), payee name, amount, payment date, document reference (text), notes.

Only editable when in Draft status. Submitted and approved expenses are read-only.

---

### Reports

Hub page. Cards for each report type. Each card shows: report name, description, what it contains, and a "Generate" button.

**Available reports:**

**Daily Collection Report**
Inputs: date (defaults to today). Shows all payments for that day, grouped by channel. Totals row. Print button.

**Fee Balance Report**
Inputs: class filter (optional), status filter. Shows all students with balance summary for current term. Sortable by balance descending. Print button.

**Student Statement**
Inputs: student search. Shows full financial history for one student in current term. All fees, all payments, running balance. Print button.

**Cashbook Report**
Inputs: date range. Shows cashbook entries for range with opening and closing balances. Print button.

**Income vs Expenditure**
Inputs: term (dropdown). Shows total income (payments) vs total expenditure (expenses) for the term. Net balance. Print button.

**Term Financial Summary**
Inputs: term. Summary of all collections, deposits, expenses, and closing balance. Headteacher-facing overview. Print button.

**Outstanding Fees**
Inputs: class filter. All students with outstanding balances, ordered by balance descending. Print button.

All reports: "Generate" first shows a preview in-app. Print button calls `usePrint()` hook which triggers Tauri's native print dialog on the PDF returned by the backend.

---

### Academic Structure Settings (Super Admin)

Three sub-tabs: Academic Years | Terms | Classes

**Academic Years tab:**
List of years. Active year shown with badge. Create new year. Cannot delete a year that has terms.

**Terms tab:**
List of terms for the selected year. Status badge per term. Buttons: Open | Close | Freeze — each with confirmation dialog explaining consequences. Cannot re-open a frozen term.

**Classes tab:**
Grouped by level. Add/edit/reorder classes. Bulk generate defaults button ("Generate P1–P7") for new schools.

---

### Institution Settings (Super Admin)

Form to update school name, address, phone, email, logo. Term structure display (read-only after setup — changing term structure requires a support process). Save button.

---

### User Management (Super Admin)

Table of all users. Columns: Full Name | Username | Role | Status | Last Login | Actions

Add User button opens form: full name, username, password, role dropdown. Role options: Headteacher, Bursar, Data Entry. (Super Admin can only be assigned during setup or by another Super Admin.)

Deactivate user button with confirmation. Cannot deactivate your own account.

---

### Backup and Restore (Super Admin)

**Backup section:**
Current database file path shown. Last backup date and file. Create Backup button — opens file save dialog via Tauri. Passphrase field for encryption (optional but shown as strongly recommended). Backup log table: date, filename, created by.

**Restore section:**
Warning banner explaining restore will overwrite current data. Upload encrypted backup file. Passphrase field. Confirm Restore button with double confirmation dialog.

---

### Audit Log (Super Admin + Headteacher)

**Filters:** Date range | User | Action type | Table name | Search by record ID

**Table columns:** Timestamp | User | Action | Table | Record ID | Summary of Change

Expandable rows: click any row to see full old value and new value as formatted JSON diff.

No export or print in Phase 1. Read-only, always.

---

## API Contract — How Frontend Calls Backend

All API calls go through the `useApi` hook which handles:
- Base URL injection from config
- Session token attachment on every request
- 401 interception → auto logout and redirect to login
- Error normalization → toast notification on 4xx/5xx
- Loading state management

Each file in `frontend/src/api/` exports named async functions. Example pattern:

```javascript
// frontend/src/api/payments.js

export const recordPayment = (payload) =>
  api.post('/payments', payload)

export const getStudentBalance = (studentId) =>
  api.get(`/students/${studentId}/balance`)

export const voidPayment = (paymentId, reason) =>
  api.put(`/payments/${paymentId}/void`, { reason })

export const getPaymentHistory = (filters) =>
  api.get('/payments', { params: filters })
```

During development before the backend is ready, these functions return mock data shaped identically to what the real backend will return. The mock/real switch is a single config flag in `useApi`.

---

## Mock Data Shapes (Development Reference)

These are the shapes the frontend depends on. The backend must return data in exactly these structures.

**Student (from GET /students/{id}):**
```json
{
  "id": 1,
  "student_id": "AVN-2025-001",
  "first_name": "Amara",
  "last_name": "Osei",
  "class_id": 3,
  "class_name": "P.6",
  "guardian_name": "Kofi Osei",
  "guardian_phone": "0772000000",
  "status": "active",
  "created_at": "2025-01-10T08:00:00"
}
```

**Student Balance (from GET /students/{id}/balance):**
```json
{
  "student_id": 1,
  "term_id": 2,
  "term_label": "Term 1 2025",
  "total_due": 750000,
  "total_paid": 300000,
  "outstanding": 450000,
  "breakdown": [
    { "fee_category": "Tuition", "due": 500000, "paid": 300000, "balance": 200000 },
    { "fee_category": "PTA", "due": 50000, "paid": 0, "balance": 50000 },
    { "fee_category": "Development", "due": 200000, "paid": 0, "balance": 200000 }
  ]
}
```

**Payment (from POST /payments — response):**
```json
{
  "id": 42,
  "receipt_number": "2025/T1/0042",
  "student_id": 1,
  "student_name": "Amara Osei",
  "class_name": "P.6",
  "amount": 300000,
  "channel": "cash",
  "channel_reference": null,
  "payment_date": "2025-03-10",
  "recorded_by_name": "Sarah Nakato",
  "is_voided": false,
  "allocations": [
    { "fee_category": "Tuition", "amount_allocated": 300000 }
  ],
  "created_at": "2025-03-10T09:15:00"
}
```

**Expense (from GET /expenses/{id}):**
```json
{
  "id": 7,
  "description": "Chalk and markers for classrooms",
  "category": "Stationery",
  "payee": "Mukwano Supplies",
  "amount": 85000,
  "document_reference": "INV-2025-0089",
  "status": "pending_approval",
  "initiated_by_name": "Sarah Nakato",
  "initiated_at": "2025-03-09T14:00:00",
  "approved_by_name": null,
  "approved_at": null
}
```

**Cashbook Entry (from GET /cashbook):**
```json
{
  "id": 101,
  "entry_type": "receipt",
  "description": "Payment — Amara Osei — Receipt 2025/T1/0042",
  "debit": 300000,
  "credit": 0,
  "balance": 4250000,
  "entry_date": "2025-03-10",
  "reference_id": 42,
  "reference_table": "payments"
}
```

---

## Role-Based UI Rules

These rules are enforced in the frontend with the `RoleGuard` component and `useAuth` hook. They mirror the backend permissions exactly.

| UI Element | Super Admin | Headteacher | Bursar | Data Entry |
|---|---|---|---|---|
| Collect Payment button | Yes | No | Yes | No |
| Void Payment button | Yes | No | Yes | No |
| Approve Expense button | Yes | Yes | No | No |
| Add/Edit Student | Yes | No | Yes | Yes |
| User Management menu | Yes | No | No | No |
| Audit Log menu | Yes | Yes | No | No |
| Reports menu | Yes | Yes | Yes | No |
| Cashbook menu | Yes | Yes | Yes | No |
| Backup menu | Yes | No | No | No |
| Academic Structure settings | Yes | No | No | No |

---

## UX Principles

**Speed over completeness.** The bursar's primary screen is Payment Collection. It must be reachable in one click from anywhere. The student search must return results instantly.

**Confirm before consequence.** Any destructive or irreversible action — void, delete, freeze term, restore backup — requires a confirmation dialog with a clear description of what will happen.

**Always show context.** The active term and academic year must be visible at all times in the topbar. The bursar must never wonder which term they are recording a payment in.

**Fail visibly, not silently.** API errors must produce a visible toast with a human-readable message. Never fail silently. Never show a blank screen on error.

**Offline means offline.** The app must function fully with no internet connection. All API calls go to localhost. No CDN resources at runtime — all fonts and icons are bundled.

**Print is first-class.** Receipts, vouchers, and reports must print cleanly on A4. The print button is always accessible on screens where printing is relevant.

**Numbers are formatted.** All monetary amounts are displayed as `UGX X,XXX,XXX` using Ugandan format. Never show raw numbers without formatting.

**Dates are human.** Show dates as `10 Mar 2025`, not `2025-03-10`. Timestamps as `10 Mar 2025, 9:15 AM`.

---

## Phase 2 Deferred Items

These are not built in Phase 1 but the frontend architecture must not make them impossible to add:

- SMS notification triggers from payment collection screen
- Mobile money API confirmation flow in payment channel section
- Online backup option in Backup screen
- Parent/guardian portal view
- Multi-branch selector in topbar
- Health facility module (separate module folder added when ready)

---

*Frontend architecture maintained by A-Von Computer Solutions. Subject to revision as the project evolves.*
