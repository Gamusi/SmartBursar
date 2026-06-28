# SmartBursar Desktop: Roadmap

This roadmap is organized around product value and gradual delivery. It is not a training syllabus.

## Phase 1 — Core MVP

Goal: working school finance workflow with real persistence.

- student registry
- fee definition and term enrollment
- payment collection with receipts
- expense recording
- basic cashbook entry creation
- local SQLite persistence
- frontend pages for students, payments, expenses, dashboard

## Phase 2 — Cashbook and reports

Goal: make the system useful for daily school finance operations.

- automatic cashbook population
- daily collection report
- student balance statement
- term summary report
- PDF export for receipts and reports

## Phase 3 — Offline polish

Goal: make the app stable and usable in the target environment.

- local encrypted backup and restore
- Excel import for student data
- rounded validation and error handling
- performance checks on low-spec Windows machines

## Phase 4 — Desktop packaging

Goal: turn the app into a native desktop release.

- Tauri packaging for Windows first
- deployment and installation notes
- simple user maintenance workflow

## Phase 5 — Maintainable growth

Goal: keep the product simple and reliable.

- keep feature scope small
- preserve architectural knowledge in docs
- add tests for core business rules
- evolve only when the school needs it
