@echo off
setlocal enabledelayedexpansion

:: SmartBursar Build Script
:: Interactive menu for development, building, and testing

set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

:main_menu
cls
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║           SmartBursar Build & Development Menu          ║
echo ╚════════════════════════════════════════════════════════╝
echo.
echo 1. Check Prerequisites
echo 2. Install Dependencies
echo 3. Start Development Server (bun tauri dev)
echo 4. Build Production App
echo 5. Run Backend Tests
echo 6. Run Frontend Linter
echo 7. Clean Build Artifacts
echo 8. Database: Create Migration
echo 9. Database: Run Migrations
echo 10. Reset Everything ^(Clean + Reinstall^)
echo 11. View IPC Status Page
echo 0. Exit
echo.
set /p "choice=Select an option (0-11): "

if "%choice%"=="0" goto end
if "%choice%"=="1" goto check_prerequisites
if "%choice%"=="2" goto install_deps
if "%choice%"=="3" goto dev_server
if "%choice%"=="4" goto build_prod
if "%choice%"=="5" goto run_tests
if "%choice%"=="6" goto run_linter
if "%choice%"=="7" goto clean_build
if "%choice%"=="8" goto create_migration
if "%choice%"=="9" goto run_migrations
if "%choice%"=="10" goto reset_all
if "%choice%"=="11" goto status_page
echo Invalid option. Retrying...
timeout /t 2 >nul
goto main_menu

:check_prerequisites
cls
echo.
echo [*] Checking Prerequisites...
echo.

set "all_ok=1"

:: Check Node.js/Bun
echo Checking Node.js...
where node >nul 2>&1
if errorlevel 1 (
    echo [X] Node.js NOT found. Install from https://nodejs.org/
    set "all_ok=0"
) else (
    for /f "tokens=*" %%i in ('node --version 2^>nul') do set "node_ver=%%i"
    echo [OK] Node.js !node_ver! found
)

echo.
echo Checking Bun...
where bun >nul 2>&1
if errorlevel 1 (
    echo [X] Bun NOT found. Install with: npm install -g bun
    set "all_ok=0"
) else (
    for /f "tokens=*" %%i in ('bun --version 2^>nul') do set "bun_ver=%%i"
    echo [OK] Bun !bun_ver! found
)

echo.
echo Checking Python 3.11+...
where python >nul 2>&1
if errorlevel 1 (
    echo [X] Python NOT found. Install from https://www.python.org/
    set "all_ok=0"
) else (
    for /f "tokens=*" %%i in ('python --version 2^>nul') do set "py_ver=%%i"
    echo [OK] !py_ver! found
)

echo.
echo Checking Rust...
where rustc >nul 2>&1
if errorlevel 1 (
    echo [X] Rust NOT found. Install from https://rustup.rs/
    set "all_ok=0"
) else (
    for /f "tokens=*" %%i in ('rustc --version 2^>nul') do set "rust_ver=%%i"
    echo [OK] !rust_ver! found
)

echo.
echo Checking Tauri CLI...
where tauri >nul 2>&1
if errorlevel 1 (
    echo [X] Tauri CLI NOT found. Install with: bun install -g @tauri-apps/cli
    set "all_ok=0"
) else (
    echo [OK] Tauri CLI found
)

echo.
if "!all_ok!"=="1" (
    echo [SUCCESS] All prerequisites are installed!
) else (
    echo [WARNING] Some prerequisites are missing. Please install them before proceeding.
)

echo.
pause
goto main_menu

:install_deps
cls
echo.
echo [*] Installing Dependencies...
echo.

echo [1/3] Installing Python packages...
cd /d "%SCRIPT_DIR%backend"
if exist "requirements.txt" (
    python -m pip install --upgrade pip >nul 2>&1
    python -m pip install -r requirements.txt
    if errorlevel 1 (
        echo [X] Failed to install Python requirements
        pause
        goto main_menu
    )
    echo [OK] Python packages installed
) else (
    echo [X] requirements.txt not found
    pause
    goto main_menu
)

echo.
echo [2/3] Installing frontend dependencies with Bun...
cd /d "%SCRIPT_DIR%frontend"
call bun install
if errorlevel 1 (
    echo [X] Failed to install frontend dependencies
    pause
    goto main_menu
)
echo [OK] Frontend dependencies installed

echo.
echo [3/3] Installing Tauri CLI...
call bun install -g @tauri-apps/cli@latest >nul 2>&1
echo [OK] Tauri CLI ready

echo.
echo [SUCCESS] All dependencies installed!
echo.
pause
goto main_menu

