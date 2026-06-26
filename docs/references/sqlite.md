# SQLite Reference

## Why SQLite

SQLite is the simplest local database option for a desktop application.
It requires no server and stores data in a single file.

## Best practices

- Keep the schema simple.
- Use explicit column names.
- Avoid complex joins for core workflows.
- Use transactions for financial operations.

## Maintenance

- Store the database file in a predictable local path.
- Back it up before applying schema changes.
- Use Alembic or simple migration scripts for schema updates.
