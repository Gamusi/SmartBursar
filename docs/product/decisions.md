# SmartBursar Decisions

This document records the architectural and product decisions that matter.

## Core philosophy

- Efficiently Functional Simplicity
- Every new addition must solve today's problem, remain understandable months later, and improve the user experience.
- Build the product first, then let learning happen naturally through implementation.

## Decision: no coursework language

The repository is a real product, not a training course.
All developer guidance is written for a practical one-developer workflow.

## Decision: offline-first, local SQLite

Schools must be able to use the app without reliable internet.
Local SQLite is the simplest persistent store for this product.

## Decision: simple APIs

Backend endpoints should be explicit and minimal.
Prefer a few clear REST routes over a large generic API surface.

## Decision: IPC-first runtime architecture

The primary runtime transport is stdin/stdout JSON-RPC over pipes.
This removes the need for a local HTTP server, ports, firewalls, and socket management.

## Decision: Python is the application engine

Python owns the business domain, persistence, validation, reporting, and background workers.
It is the single source of truth for school finance logic.

## Decision: Rust is the host

Rust manages the Python process, IPC, native OS integration, and event dispatch.
It does not contain school finance logic.

## Decision: React is presentation only

React renders the UI, collects input, and consumes typed IPC methods.
It does not implement business rules or access the database directly.

## Decision: keep FastAPI as an optional adapter

FastAPI may be used as a secondary transport adapter for development, testing, or future remote use.
Business services should be transport-agnostic so the same logic can be exposed over IPC or HTTP.

## Decision: event-driven background workers

Background jobs should notify the UI via events rather than polling.
This reduces SQLite contention and improves application responsiveness.

## Decision: documentation for future maintenance

Docs should explain why and how, not teach exercises.
Keep architecture notes, decision records, and implementation context.
