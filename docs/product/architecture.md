# SmartBursar — Complete Backend Architecture Reference

**Project:** SmartBursar  
**Maintained by:** A-Von Computer Solutions  
**For:** Backend Developer — reference from Task 4.3 through Tier 5  

---

## How to Use This Document

This is your north star for the entire backend. Every file you create, every table you design, every endpoint you build has a place in this document. When you are unsure where something belongs or what it should be named, come here first.

You will not build everything at once. You will build it module by module, task by task. But knowing the full picture from the start means every decision you make is intentional, not accidental.

---

## File Structure

```
backend/
├── app/
│   ├── main.py                         # FastAPI app entry point
│   ├── database.py                     # SQLAlchemy engine and session setup
│   ├── dependencies.py                 # Shared FastAPI dependencies (e.g. get_db)
│   │
│   ├── models/                         # SQLAlchemy database models (tables)
│   │   ├── __init__.py
│   │   ├── institution.py              # Institution setup
│   │   ├── academic.py                 # Academic years, terms, classes
│   │   ├── student.py                  # Students
│   │   ├── fee.py                      # Fee categories, structures, adjustments
│   │   ├── payment.py                  # Payments, allocations, receipts
│   │   ├── payment_plan.py             # Payment plans per student per term
│   │   ├── cashbook.py                 # Cashbook entries
│   │   ├── banking.py                  # Bank accounts and deposits
│   │   ├── expense.py                  # Expenses and vouchers
│   │   ├── user.py                     # Users and roles
│   │   └── audit.py                    # Audit log
│   │
│   ├── schemas/                        # Pydantic request and response models
│   │   ├── __init__.py
│   │   ├── institution.py
│   │   ├── academic.py
│   │   ├── student.py
│   │   ├── fee.py
│   │   ├── payment.py
│   │   ├── payment_plan.py
│   │   ├── cashbook.py
│   │   ├── banking.py
│   │   ├── expense.py
│   │   ├── user.py
│   │   └── audit.py
│   │
│   ├── api/                            # Route handlers (thin — no business logic here)
│   │   ├── __init__.py
│   │   ├── institution.py
│   │   ├── academic.py
│   │   ├── students.py
│   │   ├── fees.py
│   │   ├── payments.py
│   │   ├── payment_plans.py
│   │   ├── cashbook.py
│   │   ├── banking.py
│   │   ├── expenses.py
│   │   ├── reports.py
│   │   ├── users.py
│   │   └── audit.py
│   │
│   ├── services/                       # Business logic (all heavy lifting goes here)
│   │   ├── __init__.py
│   │   ├── institution_service.py
│   │   ├── academic_service.py
│   │   ├── student_service.py
│   │   ├── fee_service.py
│   │   ├── payment_service.py
│   │   ├── payment_plan_service.py
│   │   ├── cashbook_service.py
│   │   ├── banking_service.py
│   │   ├── expense_service.py
│   │   ├── receipt_service.py
│   │   ├── report_service.py
│   │   ├── user_service.py
│   │   └── audit_service.py
│   │
│   ├── reports/                        # PDF generation
│   │   ├── __init__.py
│   │   ├── receipt.py                  # Official receipt PDF
│   │   ├── voucher.py                  # Expense voucher PDF
│   │   ├── daily_collection.py         # Daily collection report PDF
│   │   ├── student_statement.py        # Per-student statement PDF
│   │   ├── cashbook_report.py          # Cashbook PDF
│   │   ├── fee_balance.py              # Fee balance report PDF
│   │   ├── term_summary.py             # Term financial summary PDF
│   │   └── income_expenditure.py       # Income vs expenditure PDF
│   │
│   └── utils/                          # Helpers and utilities
│       ├── __init__.py
│       ├── receipt_number.py           # Receipt number generation (YYYY/T#/NNNN)
│       ├── security.py                 # Password hashing, token handling
│       ├── excel_import.py             # Excel file parsing and validation
│       └── backup.py                   # Backup and restore logic
│
├── migrations/                         # Alembic migration files
│   ├── env.py
│   ├── script.py.mako
│   └── versions/
│       └── (migration files go here)
│
├── tests/
│   ├── scratch/                        # Tier 1-3 learning scripts (not production code)
│   ├── test_institution.py
│   ├── test_academic.py
│   ├── test_students.py
│   ├── test_fees.py
│   ├── test_payments.py
│   ├── test_cashbook.py
│   ├── test_expenses.py
│   ├── test_reports.py
│   └── test_users.py
│
├── alembic.ini                         # Alembic configuration
└── requirements.txt                    # Python dependencies
```

---

## Database Schema

Every table is described with its columns, types, and relationships.

---

### institution

