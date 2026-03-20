@echo off
:: NOTE: This script is vibe coded via AI with minimal code review. Use with caution and review before production use.
setlocal enabledelayedexpansion

:: ============================================================
:: traktor-mod.bat — Install a QML overlay mod into Traktor Pro 4 (Windows)
::
:: Usage (double-click or run from Command Prompt):
::   traktor-mod.bat                                — merge mod on top of current live qml (stack mode)
::   traktor-mod.bat /fresh                        — restore stock first, then merge mod (clean mode)
::   traktor-mod.bat /symlink                      — symlink mod files into live qml (dev mode)
::   traktor-mod.bat /fresh /symlink               — restore stock first, then symlink mod files
::   traktor-mod.bat /full                         — replace entire qml with complete mod (full replacement)
::   traktor-mod.bat /full /symlink                — symlink complete mod (full replacement dev mode)
::   traktor-mod.bat /full /fresh                  — restore stock first, then replace entire qml
::   traktor-mod.bat /full /fresh /symlink         — restore stock, then symlink complete mod
::   traktor-mod.bat restore                       — restore stock qml and remove all mods/symlinks
::   traktor-mod.bat restore /pull                — fetch stock qml from GitHub (when backup is missing or to force a refresh)
::   traktor-mod.bat logger pull                   — download traktor-logger to local cache from GitHub
::   traktor-mod.bat logger pull /branch dev       — pull from specific branch
::   traktor-mod.bat logger pull /local C:\path   — copy from local directory
::   traktor-mod.bat logger install                — install Logger.qml and Api modules only
::   traktor-mod.bat server start                  — launch traktor-logger server on localhost:8080
::   traktor-mod.bat enable-metadata D2            — inject ApiModule into one controller file
::
:: Specifying source directory (optional; defaults to current directory):
::   traktor-mod.bat -s C:\path\to\mod             — use specific directory
::   traktor-mod.bat --source ..\my-mod            — use subdirectory, relative path
::   traktor-mod.bat -s C:\mods\mod /fresh         — use custom directory, fresh mode
::
:: Stack mode (default): copies overlay mod files into Traktor's live qml. Other installed mods stay.
:: Fresh mode (/fresh): resets qml to stock first, then applies only this mod.
:: Symlink mode (/symlink): creates symlinks in Traktor's qml pointing back to the files in this mod repo.
:: Full replacement mode (/full): replaces Traktor's entire qml with this complete mod.
:: Logger: Download, install Logger.qml and Api modules for debugging and monitoring.
:: Server: Launch the traktor-logger HTTP server for real-time dashboard monitoring.
:: Metadata: Enable automatic metadata collection from controllers (requires Api modules installed).
::
:: Syntax checking: Before updating this file, validate with blint to catch batch syntax issues:
::   python3 blint/blint.py traktor-mod.bat
:: See BATCH_FILE_FIXES_REPORT.md for details on blint findings and false positives.
::
:: ============================================================

:: Check for admin rights and re-launch elevated if needed, forwarding all args
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :admin_ok
) else (
    echo Requesting administrative privileges...
    goto :uac_prompt
)

:uac_prompt
    echo Set UAC = CreateObject("Shell.Application") > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~f0", "%*", "%CD%", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:admin_ok
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )

:: Check for help flag first
for %%A in (%*) do (
    if /I "%%A"=="/?" goto :showhelp
    if /I "%%A"=="-h" goto :showhelp
    if /I "%%A"=="--help" goto :showhelp
)

:: Detect Traktor path (try 64-bit, then 32-bit)
if exist "C:\Program Files\Native Instruments\Traktor Pro 4\Resources64\qml" (
    set "TRAKTOR_RESOURCES=C:\Program Files\Native Instruments\Traktor Pro 4\Resources64"
) else if exist "C:\Program Files\Native Instruments\Traktor Pro 4\Resources\qml" (
    set "TRAKTOR_RESOURCES=C:\Program Files\Native Instruments\Traktor Pro 4\Resources"
) else (
    set "TRAKTOR_RESOURCES=C:\Program Files\Native Instruments\Traktor Pro 4\Resources64"
)

set "TRAKTOR_QML=!TRAKTOR_RESOURCES!\qml"
set "TRAKTOR_QML_BACKUP=!TRAKTOR_RESOURCES!\qml.mod-backup"
set "TRAKTOR_APP=C:\Program Files\Native Instruments\Traktor Pro 4\Traktor Pro 4.exe"

:: Logger cache paths
set "LOGGER_CACHE_DIR=%USERPROFILE%\.traktor-mod\traktor-logger"
set "LOGGER_GITHUB_URL=https://raw.githubusercontent.com/lsmith77/traktor-logger/main"

:: --- initialize variables ---

set "SOURCE_DIR=."
set "MOD_QML=.\qml"
set "FRESH=false"
set "SYMLINK=false"
set "FULL=false"
set "WITH_LOGGER=false"
set "START_SERVER=false"
set "PULL_RESTORE=false"
set "MODE=install"
set "NEXT_IS_SOURCE=false"
set "ENABLE_METADATA="
set "BRANCH=main"
set "LOGGER_LOCAL_PATH="

:: --- parse arguments ---

:parse_args
if "%~1"=="" goto :end_parse_args

