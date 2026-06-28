# Backend Database Guide

## Storage choice

SmartBursar uses SQLite because it is simple, local, and reliable for desktop apps.

## Core tables

The system schema consists of the following key tables:
- `institution` (School configuration and profile)
- `academic_years` (Academic years lifecycle)
- `terms` (Academic terms lifecycle: open/closed/frozen statuses)
- `classes` (Class streams and levels)
- `students` (Student enrollment and profiles)
- `fee_structures` (Billed fees per class/term/category)
- `payments` (Receipted payment transactions)
- `payment_plans` (Student installment and balance tracking)
- `cashbook_entries` (Auto-generated finance ledger records)
- `expenses` (Expenditure vouchers and workflow states)
- `staff` (Staff profiles and baseline salaries)
- `staff_payments` (Monthly payroll disbursements)
- `users` (System users and role-based permissions)
- `audit_log` (Append-only action audit trail)

## Principles

- Keep the schema simple and stable.
- Use explicit primary keys.
- Avoid overly broad relationships unless the business needs them.
- Prefer clear column names over clever shorthand.

## Migrations

- Use Alembic for schema evolution.
- Keep each migration small and focused.
- Document why a migration exists.

## Data integrity

- Enforce required fields at the schema level.
- Keep business logic in the application layer, not in complex database triggers.
- Use transactions for payment and cashbook workflows.