One row only. Stores the identity and configuration of the school using the app.

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key, always 1 |
| name | VARCHAR | School name |
| address | VARCHAR | Physical address |
| logo_path | VARCHAR | Path to logo file on disk |
| phone | VARCHAR | Contact number |
| email | VARCHAR | Contact email |
| term_structure | VARCHAR | "trimester" or "semester" |
| current_academic_year_id | INTEGER | FK to academic_years |
| created_at | DATETIME | Auto |

---

### academic_years

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| year | VARCHAR | e.g. "2025" |
| is_active | BOOLEAN | Only one active at a time |
| created_at | DATETIME | Auto |

---

### terms

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| academic_year_id | INTEGER | FK to academic_years |
| term_number | INTEGER | 1–3 (trimester) or 1–2 (semester) |
| label | VARCHAR | e.g. "Term 1" or "Semester 2" |
| start_date | DATE | |
| end_date | DATE | |
| status | VARCHAR | "open", "closed", "frozen" |
| receipt_counter | INTEGER | Current receipt sequence number, starts at 0 |
| created_at | DATETIME | Auto |

---

### classes

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| academic_year_id | INTEGER | FK to academic_years |
| name | VARCHAR | e.g. "P.6", "S.3", "Year 2" |
| level | VARCHAR | "primary", "olevel", "alevel", "tertiary" |
| stream | VARCHAR | Optional e.g. "East", "West" |
| created_at | DATETIME | Auto |

---

### students

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| student_id | VARCHAR | School-defined or auto-generated, unique |
| first_name | VARCHAR | |
| last_name | VARCHAR | |
| date_of_birth | DATE | Optional |
| gender | VARCHAR | |
| class_id | INTEGER | FK to classes |
| guardian_name | VARCHAR | |
| guardian_phone | VARCHAR | |
| guardian_email | VARCHAR | Optional |
| photo_path | VARCHAR | Optional |
| status | VARCHAR | "active", "transferred", "dropout", "graduate" |
| status_reason | VARCHAR | Required when status is not active |
| status_changed_at | DATETIME | When status last changed |
| created_at | DATETIME | Auto |
| updated_at | DATETIME | Auto |

---

### fee_categories

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| name | VARCHAR | e.g. "Tuition", "PTA", "Boarding" |
| description | VARCHAR | Optional |
| is_optional | BOOLEAN | Whether this fee can be skipped per student |
| is_active | BOOLEAN | |
| created_at | DATETIME | Auto |

---

### fee_structures

Defines how much a class owes per fee category per term.

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| class_id | INTEGER | FK to classes |
| term_id | INTEGER | FK to terms |
| fee_category_id | INTEGER | FK to fee_categories |
| amount | DECIMAL | Expected amount |
| created_at | DATETIME | Auto |

---

### student_fee_adjustments

Per-student overrides to the standard fee structure.

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| student_id | INTEGER | FK to students |
| fee_structure_id | INTEGER | FK to fee_structures |
| adjustment_type | VARCHAR | "percentage" or "absolute" |
| adjustment_value | DECIMAL | e.g. 50 for 50% or 30000 for flat reduction |
| reason | VARCHAR | Bursary, scholarship, etc. |
| created_at | DATETIME | Auto |

---

### payment_plans

Structured installment plans per student per term.

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| student_id | INTEGER | FK to students |
| term_id | INTEGER | FK to terms |
| total_amount | DECIMAL | Total expected under this plan |
| installment_count | INTEGER | Number of installments agreed |
| notes | VARCHAR | Optional context |
| created_at | DATETIME | Auto |

---

### payment_plan_installments

Individual installments within a payment plan.

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| payment_plan_id | INTEGER | FK to payment_plans |
| installment_number | INTEGER | 1, 2, 3... |
| amount_due | DECIMAL | |
| due_date | DATE | Optional |
| is_paid | BOOLEAN | Updated when payment recorded |

---

### payments

The central transaction table. Every payment recorded by the bursar.

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| student_id | INTEGER | FK to students |
| term_id | INTEGER | FK to terms |
| receipt_number | VARCHAR | Generated: YYYY/T#/NNNN — unique, never reused |
| amount | DECIMAL | Total amount received |
| channel | VARCHAR | "cash", "bank_slip", "mobile_money" |
| channel_reference | VARCHAR | Slip number, transaction ID, etc. |
| payment_date | DATE | Date money was received |
| recorded_by | INTEGER | FK to users |
| is_voided | BOOLEAN | Default false |
| void_reason | VARCHAR | Required if voided |
| voided_by | INTEGER | FK to users |
| voided_at | DATETIME | |
| notes | VARCHAR | Optional |
| created_at | DATETIME | Auto |

---

### payment_allocations

How a single payment is split across fee categories.

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| payment_id | INTEGER | FK to payments |
| fee_category_id | INTEGER | FK to fee_categories |
| amount_allocated | DECIMAL | |

---

### cashbook_entries