:dev_server
cls
echo.
echo [*] Starting Development Server...
echo.
echo Opening Tauri dev window with live reload...
echo(
echo To test the app:
echo   1. Wait for the Tauri window to open
echo   2. Navigate to Settings / Status page to test IPC connectivity
echo   3. You should see "Connected" if Python sidecar is running
echo   4. Edit frontend code to test live reload
echo.
timeout /t 3 >nul

cd /d "%SCRIPT_DIR%frontend"
call bun tauri dev

goto main_menu

:build_prod
cls
echo.
echo [*] Building Production App...
echo.
echo This may take a few minutes. Building...
echo.

cd /d "%SCRIPT_DIR%frontend"
call bun tauri build

if errorlevel 1 (
    echo [X] Build failed
    pause
    goto main_menu
)

echo.
echo [SUCCESS] Production build complete!
echo Installer available at: frontend\src-tauri\target\release\bundle\
echo.
pause
goto main_menu

:run_tests
cls
echo.
echo [*] Running Backend Tests...
echo.

cd /d "%SCRIPT_DIR%backend"
python -m pytest tests/ -v

if errorlevel 1 (
    echo.
    echo [X] Some tests failed
) else (
    echo.
    echo [SUCCESS] All tests passed!
)

echo.
pause
goto main_menu

:run_linter
cls
echo.
echo [*] Running Frontend Linter...
echo.

cd /d "%SCRIPT_DIR%frontend"
call bun run lint

echo.
pause
goto main_menu

:clean_build
cls
echo.
echo [*] Cleaning Build Artifacts...
echo.

echo Removing frontend node_modules...
cd /d "%SCRIPT_DIR%frontend"
if exist "node_modules" (
    rmdir /s /q node_modules
    echo [OK] Removed frontend/node_modules
)

echo Removing Tauri build cache...
if exist "src-tauri\target" (
    rmdir /s /q src-tauri\target
    echo [OK] Removed frontend/src-tauri/target
)

echo Removing Python cache...
cd /d "%SCRIPT_DIR%backend"
for /d /r . %%d in (__pycache__) do (
    if exist "%%d" rmdir /s /q "%%d"
)
if exist ".pytest_cache" (
    rmdir /s /q .pytest_cache
    echo [OK] Removed Python cache
)

echo.
echo [SUCCESS] Build artifacts cleaned!
echo.
pause
goto main_menu

:create_migration
cls
echo.
echo [*] Creating Database Migration...
echo.

cd /d "%SCRIPT_DIR%backend"

if not exist "migrations" (
    echo [*] Initializing migrations directory...
    python -m alembic init migrations
)

set /p "migration_name=Enter migration name (e.g., add_students_table): "

if "%migration_name%"=="" (
    echo [X] Cancelled - no name provided
    pause
    goto main_menu
)

python -m alembic revision --autogenerate -m "%migration_name%"

if errorlevel 1 (
    echo [X] Failed to create migration
) else (
    echo [SUCCESS] Migration created! Edit the file in backend\migrations\versions\
)

echo.
pause
goto main_menu

:run_migrations
cls
echo.
echo [*] Running Database Migrations...
echo.

cd /d "%SCRIPT_DIR%backend"

if not exist "migrations" (
    echo [X] Migrations directory not found
    pause
    goto main_menu
)

python -m alembic upgrade head

if errorlevel 1 (
    echo [X] Migrations failed
) else (
    echo [SUCCESS] Database schema updated!
)

echo.
pause
goto main_menu

:reset_all
cls
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║           [WARNING] RESET EVERYTHING?                  ║
echo ║  This will delete node_modules, build cache, and .venv ║
echo ║  You will need to reinstall all dependencies.          ║
echo ╚════════════════════════════════════════════════════════╝
echo.

set /p "confirm=Type 'yes' to confirm reset: "

if /i not "%confirm%"=="yes" (
    echo Cancelled.
    timeout /t 2 >nul
    goto main_menu
)

echo.
echo [*] Cleaning everything...
call :clean_build

echo.
echo Removing Python virtual environment (if exists)...
if exist "%SCRIPT_DIR%backend\.venv" (
    rmdir /s /q "%SCRIPT_DIR%backend\.venv"
    echo [OK] Removed .venv
)

echo.
echo [*] Reinstalling all dependencies...
timeout /t 2 >nul
call :install_deps

echo.
echo [SUCCESS] Reset complete! Ready to develop.
echo.
pause
goto main_menu

:status_page
cls
echo.
echo [*] Opening Status Page...
echo.
echo The Status page tests IPC connectivity to the Python sidecar.
echo Navigate to it when the Tauri dev server is running.
echo.
echo Local development URL: http://localhost:5173/status
echo(
echo Make sure you've already run "Start Development Server" from the main menu.
echo.
pause
goto main_menu

:end
cls
echo.
echo Goodbye!
echo.
endlocal
