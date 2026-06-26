// SmartBursar Tauri Runtime
// Manages the Python IPC sidecar and provides Tauri commands for the frontend

#![cfg_attr(
  all(not(debug_assertions), target_os = "windows"),
  windows_subsystem = "windows"
)]

use serde_json::{json, Value};
use std::io::{BufRead, BufReader, Write};
use std::process::{Child, Command, Stdio};
use std::sync::Mutex;
use tauri::State;
use std::path::PathBuf;

struct SidecarState {
    process: Mutex<Option<Child>>,
    stdin: Mutex<Option<std::process::ChildStdin>>,
    stdout: Mutex<Option<BufReader<std::process::ChildStdout>>>,
}

impl Default for SidecarState {
    fn default() -> Self {
        Self {
            process: Mutex::new(None),
            stdin: Mutex::new(None),
            stdout: Mutex::new(None),
        }
    }
}

/// Start the Python sidecar process
fn start_sidecar() -> Result<(Child, std::process::ChildStdin, BufReader<std::process::ChildStdout>), String> {
    // Find Python executable (sidecar.py assumes it's in the app bundle or PATH)
    let python_exe = if cfg!(windows) {
        "python.exe"
    } else {
        "python3"
    };

    // Spawn the sidecar
    let mut child = Command::new(python_exe)
        .arg("backend/sidecar.py")
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .map_err(|e| format!("Failed to spawn sidecar: {}", e))?;

    let stdin = child.stdin.take().ok_or("Failed to open sidecar stdin")?;
    let stdout = child.stdout.take().ok_or("Failed to open sidecar stdout")?;
    let reader = BufReader::new(stdout);

    Ok((child, stdin, reader))
}

/// Send an IPC request to the sidecar and wait for response
#[tauri::command]
fn ipc_call(
    method: String,
    params: Value,
    state: State<'_, SidecarState>,
) -> Result<Value, String> {
    // TODO: In production, this should use a proper channel and reader thread
    // For Day 1, we'll keep it simple and synchronous
    
    let request = json!({
        "jsonrpc": "2.0",
        "id": 1,
        "method": method,
        "params": params
    });

    // Send request (placeholder for now)
    // println!("IPC Request: {}", request);
    
    // Echo back for testing
    Ok(json!({
        "success": true,
        "request": request
    }))
}

fn main() {
    tauri::Builder::default()
        .manage(SidecarState::default())
        .invoke_handler(tauri::generate_handler![ipc_call])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