Auto-populated. Never manually inserted or edited by users.

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| entry_type | VARCHAR | "receipt", "expense", "deposit", "void_reversal" |
| reference_id | INTEGER | ID of the source record |
| reference_table | VARCHAR | "payments", "expenses", "bank_deposits" |
| description | VARCHAR | Auto-generated description |
| debit | DECIMAL | Money in |
| credit | DECIMAL | Money out |
| balance | DECIMAL | Running balance after this entry |
| entry_date | DATE | |
| created_at | DATETIME | Auto |

---

### bank_accounts

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| bank_name | VARCHAR | |
| account_name | VARCHAR | |
| account_number | VARCHAR | |
| is_active | BOOLEAN | |
| created_at | DATETIME | Auto |

---

### bank_deposits

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| bank_account_id | INTEGER | FK to bank_accounts |
| amount | DECIMAL | |
| deposit_date | DATE | |
| reference | VARCHAR | Bank deposit slip reference |
| deposited_by | INTEGER | FK to users |
| notes | VARCHAR | Optional |
| created_at | DATETIME | Auto |

---

### expense_categories

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| name | VARCHAR | e.g. "Utilities", "Stationery", "Salaries" |
| is_active | BOOLEAN | |
| created_at | DATETIME | Auto |

---

### expenses

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| term_id | INTEGER | FK to terms |
| category_id | INTEGER | FK to expense_categories |
| description | VARCHAR | |
| amount | DECIMAL | |
| payee | VARCHAR | Who is being paid |
| document_reference | VARCHAR | Supporting document reference |
| status | VARCHAR | "draft", "pending_approval", "approved", "paid", "rejected" |
| initiated_by | INTEGER | FK to users |
| initiated_at | DATETIME | |
| approved_by | INTEGER | FK to users, nullable |
| approved_at | DATETIME | Nullable |
| rejected_by | INTEGER | FK to users, nullable |
| rejected_at | DATETIME | Nullable |
| rejection_reason | VARCHAR | Required if rejected |
| paid_at | DATETIME | When payment was made |
| created_at | DATETIME | Auto |
| updated_at | DATETIME | Auto |

---

### users

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| username | VARCHAR | Unique |
| full_name | VARCHAR | |
| hashed_password | VARCHAR | bcrypt hashed |
| role | VARCHAR | "super_admin", "headteacher", "bursar", "data_entry" |
| is_active | BOOLEAN | |
| created_by | INTEGER | FK to users |
| created_at | DATETIME | Auto |
| last_login | DATETIME | |

---

### audit_log

Append-only. No updates, no deletes, ever.

| Column | Type | Notes |
|---|---|---|
| id | INTEGER | Primary key |
| user_id | INTEGER | FK to users |
| username_snapshot | VARCHAR | Username at time of action, in case user is deleted |
| action | VARCHAR | e.g. "CREATE", "UPDATE", "DELETE", "VOID", "LOGIN" |
| table_name | VARCHAR | Which table was affected |
| record_id | INTEGER | Which record was affected |
| old_value | JSON | State before change, null for creates |
| new_value | JSON | State after change, null for deletes |
| ip_address | VARCHAR | Loopback only — for local session tracking |
| timestamp | DATETIME | Auto, indexed |

---

## API Routes

All routes are prefixed with `/api/v1/`.

---

### Institution
| Method | Route | Description |
|---|---|---|
| GET | `/institution` | Get institution details |
| POST | `/institution/setup` | First-run setup |
| PUT | `/institution` | Update institution details |

### Academic Structure
| Method | Route | Description |
|---|---|---|
| GET | `/academic-years` | List all academic years |
| POST | `/academic-years` | Create academic year |
| GET | `/terms` | List terms, filter by year |
| POST | `/terms` | Create term |
| PUT | `/terms/{id}/open` | Open a term |
| PUT | `/terms/{id}/close` | Close a term |
| PUT | `/terms/{id}/freeze` | Freeze a term |
| GET | `/classes` | List classes, filter by year |
| POST | `/classes` | Create class |
| PUT | `/classes/{id}` | Update class |

### Students
| Method | Route | Description |
|---|---|---|
| GET | `/students` | List students, filter by class/status |
| POST | `/students` | Create student |
| GET | `/students/{id}` | Get one student |
| PUT | `/students/{id}` | Update student |
| PUT | `/students/{id}/status` | Change enrollment status |
| POST | `/students/import` | Import from Excel |

### Fee Management
| Method | Route | Description |
|---|---|---|
| GET | `/fee-categories` | List fee categories |
| POST | `/fee-categories` | Create fee category |
| PUT | `/fee-categories/{id}` | Update fee category |
| GET | `/fee-structures` | List fee structures, filter by class/term |
| POST | `/fee-structures` | Create fee structure |
| PUT | `/fee-structures/{id}` | Update fee structure |
| GET | `/students/{id}/adjustments` | Get adjustments for a student |
| POST | `/students/{id}/adjustments` | Add adjustment |
| DELETE | `/students/{id}/adjustments/{adj_id}` | Remove adjustment |

