# SmartBursar Developer Roadmap

This roadmap is a practical implementation plan for one developer. It is written for product delivery first, with learning happening naturally through building.

## Core philosophy

- Product first: build the features a school needs, not the features that demonstrate a concept.
- Learn while building: preserve decisions and architecture without turning development into coursework.
- Simplicity wins: prefer the simplest solution that clearly solves the current problem.

## How to use this roadmap

- Read it before starting a new area of work.
- Use it to decide what is worth building next.
- Use it to keep the product focused and avoid scope creep.
- Update it when priorities change or new requirements appear.

## Phase 1 — Core MVP

Goal: create a working finance workflow with real persistence and a usable frontend.

Deliverables:
- student registry CRUD
- payment collection with receipt generation
- expense recording
- cashbook persistence in SQLite
- a minimal dashboard and navigation
- simple role guard if needed
- tests for core business rules

Why it matters:
- this is the feature set that makes the app useful for daily school work.
- it establishes the core data model and the main user flow.

## Phase 2 — Cashbook and reports

Goal: make the system useful for routine financial operations.

Deliverables:
- automatic cashbook entry creation from payments and expenses
- daily collections report
- student balance statement
- term summary report
- PDF export for receipts and reports

Why it matters:
- these are the features that turn raw transactions into actionable finance information.
- reporting is the value that proves the app saves time and reduces errors.

## Phase 3 — Offline polish

Goal: make the app reliable and usable in the target environment.

Deliverables:
- encrypted local backup and restore
- Excel import for student data
- validation and user-friendly errors
- performance tuning for low-spec Windows machines
- stable data migration strategy

Why it matters:
- schools need the app to be dependable, not just functional.
- this phase reduces real-world friction and protects data.

## Phase 4 — Packaging and release

Goal: deliver a native desktop build and deployment notes.

Deliverables:
- Tauri packaging for Windows (primary target)
- simple install/run instructions
- release notes for the first usable version
- recommended QA checklist

Why it matters:
- users need an easy way to run the app.
- packaging converts the product from prototype into deployable software.

## Phase 5 — Maintainable growth

Goal: keep the product small, clear, and stable.

Deliverables:
- document important decisions in `docs/product/decisions.md`
- keep the data model and API surface minimal
- add tests for business behavior only
- refactor only when it improves clarity or reliability

Why it matters:
- a single developer should be able to maintain and extend the product.
- the product remains useful rather than becoming an experimental platform.

## Daily development habits

Before code:
- define the problem clearly
- confirm the user need
- choose the simplest possible approach

After code:
- ask whether the change is still easy to understand after six months
- document any assumptions or trade-offs
- add a focused test for the business rule
- verify the user flow manually

## What to avoid

- building features just because they are interesting
- adding abstractions before they are needed
- duplicating complexity in backend and frontend
- leaving critical business rules undocumented
