# SmartBursar Engineering Roadmap

This roadmap outlines the implementation plan and key milestones for the development team. It is structured to prioritize product delivery, maintaining architectural integrity and focus across all phases.

## Core Philosophy

- **Product first**: Focus on high-priority features that solve operational needs for schools.
- **Incremental validation**: Ensure design decisions and architecture are validated through practical implementation.
- **Simplicity wins**: Prefer simple, robust solutions that keep the system maintainable.

## How to Use This Roadmap

- Review the target objectives before starting a new area of work.
- Use the milestones to coordinate work and prioritize tasks.
- Keep the application focused on the current phase to prevent scope creep.

---

## Phase 1 — Core MVP

Goal: Create a working finance workflow with real persistence and a usable frontend.

Deliverables:
- Student registry CRUD
- Payment collection with receipt generation
- Expense recording
- Cashbook persistence in SQLite
- A minimal dashboard and navigation
- Simple role guard if needed
- Tests for core business rules

Why it matters:
- This is the feature set that makes the app useful for daily school work.
- It establishes the core data model and the main user flow.

---

## Phase 2 — Cashbook and Reports

Goal: Make the system useful for routine financial operations.

Deliverables:
- Automatic cashbook entry creation from payments and expenses
- Daily collections report
- Student balance statement
- Term summary report
- PDF export for receipts and reports

Why it matters:
- These are the features that turn raw transactions into actionable finance information.
- Reporting is the value that proves the app saves time and reduces errors.

---

## Phase 3 — Offline Polish

Goal: Make the app reliable and usable in the target environment.

Deliverables:
- Encrypted local backup and restore
- Excel import for student data
- Validation and user-friendly errors
- Performance tuning for low-spec Windows machines
- Stable data migration strategy

Why it matters:
- Schools need the app to be dependable, not just functional.
- This phase reduces real-world friction and protects data.

---

## Phase 4 — Packaging and Release

Goal: Deliver a native desktop build and deployment notes.

Deliverables:
- Tauri packaging for Windows (primary target)
- Simple install/run instructions
- Release notes for the first usable version
- Recommended QA checklist

Why it matters:
- Users need an easy way to run the app.
- Packaging converts the product from prototype into deployable software.

---

## Phase 5 — Maintainable Growth

Goal: Keep the product small, clear, and stable.

Deliverables:
- Document important decisions in `docs/product/decisions.md`
- Keep the data model and API surface minimal
- Add tests for business behavior only
- Refactor only when it improves clarity or reliability

Why it matters:
- The development team should be able to maintain and extend the product efficiently.
- The product remains useful rather than becoming an experimental platform.

---

## Development Guidelines

### Before coding:
- Define the problem clearly.
- Confirm the user/business need.
- Choose the simplest possible approach.

### After coding:
- Verify whether the change is still easy to understand and maintain.
- Document any assumptions or trade-offs.
- Add a focused test for the business rule.
- Verify the user flow manually.

---

## Key Pitfalls to Avoid

- Building features before they are explicitly needed.
- Adding abstractions prematurely.
- Duplicating complexity in backend and frontend.
- Leaving critical business rules undocumented.
