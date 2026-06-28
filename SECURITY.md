# SmartBursar Security Architecture & Controls

As an offline-first school financial management system, SmartBursar is built with a defense-in-depth approach. Because this software manages actual school funds, auditability, data integrity, and strict access controls are core requirements.

---

## 1. Authentication & Password Security

- **Hashing Algorithm**: All user passwords must be hashed using **bcrypt** with a work factor (salt rounds) of at least 12. Plaintext passwords must never be stored, logged, or returned in any API response.
- **Session Management**: Session authentication is handled locally. Inactive sessions are set to auto-expire after 30 minutes of inactivity to prevent unauthorized access on shared school computers.
- **Credential Storage**: Database credentials and IPC keys are injected as environment variables at startup and kept in memory only.

---

## 2. Role-Based Access Control (RBAC)

The system enforces strict segregation of duties through four predefined roles:

| Feature/Action | Data Entry | Bursar | Headteacher | Super Admin |
|---|:---:|:---:|:---:|:---:|
| **View Dashboards & Reports** | Read-Only | Read-Only | Read-Only | Read-Only |
| **Manage Student Registry** | Create/Update | Create/Update | Create/Update | Create/Update |
| **Record Fee Payments (Receipts)** | Create | Create | Create | Create |
| **Void Payments (Reversals)** | ❌ | ❌ | Approve | Approve |
| **Initiate Expenses / Payroll** | Create | Create | Create | Create |
| **Approve Expenses / Payroll** | ❌ | ❌ | Approve | Approve |
| **Mark Expenses/Payroll Paid** | ❌ | Mark Paid | ❌ | ❌ |
| **Define Fee Structures & Terms** | ❌ | ❌ | Create/Update | Create/Update |
| **Manage Users & Settings** | ❌ | ❌ | ❌ | Create/Update |
| **Backup & Restore Database** | ❌ | ❌ | Initiate | Initiate |

### Key Controls:
- **Approval Segregation**: The role that *initiates* a payment or expense cannot unilaterally *approve* or *mark it as paid*. At least two distinct actions are required for cash outflows.
- **Voiding Constraints**: Only `headteacher` and `super_admin` can void a payment, which automatically generates a matching reversal entry in the cashbook.

---

## 3. Data Integrity & Financial Controls

- **Sacred Receipt Numbers**: Receipt numbers follow the pattern `YYYY/T#/NNNN` (e.g., `2026/T1/0432`). They are generated atomically using database transactions. They can never be reused, edited, or deleted.
- **Automatic Cashbook Logs**: The `cashbook_entries` table is read-only for all users and services. Entries are automatically created via database triggers or transaction service layers upon payment, expense payment, or bank deposit events.
- **Audit Trails**: Every write operation (Insert, Update, Soft-Delete) must write a record to the `audit_log` table. The log captures:
  - Timestamp (UTC)
  - User ID and username snapshot (protecting audit history if the user record is modified)
  - Table name and action type (CREATE/UPDATE/VOID)
  - Exact JSON snapshots of the `old_value` and `new_value` for complete traceability.
  - The audit log is strictly **append-only**.
- **Immutable Term Locks**: Closing or freezing an academic term locks all related records. No payments, expenses, adjustments, or payroll allocations can be posted against a closed or frozen term.

---

## 4. Database & Storage Security

- **Local Database Encryption**: The local SQLite database is encrypted at rest using **SQLCipher** (AES-256). The encryption key is derived dynamically using a combination of system-level identifiers and host keys, ensuring the database file cannot be read if copied to another machine.
- **Secure Backups**: Database backups are compressed and encrypted using a secondary public/private key pair. Encrypted backup files can be saved to USB drives or local network locations.
- **Local File Security**: The Tauri desktop shell restricts database file access to the specific OS-level user running the application, utilizing OS-native directory access controls (`%APPDATA%` on Windows).

---

## 5. IPC (Inter-Process Communication) Security

SmartBursar runs React inside a Tauri webview that communicates with a local Python sidecar process.
- **Standard Input/Output Pipes**: Communication is constrained to OS pipes (`stdin`/`stdout`). No local TCP ports, web sockets, or HTTP listeners are exposed on the host machine, eliminating network-based side-channel attacks and local firewall prompts.
- **JSON-RPC Schema Validation**: The Rust-based Tauri host and the Python sidecar validate all messages against strict JSON schemas before execution. Any malformed or unauthorized commands are rejected immediately.

---

## 6. Host & Environment Recommendations

Since the application is designed for offline deployment in schools, physical security of the host machine is critical:
- **BitLocker / OS Encryption**: School proprietors are strongly recommended to enable Windows BitLocker or equivalent OS-level drive encryption to protect database files in case of computer theft.
- **Device Lock Policies**: The host machine should be configured to lock the screen after 5 minutes of idle time.
- **Antivirus & OS Patches**: Maintain active Windows Defender or similar protection and install security updates to secure the runtime environment.