if "!NEXT_IS_SOURCE!"=="true" (
    if "%~1"=="" (
        echo Error: -s/--source requires a directory path to follow
        goto :end_error
    )
    set "NEXT_ARG=%~1"
    if "!NEXT_ARG:~0,1!"=="/" (
        echo Error: -s/--source requires a directory path, not a flag: %~1
        goto :end_error
    )
    if "!NEXT_ARG:~0,1!"=="-" (
        echo Error: -s/--source requires a directory path, not a flag: %~1
        goto :end_error
    )
    if not exist "%~1" (
        echo Error: Source directory not found: %~1
        goto :end_error
    )
    for /f "delims=" %%D in ('cd /d "%~1" 2^>nul ^&^& cd') do set "SOURCE_DIR=%%D"
    set "MOD_QML=!SOURCE_DIR!\qml"
    set "NEXT_IS_SOURCE=false"
) else if /I "%~1"=="-s" (
    set "NEXT_IS_SOURCE=true"
) else if /I "%~1"=="--source" (
    set "NEXT_IS_SOURCE=true"
) else if /I "%~1"=="/pull" (
    set "PULL_RESTORE=true"
) else if /I "%~1"=="--pull" (
    set "PULL_RESTORE=true"
) else if /I "%~1"=="/fresh" (
    set "FRESH=true"
) else if /I "%~1"=="--fresh" (
    set "FRESH=true"
) else if /I "%~1"=="/symlink" (
    set "SYMLINK=true"
) else if /I "%~1"=="--symlink" (
    set "SYMLINK=true"
) else if /I "%~1"=="/full" (
    set "FULL=true"
) else if /I "%~1"=="--full" (
    set "FULL=true"
) else if /I "%~1"=="--with-logger" (
    set "WITH_LOGGER=true"
) else if /I "%~1"=="/with-logger" (
    set "WITH_LOGGER=true"
) else if /I "%~1"=="/branch" (
    shift
    if "%~1"=="" (
        echo Error: /branch requires a branch name
        goto :end_error
    )
    set "BRANCH=%~1"
) else if /I "%~1"=="--branch" (
    shift
    if "%~1"=="" (
        echo Error: --branch requires a branch name
        goto :end_error
    )
    set "BRANCH=%~1"
) else if /I "%~1"=="/local" (
    shift
    if "%~1"=="" (
        echo Error: /local requires a path to local traktor-logger directory
        goto :end_error
    )
    set "LOGGER_LOCAL_PATH=%~1"
) else if /I "%~1"=="--local" (
    shift
    if "%~1"=="" (
        echo Error: --local requires a path to local traktor-logger directory
        goto :end_error
    )
    set "LOGGER_LOCAL_PATH=%~1"
) else if /I "%~1"=="restore" (
    set "MODE=restore"
) else if /I "%~1"=="logger" (
    shift
    if "%~1"=="" (
        echo Error: 'logger' requires a subcommand (pull or install)
        goto :end_error
    )
    if /I "%~1"=="pull" (
        set "MODE=pull-logger"
    ) else if /I "%~1"=="install" (
        set "MODE=install-logger-only"
    ) else (
        echo Error: Unknown logger subcommand: %~1
        goto :end_error
    )
) else if /I "%~1"=="server" (
    shift
    if "%~1"=="" (
        echo Error: 'server' requires a subcommand (start)
        goto :end_error
    )
    if /I "%~1"=="start" (
        set "START_SERVER=true"
    ) else (
        echo Error: Unknown server subcommand: %~1
        goto :end_error
    )
) else if /I "%~1"=="enable-metadata" (
    shift
    if "%~1"=="" (
        echo Error: 'enable-metadata' requires controller names
        goto :end_error
    )
    set "ENABLE_METADATA=%~1"
    set "MODE=enable-metadata"
    shift
) else (
    echo Error: Unknown argument: %~1
    goto :end_error
)

shift
goto :parse_args

:end_parse_args

:: --- RESTORE MODE ---

if /I "!MODE!"=="restore" (
    REM Verify Traktor paths exist
    if not exist "!TRAKTOR_QML!" (
        echo Error: Traktor Pro 4 not found at expected path.
        echo   Expected: !TRAKTOR_QML!
        goto :end_error
    )
    if "!PULL_RESTORE!"=="true" (
        echo Fetching stock QML files from GitHub ^(--pull^)...
        echo This will replace the live qml, removing ALL mods and symlinks.
        set /p CONFIRM="Are you sure? (y/n): "
        if /I not "!CONFIRM!"=="y" (
            echo Restore cancelled.
            goto :end
        )
        call :restore_from_github
        if !ERRORLEVEL! NEQ 0 goto :end_error
        goto :end
    )
    if not exist "!TRAKTOR_QML_BACKUP!" (
        echo Error: No backup found at: !TRAKTOR_QML_BACKUP!
        echo   Cannot restore — was the mod installed with this script?
        echo.
        echo To fetch stock QML from GitHub instead, run:
        echo   traktor-mod.bat restore /pull
        goto :end_error
    )
    echo Restoring stock qml from backup...
    echo.
    set /p CONFIRM="Are you sure you want to restore stock qml? (y/n): "
    if /I not "!CONFIRM!"=="y" (
        echo Restore cancelled.
        goto :end
    )
    rmdir /s /q "!TRAKTOR_QML!" 2>nul
    if !ERRORLEVEL! NEQ 0 (
        echo Error: Could not delete current qml folder. Is Traktor running?
        goto :end_error
    )
    move "!TRAKTOR_QML_BACKUP!" "!TRAKTOR_QML!" >nul 2>&1
    if !ERRORLEVEL! NEQ 0 (
        echo Error: Could not restore backup. Aborting.
        goto :end_error
    )
    echo Done. Restart Traktor to apply.
    goto :end
)

:: --- ENABLE METADATA MODE ---

if /I "!MODE!"=="enable-metadata" (
    call :enable_metadata_traktor "!ENABLE_METADATA!"
    goto :end
)

:: --- PULL LOGGER MODE ---

if /I "!MODE!"=="pull-logger" (
    call :logger_pull
    goto :end
)

:: --- INSTALL LOGGER ONLY MODE ---

if /I "!MODE!"=="install-logger-only" (
    echo Installing Logger.qml and Api modules to Traktor qml...
    call :install_logger_to_traktor
    if !ERRORLEVEL! EQU 0 (
        if "!START_SERVER!"=="true" (
            call :start_server
        )
        goto :end
    ) else (
        echo Error: Installation failed
        goto :end_error
    )
)

:: --- START SERVER ONLY (if 'server start' with no other action flags) ---

if "!START_SERVER!"=="true" if "!MODE!"=="install" if "!FRESH!"=="false" if "!SYMLINK!"=="false" if "!FULL!"=="false" if "!WITH_LOGGER!"=="false" (
    call :start_server
    goto :end
)

:: --- STANDARD INSTALL MODE ---

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║ Traktor Mod Installer (Windows) - Full Featured Edition        ║
echo ║ Supports: overlay/full modes, symlinks, logger, metadata       ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

