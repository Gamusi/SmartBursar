// SmartBursar Tauri Runtime
// Manages the Python IPC sidecar and provides Tauri commands for the frontend

#![cfg_attr(
  all(not(debug_assertions), target_os = "windows"),
  windows_subsystem = "windows"
)]

mod ipc;

use ipc::ipc_call;

fn main() {
  tauri::Builder::default()
    .invoke_handler(tauri::generate_handler![ipc_call])
    .run(tauri::generate_context!())
    .expect("error while running tauri application");
}
