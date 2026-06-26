# Backend Database Guide

## Storage choice

SmartBursar uses SQLite because it is simple, local, and reliable for desktop apps.

## Core tables

- `students`
- `payments`
- `expenses`
- `terms`
- `cashbook_entries`
- `users` (if auth is required)

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
