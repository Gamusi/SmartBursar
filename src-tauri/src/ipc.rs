// IPC handler module for Python sidecar communication

use serde_json::{json, Value};

#[tauri::command]
pub fn ipc_call(method: String, params: Value) -> Result<Value, String> {
    // Echo back for testing during Day 1
    Ok(json!({
        "success": true,
        "method": method,
        "params": params
    }))
}
