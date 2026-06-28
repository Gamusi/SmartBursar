# Backend Reports Guide

## Goal

Generate simple, useful reports for school finance operations.

## Reports to support

- Daily collections (receipts breakdown)
- Student balance statements (payment history ledgers)
- Term summaries (term-wide financial indicators)
- Cashbook export (running ledger of all cashflow)
- Monthly payroll (staff salary payments summary)
- Fee balances (all outstanding fees by class)
- Income vs expenditure statement (profit/loss)

## Output formats

- JSON for API consumption
- PDF for printing and sharing

## Design notes

- Keep report queries efficient.
- Calculate only what the user needs for the current view.
- Avoid overly large exports unless explicitly requested.

## PDF generation

- Use a minimal layout with clear headings and totals.
- Print as A4 by default.
- Keep report pages easy to read on paper.