if not exist "!TRAKTOR_QML!" (
    echo Error: Traktor Pro 4 not found at expected path.
    echo   Expected: !TRAKTOR_QML!
    goto :end_error
)

if not exist "!MOD_QML!" (
    if exist "!SOURCE_DIR!" (
        echo Error: No 'qml' folder found.
        echo   Source: !SOURCE_DIR!
        echo   Looking for: !MOD_QML!
    ) else (
        echo Error: Source directory not found.
        echo   Source: !SOURCE_DIR!
    )
    goto :end_error
)

:: Create backup on first install
if not exist "!TRAKTOR_QML_BACKUP!" (
    echo Creating backup of stock qml...
    robocopy "!TRAKTOR_QML!" "!TRAKTOR_QML_BACKUP!" /E /COPYALL /NFL /NDL /NJH /NJS >nul
    if !ERRORLEVEL! LEQ 7 (
        echo   Backup saved: !TRAKTOR_QML_BACKUP!
    ) else (
        echo Error: Could not create backup. Aborting.
        goto :end_error
    )
) else (
    echo Backup exists: !TRAKTOR_QML_BACKUP!
)

:: In fresh mode, reset live qml to stock
if "!FRESH!"=="true" (
    echo Fresh mode: resetting live qml to stock...
    :: If qml is a symlink/junction (e.g. from a prior /full /symlink), remove it first
    :: so robocopy creates a real directory rather than writing through the link
    fsutil reparsepoint query "!TRAKTOR_QML!" >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        rmdir "!TRAKTOR_QML!"
    )
    robocopy "!TRAKTOR_QML_BACKUP!" "!TRAKTOR_QML!" /MIR /NFL /NDL /NJH /NJS >nul
    if !ERRORLEVEL! GTR 7 (
        echo Error: Could not reset to stock. Aborting.
        goto :end_error
    )
)

:: Install mod using full replacement, symlinks, or copy
if "!FULL!"=="true" (
    :: Resolve MOD_QML to absolute path
    for /f "delims=" %%P in ('cd /d "!MOD_QML!" 2^>nul ^&^& cd') do set "MOD_QML_ABS=%%P"
    if not defined MOD_QML_ABS (
        echo Error: Could not resolve mod source path: !MOD_QML!
        goto :end_error
    )

    if "!SYMLINK!"=="true" (
        echo Installing mod (full replacement - symlinking entire qml)...
        rmdir /s /q "!TRAKTOR_QML!" 2>nul
        if !ERRORLEVEL! NEQ 0 (
            echo Error: Could not delete current qml folder. Is Traktor running?
            goto :end_error
        )
        mklink /d "!TRAKTOR_QML!" "!MOD_QML_ABS!" >nul 2>&1
        if !ERRORLEVEL! NEQ 0 (
            echo Error: Could not create symlink. Make sure you have sufficient permissions.
            goto :end_error
        )
        echo Done.
        echo.
        echo Symlink: !TRAKTOR_QML! -^> !MOD_QML_ABS!
        echo Edit files there and restart Traktor - no reinstall needed.
    ) else (
        echo Installing mod (full replacement - replacing entire qml)...
        rmdir /s /q "!TRAKTOR_QML!" 2>nul
        if !ERRORLEVEL! NEQ 0 (
            echo Error: Could not delete current qml folder. Is Traktor running?
            goto :end_error
        )
        robocopy "!MOD_QML!" "!TRAKTOR_QML!" /E /COPYALL /NFL /NDL /NJH /NJS >nul
        if !ERRORLEVEL! LEQ 7 (
            echo Done.
        ) else (
            echo Error: Could not copy mod files. Aborting.
            goto :end_error
        )
    )
) else if "!SYMLINK!"=="true" (
    :: Resolve MOD_QML to absolute path
    for /f "delims=" %%P in ('cd /d "!MOD_QML!" 2^>nul ^&^& cd') do set "MOD_QML_ABS=%%P"
    if not defined MOD_QML_ABS (
        echo Error: Could not resolve mod source path: !MOD_QML!
        goto :end_error
    )
    echo Installing mod (symlinking overlay files into Traktor qml)...

    :: PowerShell symlink helper for overlay mode
    powershell -NoProfile -Command ^
      "try {" ^
      "$src = '!MOD_QML_ABS!'; $dst = '!TRAKTOR_QML!';" ^
      "Get-ChildItem -Path $src -Recurse -File | ForEach-Object {" ^
      "  $rel = $_.FullName.Substring($src.Length + 1);" ^
      "  $dstFile = Join-Path $dst $rel;" ^
      "  $dstDir = Split-Path $dstFile;" ^
      "  if (!(Test-Path $dstDir)) { New-Item -ItemType Directory -Path $dstDir -Force | Out-Null };" ^
      "  if (Test-Path $dstFile) { Remove-Item $dstFile -Force };" ^
      "  cmd /c mklink '\"'$dstFile'\"' '\"'$_.FullName'\"' | Out-Null" ^
      "}" ^
      "} catch { Write-Error $_; exit 1 }"

    if !ERRORLEVEL! EQU 0 (
        echo Done.
        echo.
        echo Symlinks point to: !MOD_QML_ABS!
        echo Edit files there and restart Traktor - no reinstall needed.
    ) else (
        echo Warning: Some symlinks could not be created. Check file permissions.
    )
) else (
    echo Installing mod (merging overlay into Traktor qml)...
    robocopy "!MOD_QML!" "!TRAKTOR_QML!" /E /NFL /NDL /NJH /NJS >nul
    if !ERRORLEVEL! LEQ 7 (
        echo Done.
    ) else (
        echo Error: An error occurred while copying mod files.
        echo   Error code: !ERRORLEVEL!
        goto :end_error
    )
)

:: Optional: Install Logger.qml
if "!WITH_LOGGER!"=="true" (
    echo.
    echo Installing Logger.qml and Api modules for debugging...
    call :install_logger_to_mod
)

:: Optional: Start the server
if "!START_SERVER!"=="true" (
    echo.
    call :start_server
)

echo.
echo To undo all mods:  traktor-mod restore
echo Restart Traktor to apply changes.

