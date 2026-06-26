# Backend Reports Guide

## Goal

Generate simple, useful reports for school finance operations.

## Reports to support

- Daily collections
- Student balance statements
- Term summaries
- Cashbook export

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
