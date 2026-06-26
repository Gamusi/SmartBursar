<div align="center">

# SmartBursar

**Offline-first financial management desktop app for Ugandan schools**

[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](CHANGELOG.md)
[![Status](https://img.shields.io/badge/status-planning-orange.svg)]()
[![License](https://img.shields.io/badge/license-Proprietary-red.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey.svg)]()
[![Built with Tauri](https://img.shields.io/badge/built%20with-Tauri-blue.svg)](https://tauri.app)
[![Python](https://img.shields.io/badge/python-3.11%2B-blue.svg)](https://python.org)

[Overview](#overview) • [Features](#features) • [Tech Stack](#tech-stack) • [Getting Started](#getting-started) • [Project Structure](#project-structure) • [Contributing](#contributing) • [License](#license)

</div>

---

## Overview

**SmartBursar** is a proprietary offline-first desktop application designed to streamline financial management for Ugandan educational institutions. Built for bursars, headteachers, and school proprietors, it replaces manual cashbooks and spreadsheets with a secure, auditable, and printable financial system.

---

## Features

- Student registry with class and term enrollment
- User-defined fee structures per class per term
- Payment collection with official receipt generation (`YYYY/T#/NNNN`)
- Partial payments, payment plans, and fee adjustments (bursary/discounts)
- Automatic cashbook population from every transaction
- Expenditure management with approval workflow
- Bank deposit recording
- Financial reports: daily collections, fee balances, student statements, term summaries
- Term lifecycle management: open, close, freeze, carry-forward balances
- Role-based access control (Super Admin, Headteacher, Bursar, Data Entry)
- Full audit trail: every action logged with user, timestamp, old and new values
- A4 PDF printing: receipts, vouchers, reports
- Excel import for student data
- Encrypted local backup and restore
- 100% offline — no internet required

---

## System Requirements

The application is optimized for low-spec school computers to ensure smooth performance in all environments.

### Minimum Hardware
- **Processor:** Dual-core 2.0GHz or similar (Legacy Core 2 Duo era and above)
- **Memory:** 2GB RAM (4GB recommended)
- **Storage:** 500MB available space (HDD or SSD)
- **Display:** 1280x720 minimum resolution

### Platform Support
| Platform | Minimum Version | Notes |
|---|---|---|
| **Windows** | Windows 10 | WebView2 Runtime required (standard in Win 10+) |
| **Linux** | Modern Distro | WebKit2GTK required |
| **macOS** | High Sierra (10.13) | Support for older WebKit versions included |

---

## Tech Stack

### Backend

| Layer | Technology |
|---|---|
| Desktop Shell | Tauri |
| Backend | Python 3.11+ / FastAPI |
| Database | SQLite via SQLAlchemy |
| Migrations | Alembic |
| PDF Generation | ReportLab |
| Excel Import | openpyxl |
| IPC | Tauri sidecar (localhost FastAPI) |

### Frontend

| Layer | Technology | Purpose |
|---|---|---|
| Desktop Shell | Tauri | Native window, system tray, print dialog, file system access |
| UI Framework | React 18 | Component tree, state management |
| Build Tool | Vite | Fast dev server and production bundler |
| Styling | TailwindCSS | Utility-first styling |
| Routing | React Router v6 | Client-side navigation |
| State | Zustand | Lightweight global state (auth, active term, institution) |
| API Client | Axios | HTTP calls to FastAPI backend |
| Forms | React Hook Form | Form state and validation |
| Tables | TanStack Table | Sortable, filterable data tables |
| Date Handling | date-fns | Date formatting and arithmetic |
| PDF Trigger | Tauri shell API | Opens system print dialog on backend-generated PDFs |
| Icons | Lucide React | Consistent icon set |
| Notifications | React Hot Toast | Non-blocking feedback toasts |

**Shell architecture:** React runs inside the Tauri window. The Python FastAPI backend runs as a sidecar process connecting over a local loopback. Tauri handles OS-level operations; React handles all UI; Python handles all data and business logic.

---

## Getting Started

> Setup instructions will be added once the development scaffold is ready.

See [docs/product/requirements.md](docs/product/requirements.md) for full product specifications.

---
---

## Project Structure
```
smartbursar/
├── src-tauri/              # Tauri desktop shell (Rust)
├── frontend/               # React + TailwindCSS UI
│   └── src/
│       ├── main.jsx        # React entry point
│       ├── App.jsx         # Root component, router setup
│       ├── assets/         # Logos, images, fonts (bundled — no CDN)
│       ├── styles/         # Tailwind directives + CSS custom properties
│       ├── store/          # Zustand stores (auth, institution, term)
│       ├── hooks/          # useApi, useAuth, useTerm, usePrint
│       ├── api/            # One file per backend module (Axios calls)
│       ├── components/
│       │   ├── layout/     # AppShell, Sidebar, Topbar, PageHeader
│       │   ├── ui/         # Button, Input, Table, Modal, Badge, etc.
│       │   └── shared/     # StudentPicker, RoleGuard, PrintButton, etc.
│       └── pages/          # One folder per module (auth, dashboard, students…)
├── backend/                # Python FastAPI backend + SQLite
│   ├── app/
│   │   ├── api/            # Route handlers
│   │   ├── models/         # SQLAlchemy models
│   │   ├── schemas/        # Pydantic schemas
│   │   ├── services/       # Business logic
│   │   ├── reports/        # PDF generation
│   │   └── utils/          # Helpers
│   ├── migrations/         # Alembic migrations
│   └── tests/              # Backend tests
├── docs/                   # Product, developer, backend, frontend, and reference documentation
└── scripts/                # Build and utility scripts
```

---

## Design System

**Fonts (bundled, no CDN):** `Geist` (body text) · `Syne` (headings & display) · `JetBrains Mono` (receipt numbers, amounts, IDs)

**Theme:** Light and dark mode from day one via CSS custom properties (`[data-theme]`). OS preference respected on first launch; persisted via Tauri.

**Light palette:** `--color-primary: #1B4F72` · `--color-accent: #1A7A4A` · `--color-surface: #FFFFFF` · `--color-background: #F4F6F9`

**Dark palette:** `--color-primary: #2E86C1` · `--color-accent: #27AE60` · `--color-surface: #1A2235` · `--color-background: #0F1623`

---

## Modules (Phase 1)

| Module | Status |
|---|---|
| Institution Setup | Planned |
| Academic Structure | Planned |
| Student Registry | Planned |
| Fee Management | Planned |
| Payment Collection | Planned |
| Daily Collection Report | Planned |
| Cashbook | Planned |
| Banking | Planned |
| Expenditure Management | Planned |
| Financial Reports | Planned |
| Term Management | Planned |
| RBAC and User Management | Planned |
| Audit Trail | Planned |
| Backup and Restore | Planned |

---

## License

Proprietary software. All rights reserved.  
Copyright (c) 2025 A-Von Computer Solutions.  
Unauthorized copying, distribution, or modification is strictly prohibited.