goto :end

:: ============================================================
:: FUNCTIONS
:: ============================================================

:download_traktor_logger_from_github
:: Download entire traktor-logger repo from GitHub as a zip archive
:: Arguments: %1=branch name
setlocal enabledelayedexpansion
set "DL_BRANCH=%~1"
if "!DL_BRANCH!"=="" set "DL_BRANCH=main"
set "ZIP_URL=https://github.com/lsmith77/traktor-logger/archive/refs/heads/!DL_BRANCH!.zip"
set "TMP_ZIP=%TEMP%\traktor-logger-download.zip"
set "TMP_DIR=%TEMP%\traktor-logger-download"
set "CACHE_DIR=%LOGGER_CACHE_DIR%"

echo Downloading traktor-logger from: !ZIP_URL!

:: Remove old cache and temp dirs
if exist "!CACHE_DIR!" rmdir /s /q "!CACHE_DIR!" 2>nul
if exist "!TMP_DIR!" rmdir /s /q "!TMP_DIR!" 2>nul
if exist "!TMP_ZIP!" del /f /q "!TMP_ZIP!" 2>nul

mkdir "!CACHE_DIR!" 2>nul

powershell -NoProfile -Command "& { try { Invoke-WebRequest -Uri '!ZIP_URL!' -OutFile '!TMP_ZIP!'; Expand-Archive -Path '!TMP_ZIP!' -DestinationPath '!TMP_DIR!' -Force; $inner = Get-ChildItem '!TMP_DIR!' | Select-Object -First 1; Copy-Item -Path ($inner.FullName + '\*') -Destination '!CACHE_DIR!' -Recurse -Force; Remove-Item '!TMP_ZIP!' -Force -ErrorAction SilentlyContinue; Remove-Item '!TMP_DIR!' -Recurse -Force -ErrorAction SilentlyContinue; Write-Host 'Download complete.' } catch { Write-Error $_; exit 1 } }"

if !ERRORLEVEL! NEQ 0 (
    echo Error: Failed to download traktor-logger from GitHub
    if exist "!CACHE_DIR!" rmdir /s /q "!CACHE_DIR!" 2>nul
    endlocal
    exit /b 1
)

echo Downloaded to: !CACHE_DIR!
endlocal
exit /b 0

:logger_pull
:: Pull traktor-logger into cache from GitHub or local directory
setlocal enabledelayedexpansion

if not "!LOGGER_LOCAL_PATH!"=="" (
    echo Copying traktor-logger from local: !LOGGER_LOCAL_PATH! -^> !LOGGER_CACHE_DIR!
    if exist "!LOGGER_CACHE_DIR!" rmdir /s /q "!LOGGER_CACHE_DIR!" 2>nul
    if "!SYMLINK!"=="true" (
        mklink /d "!LOGGER_CACHE_DIR!" "!LOGGER_LOCAL_PATH!" >nul 2>&1
        if !ERRORLEVEL! EQU 0 (
            echo Symlinked local traktor-logger directory into cache.
        ) else (
            echo Error: Could not create symlink. Make sure you have sufficient permissions.
            endlocal
            exit /b 1
        )
    ) else (
        mkdir "!LOGGER_CACHE_DIR!" 2>nul
        robocopy "!LOGGER_LOCAL_PATH!" "!LOGGER_CACHE_DIR!" /E /NFL /NDL /NJH /NJS >nul
        if !ERRORLEVEL! LEQ 7 (
            echo Copied local traktor-logger directory into cache.
        ) else (
            echo Error: Could not copy local traktor-logger directory.
            endlocal
            exit /b 1
        )
    )
    endlocal
    exit /b 0
)

call :download_traktor_logger_from_github "!BRANCH!"
endlocal
exit /b %ERRORLEVEL%

:get_logger_qml_path
:: Get path to Logger.qml (download if needed)
:: Returns path via named variable %1
setlocal enabledelayedexpansion
set "CACHE_FILE=!LOGGER_CACHE_DIR!\qml\Logger.qml"

if exist "!CACHE_FILE!" (
    endlocal & set "%~1=!CACHE_FILE!"
    exit /b 0
)

:: Not in cache - try downloading the full package
call :download_traktor_logger_from_github "!BRANCH!"
if !ERRORLEVEL! NEQ 0 (
    endlocal
    exit /b 1
)

if exist "!CACHE_FILE!" (
    endlocal & set "%~1=!CACHE_FILE!"
    exit /b 0
) else (
    endlocal
    exit /b 1
)

:install_logger_to_traktor
:: Install Logger.qml and Api modules to Traktor's live QML
setlocal enabledelayedexpansion

if not exist "!TRAKTOR_QML!" (
    echo Error: Traktor Pro 4 not found at expected path.
    echo   Expected: !TRAKTOR_QML!
    endlocal
    exit /b 1
)

