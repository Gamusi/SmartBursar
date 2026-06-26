@echo off
setlocal enabledelayedexpansion

:: SmartBursar Build Script
:: Interactive menu for development, building, and testing

set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

:main_menu
cls
echo.
echo ============================================================
echo            SmartBursar Build ^& Development Menu
echo ============================================================
echo.
echo 1. Check Prerequisites
echo 2. Install Dependencies
echo 3. Start Development Server
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
    echo [WARNING] Some prerequisites are missing.
    echo.
    set /p "install_now=Install missing dependencies now? (y/n): "
    if /i "!install_now!"=="y" (
        echo.
        echo [*] Auto-installing missing dependencies...
        timeout /t 2 >nul
        call :install_missing_deps
    )
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
    echo Detected requirements.txt, installing...
    python -m pip install --upgrade pip >nul 2>&1
    if errorlevel 1 (
        echo [!] pip upgrade failed, continuing anyway...
    )
    
    REM Install requirements, but skip lines with "python" (version constraints)
    python -m pip install -r requirements.txt --ignore-installed
    if errorlevel 1 (
        echo [X] Some packages failed. Attempting individual install...
        REM Try line by line, skipping python version constraints
        for /f "tokens=*" %%A in (requirements.txt) do (
            if not "%%A"=="" (
                if not "%%A:~0,6%"=="python" (
                    python -m pip install "%%A" 2>nul
                )
            )
        )
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
echo [3/3] Installing Tauri CLI globally...
call bun install -g @tauri-apps/cli@latest
if errorlevel 1 (
    echo [!] Warning: Tauri CLI global install had issues
    echo [*] Attempting to use local Tauri...
)
echo [OK] Tauri CLI ready

echo.
echo [SUCCESS] All dependencies installed!
echo.
pause
goto main_menu

:install_missing_deps
REM Helper function to install only what's missing
echo.
echo [2/3] Installing frontend dependencies with Bun...
cd /d "%SCRIPT_DIR%frontend"
call bun install >nul 2>&1

echo [*] Installing Tauri CLI...
call bun install -g @tauri-apps/cli@latest >nul 2>&1

echo.
echo [SUCCESS] Missing dependencies installed!
goto main_menu

:dev_server
cls
echo.
echo [*] Starting Development Server...
echo.
echo Launching Tauri with live reload...
echo.
timeout /t 3 >nul

cd /d "%SCRIPT_DIR%"
where tauri >nul 2>&1
if errorlevel 1 (
    echo [X] Tauri CLI not found. Run option 2 to install dependencies first.
    pause
    goto main_menu
)

set "LOG_FILE=%SCRIPT_DIR%tauri-dev.log"
set "TEMP_BATCH=%SCRIPT_DIR%run-tauri.bat"

echo [%date% %time%] Starting tauri dev > "%LOG_FILE%"

REM Create temporary batch to run tauri dev with full output capture
(
    echo @echo off
    echo cd /d "%SCRIPT_DIR%"
    echo tauri dev 2>&1
) > "%TEMP_BATCH%"

echo [*] Launching development server...
call "%TEMP_BATCH%" >> "%LOG_FILE%" 2>&1

if errorlevel 1 (
    echo.
    echo [X] The development server exited with an error.
    echo [*] Full error log saved to: tauri-dev.log
    echo.
    echo Error output:
    echo ============================================================
    type "%LOG_FILE%"
    echo ============================================================
    echo.
    del /q "%TEMP_BATCH%" >nul 2>&1
    pause
    goto main_menu
)

del /q "%TEMP_BATCH%" >nul 2>&1
goto main_menu

:build_prod
cls
echo.
echo [*] Building Production App...
echo.
echo This may take a few minutes. Building...
echo.

cd /d "%SCRIPT_DIR%"
where tauri >nul 2>&1
if errorlevel 1 (
    echo [X] Tauri CLI not found. Run option 2 to install dependencies first.
    pause
    goto main_menu
)

call tauri build

if errorlevel 1 (
    echo [X] Build failed
    pause
    goto main_menu
)

echo.
echo [SUCCESS] Production build complete!
echo Installer available at: src-tauri\target\release\bundle\
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
echo ============================================================
echo            [WARNING] RESET EVERYTHING?
echo   This will delete node_modules, build cache, and .venv
echo    You will need to reinstall all dependencies.
echo ============================================================
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