### Payments
| Method | Route | Description |
|---|---|---|
| GET | `/payments` | List payments, filter by student/term/date |
| POST | `/payments` | Record a payment |
| GET | `/payments/{id}` | Get one payment |
| PUT | `/payments/{id}/void` | Void a payment (bursar only, reason required) |
| GET | `/payments/receipt/{receipt_number}` | Lookup by receipt number |
| GET | `/students/{id}/balance` | Get student balance breakdown |
| GET | `/students/{id}/payment-history` | Full payment history |

### Payment Plans
| Method | Route | Description |
|---|---|---|
| GET | `/students/{id}/payment-plans` | Get plans for a student |
| POST | `/students/{id}/payment-plans` | Create payment plan |
| PUT | `/payment-plans/{id}` | Update plan |

### Cashbook
| Method | Route | Description |
|---|---|---|
| GET | `/cashbook` | List entries, filter by date range |
| GET | `/cashbook/balance` | Current running balance |

### Banking
| Method | Route | Description |
|---|---|---|
| GET | `/bank-accounts` | List bank accounts |
| POST | `/bank-accounts` | Add bank account |
| GET | `/bank-deposits` | List deposits |
| POST | `/bank-deposits` | Record a deposit |

### Expenses
| Method | Route | Description |
|---|---|---|
| GET | `/expense-categories` | List categories |
| POST | `/expense-categories` | Create category |
| GET | `/expenses` | List expenses, filter by status/term |
| POST | `/expenses` | Initiate expense |
| GET | `/expenses/{id}` | Get one expense |
| PUT | `/expenses/{id}/submit` | Submit for approval |
| PUT | `/expenses/{id}/approve` | Approve expense |
| PUT | `/expenses/{id}/reject` | Reject expense |
| PUT | `/expenses/{id}/mark-paid` | Mark as paid |

### Reports
| Method | Route | Description |
|---|---|---|
| GET | `/reports/daily-collection` | Daily collection report |
| GET | `/reports/fee-balances` | Fee balance report |
| GET | `/reports/student-statement/{id}` | Student statement |
| GET | `/reports/cashbook` | Cashbook report |
| GET | `/reports/income-expenditure` | Income vs expenditure |
| GET | `/reports/term-summary` | Term financial summary |
| GET | `/reports/outstanding-fees` | Outstanding fees list |

All report endpoints accept `?format=pdf` to return a PDF file instead of JSON.

### Users
| Method | Route | Description |
|---|---|---|
| POST | `/auth/login` | Login, returns session token |
| POST | `/auth/logout` | Logout |
| GET | `/users` | List users (super admin only) |
| POST | `/users` | Create user |
| PUT | `/users/{id}` | Update user |
| PUT | `/users/{id}/deactivate` | Deactivate user |

### Audit
| Method | Route | Description |
|---|---|---|
| GET | `/audit-log` | List audit entries, filter by user/date/table |

---

## Data Flow — How the Pieces Connect

```
Institution Setup (one time)
        |
Academic Year created
        |
Term opened → receipt counter initialized at 0001
        |
Classes created → linked to academic year
        |
Students enrolled → linked to class
        |
Fee Categories defined (user-defined)
        |
Fee Structures set → class + term + category + amount
        |
Optional: Payment Plans per student per term
Optional: Fee Adjustments per student (bursary/discount)
        |
Bursar opens Payment Collection
        |
Payment recorded → receipt number generated (YYYY/T#/NNNN)
        |
Payment Allocations created → splits amount across fee categories
        |
Cashbook Entry auto-created (debit)
        |
Receipt PDF generated and printed
        |
Bank Deposit recorded → Cashbook Entry auto-created
        |
Expense initiated → submitted → approved → paid
        |
Expense Cashbook Entry auto-created (credit)
        |
Reports generated from cashbook + payments + expenses
        |
Term closed → balances frozen → carry-forward calculated
        |
Every action above → Audit Log entry written
```

---

## Rules You Must Never Break in Code

These are not suggestions. They are enforced by the business logic.

- Receipt numbers are never reused. Never editable. Generated atomically.
- Cashbook entries are never manually created, updated, or deleted. They are always the result of another action.
- The audit log is append-only. No service ever updates or deletes an audit entry.
- Voided payments remain in the database. They appear in the cashbook as reversal entries.
- Closing a term freezes all its transactions. No payments or expenses can be recorded against a frozen or closed term.
- A student soft-deleted (status changed) is never hard-deleted. Their history is permanent.
- Passwords are always stored hashed. Never plain text. Never logged.

---

*Architecture maintained by A-Von Computer Solutions. Subject to revision as the project evolves.*