:: Symlink mode: copy logger files into local mod qml, then symlink Traktor's qml to it
if "!SYMLINK!"=="true" (
    if not exist "!MOD_QML!" (
        echo Error: No local mod qml found at !MOD_QML!
        echo   Run from a mod directory containing a qml\ folder, or use without /symlink
        endlocal
        exit /b 1
    )
    :: Resolve MOD_QML to absolute path
    for /f "delims=" %%P in ('cd /d "!MOD_QML!" 2^>nul ^&^& cd') do set "MOD_QML_ABS=%%P"
    if not defined MOD_QML_ABS (
        echo Error: Could not resolve mod qml path: !MOD_QML!
        endlocal
        exit /b 1
    )
    :: Copy logger files into local mod's qml
    if not exist "!LOGGER_CACHE_DIR!\qml" (
        call :download_traktor_logger_from_github "!BRANCH!"
        if !ERRORLEVEL! NEQ 0 (
            echo Error: Could not obtain traktor-logger package
            endlocal
            exit /b 1
        )
    )
    if not exist "!MOD_QML_ABS!\Defines" mkdir "!MOD_QML_ABS!\Defines"
    call :get_logger_qml_path LOGGER_PATH
    copy "!LOGGER_PATH!" "!MOD_QML_ABS!\Defines\Logger.qml" >nul 2>&1
    echo   [OK] Logger.qml: !MOD_QML_ABS!\Defines\Logger.qml
    if exist "!LOGGER_CACHE_DIR!\qml\CSI\Common\Api" (
        if not exist "!MOD_QML_ABS!\CSI\Common\Api" mkdir "!MOD_QML_ABS!\CSI\Common\Api"
        xcopy "!LOGGER_CACHE_DIR!\qml\CSI\Common\Api\*" "!MOD_QML_ABS!\CSI\Common\Api\" /E /Y /Q >nul 2>&1
        echo   [OK] Api modules: !MOD_QML_ABS!\CSI\Common\Api\
    )
    if exist "!LOGGER_CACHE_DIR!\qml\Screens\Common" (
        if not exist "!MOD_QML_ABS!\Screens\Common" mkdir "!MOD_QML_ABS!\Screens\Common"
        xcopy "!LOGGER_CACHE_DIR!\qml\Screens\Common\*" "!MOD_QML_ABS!\Screens\Common\" /E /Y /Q >nul 2>&1
        echo   [OK] Screens modules: !MOD_QML_ABS!\Screens\Common\
    )
    :: Symlink Traktor's qml to the local mod's qml
    rmdir /s /q "!TRAKTOR_QML!" 2>nul
    mklink /d "!TRAKTOR_QML!" "!MOD_QML_ABS!" >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        echo   [OK] qml: !TRAKTOR_QML! -^> !MOD_QML_ABS!
    ) else (
        echo   [FAIL] Could not create symlink for qml directory
        endlocal
        exit /b 1
    )
    echo.
    echo [OK] Logger installation complete!
    echo.
    echo Edit files in !MOD_QML_ABS! and restart Traktor - no reinstall needed.
    endlocal
    exit /b 0
)

:: Copy mode: install individual files into Traktor's live QML

if not exist "!TRAKTOR_QML!\Defines" (
    mkdir "!TRAKTOR_QML!\Defines"
)

:: Get Logger.qml path (download if needed)
call :get_logger_qml_path LOGGER_PATH
if !ERRORLEVEL! NEQ 0 (
    echo Error: Could not obtain Logger.qml
    endlocal
    exit /b 1
)

copy "!LOGGER_PATH!" "!TRAKTOR_QML!\Defines\Logger.qml" >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    echo   [OK] Logger.qml: !TRAKTOR_QML!\Defines\Logger.qml
) else (
    echo   [FAIL] Could not copy Logger.qml
    endlocal
    exit /b 1
)

:: Register in qmldir
if not exist "!TRAKTOR_QML!\Defines\qmldir" (
    (
        echo module Traktor.Defines
        echo Logger 1.0 Logger.qml
    ) > "!TRAKTOR_QML!\Defines\qmldir"
) else (
    findstr /M "^Logger" "!TRAKTOR_QML!\Defines\qmldir" >nul 2>&1
    if !ERRORLEVEL! NEQ 0 (
        echo Logger 1.0 Logger.qml >> "!TRAKTOR_QML!\Defines\qmldir"
    )
)

:: Download full package if Api modules not in cache
if not exist "!LOGGER_CACHE_DIR!\qml\CSI\Common\Api" (
    call :download_traktor_logger_from_github "!BRANCH!"
)

:: Copy Api modules
if exist "!LOGGER_CACHE_DIR!\qml\CSI\Common\Api" (
    if not exist "!TRAKTOR_QML!\CSI\Common\Api" (
        mkdir "!TRAKTOR_QML!\CSI\Common\Api"
    )
    xcopy "!LOGGER_CACHE_DIR!\qml\CSI\Common\Api\*" "!TRAKTOR_QML!\CSI\Common\Api\" /E /Y /Q >nul 2>&1
    echo   [OK] Api modules: !TRAKTOR_QML!\CSI\Common\Api\
) else (
    echo   [WARN] Api modules: not available in cache (Logger.qml is installed)
)

:: Copy Screens modules
if exist "!LOGGER_CACHE_DIR!\qml\Screens\Common" (
    if not exist "!TRAKTOR_QML!\Screens\Common" mkdir "!TRAKTOR_QML!\Screens\Common"
    xcopy "!LOGGER_CACHE_DIR!\qml\Screens\Common\*" "!TRAKTOR_QML!\Screens\Common\" /E /Y /Q >nul 2>&1
    echo   [OK] Screens modules: !TRAKTOR_QML!\Screens\Common\
    :: ApiBrowser.qml imports ApiClient.js from the same directory
    if exist "!LOGGER_CACHE_DIR!\qml\CSI\Common\Api\ApiClient.js" (
        copy /Y "!LOGGER_CACHE_DIR!\qml\CSI\Common\Api\ApiClient.js" "!TRAKTOR_QML!\Screens\Common\ApiClient.js" >nul 2>&1
    )
)

echo.
echo [OK] Logger installation complete!
echo.
echo For simple debug logging in your controller:
echo   import Traktor.Defines 1.0
echo   Logger { id: logger }
echo   logger.info('Message', { data: 'value' })
echo.
echo For automatic metadata collection (deck state, channels, tempo, browser):
echo   Use: traktor-mod.bat enable-metadata ControllerName
echo   Example: traktor-mod.bat enable-metadata D2
echo   Then open the Logger Web Dashboard at http://localhost:8080
echo.
echo Components installed:
echo   - Logger.qml: !TRAKTOR_QML!\Defines\Logger.qml
echo   - Api modules: !TRAKTOR_QML!\CSI\Common\Api\
echo   - Screens modules: !TRAKTOR_QML!\Screens\Common\
endlocal
exit /b 0

:install_logger_to_mod
:: Install Logger.qml to mod's folder
setlocal enabledelayedexpansion

if not exist "!MOD_QML!\Defines" (
    mkdir "!MOD_QML!\Defines"
)

call :get_logger_qml_path LOGGER_PATH
if !ERRORLEVEL! NEQ 0 (
    echo Error: Could not obtain Logger.qml
    endlocal
    exit /b 1
)

copy "!LOGGER_PATH!" "!MOD_QML!\Defines\Logger.qml" >nul 2>&1
echo   [OK] Logger.qml installed to mod

if exist "!LOGGER_CACHE_DIR!\qml\CSI\Common\Api" (
    if not exist "!MOD_QML!\CSI\Common\Api" (
        mkdir "!MOD_QML!\CSI\Common\Api"
    )
    xcopy "!LOGGER_CACHE_DIR!\qml\CSI\Common\Api\*" "!MOD_QML!\CSI\Common\Api\" /E /Y /Q >nul 2>&1
    echo   [OK] Api modules installed to mod
)

if exist "!LOGGER_CACHE_DIR!\qml\Screens\Common" (
    if not exist "!MOD_QML!\Screens\Common" mkdir "!MOD_QML!\Screens\Common"
    xcopy "!LOGGER_CACHE_DIR!\qml\Screens\Common\*" "!MOD_QML!\Screens\Common\" /E /Y /Q >nul 2>&1
    echo   [OK] Screens modules: !MOD_QML!\Screens\Common\
    if exist "!LOGGER_CACHE_DIR!\qml\CSI\Common\Api\ApiClient.js" (
        copy /Y "!LOGGER_CACHE_DIR!\qml\CSI\Common\Api\ApiClient.js" "!MOD_QML!\Screens\Common\ApiClient.js" >nul 2>&1
    )
)

endlocal
exit /b 0

:enable_metadata_traktor
:: Enable metadata for Traktor's installed QML
setlocal enabledelayedexpansion
set "CONTROLLER=%~1"

if "!CONTROLLER!"=="" (
    echo Error: No controller specified for metadata
    endlocal
    exit /b 1
)

:: Verify Api modules are installed
if not exist "!TRAKTOR_QML!\CSI\Common\Api" (
    echo Error: Api modules not found in Traktor qml
    echo.
    echo Install them first with:
    echo   traktor-mod.bat logger install
    echo.
    echo Or pull and install with:
    echo   traktor-mod.bat logger pull
    echo   traktor-mod.bat logger install
    endlocal
    exit /b 1
)

echo Enabling metadata collection for controller: !CONTROLLER!
echo Target: !TRAKTOR_QML!

set "CONTROLLER_FILE=!TRAKTOR_QML!\CSI\!CONTROLLER!\!CONTROLLER!.qml"

if exist "!CONTROLLER_FILE!" (
    echo   Enabling: !CONTROLLER!

    :: Check if ApiModule is already present (idempotent)
    findstr /M "ApiModule" "!CONTROLLER_FILE!" >nul 2>&1
    if !ERRORLEVEL! NEQ 0 (
        :: Use PowerShell to safely inject import and ApiModule
        powershell -NoProfile -Command ^
            "& {" ^
            "$file = '!CONTROLLER_FILE!';" ^
            "$content = Get-Content -Path $file -Raw;" ^
            "$lines = $content -split \"`n\";" ^
            "$newLines = @(); $importAdded = $false; $inImports = $false;" ^
            "foreach ($line in $lines) {" ^
            "  if ($line -match '^import ') { $inImports = $true; $newLines += $line }" ^
            "  elseif ($inImports -and -not $importAdded -and $line -notmatch '^import ' -and $line -notmatch '^\s*$') {" ^
            "    if ($content -notmatch 'import.*Common/Api') { $newLines += 'import \"../Common/Api\"' };" ^
            "    $newLines += $line; $importAdded = $true; $inImports = $false" ^
            "  } else { $newLines += $line }" ^
            "};" ^
            "$content = $newLines -join \"`n\";" ^
            "$lines2 = $content -split \"`n\";" ^
            "$out = @(); $done = $false; $pastImports = $false;" ^
            "foreach ($line in $lines2) {" ^
            "  if ($line -match '^import ') { $pastImports = $true; $out += $line; continue };" ^
            "  if ($pastImports -and -not $done -and $line -match 'Mapping\s*\{') {" ^
            "    $out += $line; $out += '  // Automatic metadata collection';" ^
            "    $out += '  ApiModule {}'; $done = $true; continue" ^
            "  };" ^
            "  $out += $line" ^
            "};" ^
            "Set-Content -Path $file -Value ($out -join \"`n\") -NoNewline }"

        if !ERRORLEVEL! EQU 0 (
            echo   [OK] !CONTROLLER!: metadata enabled
        ) else (
            echo   [FAIL] Could not enable metadata for !CONTROLLER!
        )
    ) else (
        echo   [OK] !CONTROLLER!: metadata already enabled
    )
) else (
    echo   [SKIP] !CONTROLLER! not found: !CONTROLLER_FILE!
)

call :enable_browser_in_all_screens "!TRAKTOR_QML!"

endlocal
exit /b 0

:enable_browser_in_all_screens
:: Inject ApiBrowser into every Screen.qml found under the Screens/ directory.
:: Screen files are shared across controllers, so we inject into all of them.
:: Arguments: %1=target dir (defaults to TRAKTOR_QML)
setlocal enabledelayedexpansion
set "TARGET_DIR=%~1"
if "!TARGET_DIR!"=="" set "TARGET_DIR=!TRAKTOR_QML!"
set "SCREENS_DIR=!TARGET_DIR!\Screens"

if not exist "!SCREENS_DIR!" (
    echo   [SKIP] No Screens directory found - browser monitoring skipped
    endlocal
    exit /b 0
)

powershell -NoProfile -Command ^
    "& {" ^
    "$screensDir = '!SCREENS_DIR!'; $traktorQml = '!TARGET_DIR!';" ^
    "$screenFiles = Get-ChildItem -Path $screensDir -Filter 'Screen.qml' -Recurse -ErrorAction SilentlyContinue;" ^
    "foreach ($file in $screenFiles) {" ^
    "  $content = Get-Content -Path $file.FullName -Raw;" ^
    "  $relPath = $file.FullName.Substring($traktorQml.Length + 1);" ^
    "  if ($content -match 'ApiBrowser') { Write-Host \"  [OK] ${relPath}: browser monitoring already enabled\"; continue };" ^
    "  $fileRelToScreens = $file.DirectoryName.Substring($screensDir.Length).TrimStart('\');" ^
    "  if ($fileRelToScreens -eq '') { $depth = 0 } else { $depth = ($fileRelToScreens -split '\\').Count };" ^
    "  $importPath = ('../' * ($depth + 1)).TrimEnd('/') + 'Common';" ^
    "  if ($content -match 'isLeftScreen') { $browserLine = '  LoggerScreens.ApiBrowser { active: isLeftScreen }' }" ^
    "  else { $browserLine = '  LoggerScreens.ApiBrowser {}' };" ^
    "  $importLine = \"import \`\"${importPath}\`\" as LoggerScreens\";" ^
    "  if ($content -notmatch [regex]::Escape($importPath)) {" ^
    "    $lines = $content -split \"`n\";" ^
    "    $newLines = @(); $importAdded = $false; $inImports = $false;" ^
    "    for ($i = 0; $i -lt $lines.Count; $i++) { $line = $lines[$i];" ^
    "      if ($line -match '^import ') { $inImports = $true; $newLines += $line }" ^
    "      elseif ($inImports -and -not $importAdded) { $newLines += $importLine; $newLines += $line; $importAdded = $true; $inImports = $false }" ^
    "      else { $newLines += $line }" ^
    "    }; $content = $newLines -join \"`n\"" ^
    "  };" ^
    "  $lines2 = $content -split \"`n\";" ^
    "  $newLines2 = @(); $pastImports = $false; $done = $false;" ^
    "  foreach ($line in $lines2) {" ^
    "    if ($line -match '^import ') { $pastImports = $true; $newLines2 += $line; continue };" ^
    "    if ($pastImports -and -not $done -and $line -match '\{') { $newLines2 += $line; $newLines2 += $browserLine; $done = $true; continue };" ^
    "    $newLines2 += $line" ^
    "  }; $result = $newLines2 -join \"`n\";" ^
    "  if ($result -notmatch 'ApiBrowser') { Write-Host \"  [FAIL] ${relPath}: injection failed\"; continue };" ^
    "  Set-Content -Path $file.FullName -Value $result -NoNewline;" ^
    "  Write-Host \"  [OK] ${relPath}: browser monitoring enabled\"" ^
    "} }"

endlocal
exit /b 0

:start_server
:: Start the traktor-logger HTTP server
setlocal enabledelayedexpansion

echo Starting traktor-logger server...
echo.

:: Check if Python is available
where python >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    :: Find server.py - check cache
    if not exist "!LOGGER_CACHE_DIR!\server.py" (
        echo Downloading server from GitHub...
        call :download_traktor_logger_from_github "!BRANCH!"
    )
    if exist "!LOGGER_CACHE_DIR!\server.py" (
        echo Server running on http://localhost:8080
        echo Press Ctrl+C to stop
        echo.
        endlocal
        python "!LOGGER_CACHE_DIR!\server.py"
        exit /b 0
    )
)

echo Error: Python 3 not found or server.py not available
echo.
echo To install Python 3:
echo   Visit: https://www.python.org/downloads/
echo   Or: winget install Python.Python.3.11
endlocal
exit /b 1

:showhelp
    echo.
    echo traktor-mod.bat - Install QML mods into Traktor Pro 4 (Windows)
    echo.
    echo Two installation modes available:
    echo.
    echo OVERLAY MODE (default):
    echo   Merges QML changes on top of existing qml. Use to combine multiple mods.
    echo   Supports three sub-modes: stack, fresh, and symlink.
    echo.
    echo FULL REPLACEMENT MODE (/full):
    echo   Replaces entire qml with mod's qml. Use for complete standalone mods.
    echo   Other mods are overwritten; not suitable for combining.
    echo   Supports copy and symlink sub-modes.
    echo.
    echo Overlay Mode Usage:
    echo   traktor-mod.bat                  - merge mod (default)
    echo   traktor-mod.bat /fresh           - reset to stock, then merge
    echo   traktor-mod.bat /symlink         - symlink mode (dev)
    echo   traktor-mod.bat /fresh /symlink  - reset, then symlink
    echo.
    echo Full Replacement Mode Usage:
    echo   traktor-mod.bat /full            - replace entire qml
    echo   traktor-mod.bat /full /symlink   - replace with symlinks (dev mode)
    echo   traktor-mod.bat /full /fresh     - reset stock first, then replace
    echo   traktor-mod.bat /full /fresh /symlink - reset, then symlink with replacement
    echo.
    echo Logger (Monitoring) Options:
    echo   traktor-mod.bat logger pull           - download traktor-logger to local cache from GitHub
    echo   traktor-mod.bat logger pull /branch dev - pull from specific branch
    echo   traktor-mod.bat logger pull /local C:\path - copy from local directory
    echo   traktor-mod.bat logger install        - install Logger.qml and Api modules to Traktor qml
    echo   traktor-mod.bat --with-logger         - include Logger with a mod install
    echo.
    echo Server Launch:
    echo   traktor-mod.bat server start - launch traktor-logger server on localhost:8080
    echo.
    echo Metadata Collection:
    echo   traktor-mod.bat enable-metadata D2    - inject ApiModule into one controller
    echo.
    echo General Options:
    echo   traktor-mod.bat restore         - restore stock qml from backup, remove all mods
    echo   traktor-mod.bat restore /pull  - fetch stock qml from GitHub (ignores backup)
    echo   traktor-mod.bat -s C:\path\to\mod - use specific directory
    echo.
    echo Logger Cache Options (used with 'logger pull'):
    echo   /branch ^<name^>        - pull from a specific GitHub branch (default: main)
    echo   /local ^<path^>         - copy from a local traktor-logger directory
    echo   /symlink (with /local) - symlink local directory into cache instead of copying
    echo.
    echo Help:
    echo   traktor-mod.bat -h              - show this help
    echo   traktor-mod.bat --help          - show this help
    echo   traktor-mod.bat /?              - show this help
    echo.
    echo Notes:
    echo   - Backup created on first install (never overwritten)
    echo   - Restore returns to stock and removes all mods/symlinks
    echo   - Symlinks use absolute paths; moving repo breaks them (run again to fix)
    echo   - Supports both 32-bit and 64-bit Traktor installations
    echo   - Logger requires Python 3 for server (get from python.org)
    echo.
    goto :end

:restore_from_github
:: Fetch stock QML from GitHub traktor-kontrol-qml-files repo, letting the user pick a tag
setlocal enabledelayedexpansion

set "TAGS_FILE=%TEMP%\traktor-qml-tags.txt"
set "SELECTED_TAG_FILE=%TEMP%\traktor-qml-selected-tag.txt"
set "TMP_ZIP=%TEMP%\traktor-qml-restore.zip"
set "TMP_DIR=%TEMP%\traktor-qml-restore"

if exist "!TAGS_FILE!" del /f /q "!TAGS_FILE!" 2>nul
if exist "!SELECTED_TAG_FILE!" del /f /q "!SELECTED_TAG_FILE!" 2>nul

:: Fetch tags and prompt for selection via PowerShell (handles display + Read-Host interactively)
echo Fetching available QML versions from: https://api.github.com/repos/lsmith77/traktor-kontrol-qml-files/tags?per_page=100
powershell -NoProfile -Command ^
    "& { try {" ^
    "  $r = Invoke-RestMethod -Uri 'https://api.github.com/repos/lsmith77/traktor-kontrol-qml-files/tags?per_page=100';" ^
    "  $tags = @($r | ForEach-Object { $_.name });" ^
    "  if ($tags.Count -eq 0) { Write-Error 'No versions found in GitHub repository'; exit 1 };" ^
    "  $detected = '';" ^
    "  try { $detected = (Get-Item '!TRAKTOR_APP!').VersionInfo.ProductVersion } catch {};" ^
    "  Write-Host '';" ^
    "  Write-Host 'Available QML versions:';" ^
    "  $defaultIdx = 0;" ^
    "  for ($i = 0; $i -lt $tags.Count; $i++) {" ^
    "    $marker = '';" ^
    "    $detectedShort = ($detected -split ' ')[0];" ^
    "    if ($detectedShort -and $tags[$i] -like \"*$detectedShort*\") { $marker = ' <- your version'; $defaultIdx = $i + 1 };" ^
    "    Write-Host (\"  {0,2}) {1}{2}\" -f ($i+1), $tags[$i], $marker)" ^
    "  };" ^
    "  Write-Host '';" ^
    "  if ($detected) { Write-Host \"Detected Traktor version: $detected\" };" ^
    "  $prompt = if ($defaultIdx -gt 0) { \"Enter number (default: $defaultIdx) or tag name\" } else { 'Enter number or tag name' };" ^
    "  $sel = Read-Host $prompt;" ^
    "  if ([string]::IsNullOrEmpty($sel) -and $defaultIdx -gt 0) { $sel = $defaultIdx };" ^
    "  $selectedTag = '';" ^
    "  if ($sel -match '^\d+$') {" ^
    "    $idx = [int]$sel - 1;" ^
    "    if ($idx -ge 0 -and $idx -lt $tags.Count) { $selectedTag = $tags[$idx] }" ^
    "    else { Write-Error \"Invalid selection: $sel\"; exit 1 }" ^
    "  } else { $selectedTag = $sel };" ^
    "  if (-not $selectedTag) { Write-Error 'No version selected'; exit 1 };" ^
    "  $selectedTag | Set-Content -Path '!SELECTED_TAG_FILE!'" ^
    "} catch { Write-Error $_; exit 1 } }"

if !ERRORLEVEL! NEQ 0 (
    echo Error: Could not fetch or select a version from GitHub.
    endlocal
    exit /b 1
)

if not exist "!SELECTED_TAG_FILE!" (
    echo Error: No version was selected.
    endlocal
    exit /b 1
)

set /p SELECTED_TAG=<"!SELECTED_TAG_FILE!"
set "SELECTED_TAG=!SELECTED_TAG: =!"
if "!SELECTED_TAG!"=="" (
    echo Error: No version was selected.
    endlocal
    exit /b 1
)

echo.
echo Downloading QML files from: https://github.com/lsmith77/traktor-kontrol-qml-files/archive/refs/tags/!SELECTED_TAG!.zip

if exist "!TMP_DIR!" rmdir /s /q "!TMP_DIR!" 2>nul
if exist "!TMP_ZIP!" del /f /q "!TMP_ZIP!" 2>nul

powershell -NoProfile -Command ^
    "& { try {" ^
    "  $url = 'https://github.com/lsmith77/traktor-kontrol-qml-files/archive/refs/tags/!SELECTED_TAG!.zip';" ^
    "  Invoke-WebRequest -Uri $url -OutFile '!TMP_ZIP!';" ^
    "  Expand-Archive -Path '!TMP_ZIP!' -DestinationPath '!TMP_DIR!' -Force;" ^
    "  $inner = Get-ChildItem '!TMP_DIR!' | Select-Object -First 1;" ^
    "  $qmlSrc = Join-Path $inner.FullName 'qml';" ^
    "  if (-not (Test-Path $qmlSrc)) { Write-Error 'No qml folder found in downloaded archive'; exit 1 };" ^
    "  if (Test-Path '!TRAKTOR_QML!') { Remove-Item -Path '!TRAKTOR_QML!' -Recurse -Force };" ^
    "  if (Test-Path '!TRAKTOR_QML_BACKUP!') { Remove-Item -Path '!TRAKTOR_QML_BACKUP!' -Recurse -Force };" ^
    "  Copy-Item -Path $qmlSrc -Destination '!TRAKTOR_QML!' -Recurse;" ^
    "  Remove-Item '!TMP_ZIP!', '!TMP_DIR!' -Recurse -Force -ErrorAction SilentlyContinue;" ^
    "  Write-Host 'Done.'" ^
    "} catch { Write-Error $_; exit 1 } }"

if !ERRORLEVEL! NEQ 0 (
    echo Error: Failed to download or extract QML files for tag: !SELECTED_TAG!
    endlocal
    exit /b 1
)

echo Restart Traktor to apply.
endlocal
exit /b 0

:end_error
    echo.
    pause
    endlocal
    exit /b 1

:end
    echo.
    pause
    endlocal
    exit /b 0
