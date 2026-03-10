@echo off
setlocal enabledelayedexpansion

:: ============================================================
:: install-traktor-mod.bat — Install a QML overlay mod into Traktor Pro 4 (Windows)
::
:: Usage (double-click or run from Command Prompt):
::   install-traktor-mod.bat                                — merge mod on top of current live qml (stack mode)
::   install-traktor-mod.bat /fresh                        — restore stock first, then merge mod (clean mode)
::   install-traktor-mod.bat /symlink                      — symlink mod files into live qml (dev mode)
::   install-traktor-mod.bat /fresh /symlink               — restore stock first, then symlink mod files
::   install-traktor-mod.bat /full                         — replace entire qml with complete mod (full replacement)
::   install-traktor-mod.bat /full /symlink                — symlink complete mod (full replacement dev mode)
::   install-traktor-mod.bat /full /fresh                  — restore stock first, then replace entire qml
::   install-traktor-mod.bat /full /fresh /symlink         — restore stock, then symlink complete mod
::   install-traktor-mod.bat restore                       — restore stock qml and remove all mods/symlinks
::   install-traktor-mod.bat logger install                — install Logger.qml and Api modules only
::   install-traktor-mod.bat logger update                 — update/refresh Logger and Api modules from GitHub
::   install-traktor-mod.bat server start                  — launch traktor-logger server on localhost:8080
::   install-traktor-mod.bat enable-metadata D2,S8,X1MK3   — inject ApiModule into specified controllers
::
:: Specifying source directory (optional; defaults to current directory):
::   install-traktor-mod.bat -s C:\path\to\mod             — use specific directory
::   install-traktor-mod.bat --source ..\my-mod            — use subdirectory, relative path
::   install-traktor-mod.bat -s C:\mods\mod /fresh         — use custom directory, fresh mode
::
:: Stack mode (default): copies overlay mod files into Traktor's live qml. Other installed mods stay.
:: Fresh mode (/fresh): resets qml to stock first, then applies only this mod.
:: Symlink mode (/symlink): creates symlinks in Traktor's qml pointing back to the files in this mod repo.
:: Full replacement mode (/full): replaces Traktor's entire qml with this complete mod.
:: Logger: Install optional Logger.qml and Api modules for debugging and monitoring.
:: Server: Launch the traktor-logger HTTP server for real-time dashboard monitoring.
:: Metadata: Enable automatic metadata collection from controllers (requires Api modules installed).
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
    set "ELEV_ARGS=%*"
    setlocal disabledelayedexpansion
    set "ELEV_ARGS=!ELEV_ARGS:"=""!"
    setlocal enabledelayedexpansion
    echo Set UAC = CreateObject("Shell.Application") > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~f0", "!ELEV_ARGS!", "%%CD%%", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:admin_ok
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║ Traktor Mod Installer (Windows) - Full Featured Edition        ║
echo ║ Supports: overlay/full modes, symlinks, logger, metadata       ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

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
set "MODE=install"
set "NEXT_IS_SOURCE=false"
set "ENABLE_METADATA="

:: --- parse arguments ---

:parse_args
if "%~1"=="" goto :end_parse_args

if "!NEXT_IS_SOURCE!"=="true" (
    if "%~1"=="" (
        echo Error: -s/--source requires a directory path to follow
        goto :end
    )
    set "NEXT_ARG=%~1"
    if "!NEXT_ARG:~0,1!"=="/" (
        echo Error: -s/--source requires a directory path, not a flag: %~1
        goto :end
    )
    if "!NEXT_ARG:~0,1!"=="-" (
        echo Error: -s/--source requires a directory path, not a flag: %~1
        goto :end
    )
    if not exist "%~1" (
        echo Error: Source directory not found: %~1
        goto :end
    )
    for /f "delims=" %%D in ('cd /d "%~1" 2^>nul ^&^& cd') do set "SOURCE_DIR=%%D"
    set "MOD_QML=!SOURCE_DIR!\qml"
    set "NEXT_IS_SOURCE=false"
) else if /I "%~1"=="-s" (
    set "NEXT_IS_SOURCE=true"
) else if /I "%~1"=="--source" (
    set "NEXT_IS_SOURCE=true"
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
) else if /I "%~1"=="restore" (
    set "MODE=restore"
) else if /I "%~1"=="logger" (
    shift
    if "!%~1:~0,1!"=="" (
        echo Error: 'logger' requires a subcommand (install or update)
        goto :end
    )
    if /I "%~1"=="install" (
        set "MODE=install-logger-only"
    ) else if /I "%~1"=="update" (
        call :update_logger_cache
        goto :end
    ) else (
        echo Error: Unknown logger subcommand: %~1
        goto :end
    )
) else if /I "%~1"=="server" (
    shift
    if "!%~1:~0,1!"=="" (
        echo Error: 'server' requires a subcommand (start)
        goto :end
    )
    if /I "%~1"=="start" (
        set "START_SERVER=true"
    ) else (
        echo Error: Unknown server subcommand: %~1
        goto :end
    )
) else if /I "%~1"=="enable-metadata" (
    shift
    if "!%~1:~0,1!"=="" (
        echo Error: 'enable-metadata' requires controller names
        goto :end
    )
    set "ENABLE_METADATA=%~1"
    set "MODE=enable-metadata"
    shift
) else (
    echo Error: Unknown argument: %~1
    goto :end
)

shift
goto :parse_args

:end_parse_args

:: --- RESTORE MODE ---

if /I "!MODE!"=="restore" (
    if not exist "!TRAKTOR_QML!" (
        echo Error: Traktor Pro 4 not found at expected path.
        echo   Expected: !TRAKTOR_QML!
        goto :end
    )
    if not exist "!TRAKTOR_QML_BACKUP!" (
        echo Error: No backup found at: !TRAKTOR_QML_BACKUP!
        echo   Cannot restore — was the mod installed with this script?
        goto :end
    )
    echo Restoring stock qml from backup...
    rmdir /s /q "!TRAKTOR_QML!" 2>nul
    if !ERRORLEVEL! NEQ 0 (
        echo Error: Could not delete current qml folder. Is Traktor running?
        goto :end
    )
    move "!TRAKTOR_QML_BACKUP!" "!TRAKTOR_QML!" >nul 2>&1
    if !ERRORLEVEL! NEQ 0 (
        echo Error: Could not restore backup. Aborting.
        goto :end
    )
    echo Done. Restart Traktor to apply.
    goto :end
)

:: --- LOGGER UPDATE MODE ---

if /I "!MODE!"=="enable-metadata" (
    call :enable_metadata_traktor "!ENABLE_METADATA!"
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
    ) else (
        echo Error: Installation failed
    )
    goto :end
)

:: --- START SERVER ONLY (if 'server start' with no other action flags) ---

if "!START_SERVER!"=="true" if "!MODE!"=="install" if "!FRESH!"=="false" if "!SYMLINK!"=="false" if "!FULL!"=="false" if "!WITH_LOGGER!"=="false" (
    call :start_server
    goto :end
)

:: --- STANDARD INSTALL MODE ---

if not exist "!TRAKTOR_QML!" (
    echo Error: Traktor Pro 4 not found at expected path.
    echo   Expected: !TRAKTOR_QML!
    goto :end
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
    goto :end
)

:: Create backup on first install
if not exist "!TRAKTOR_QML_BACKUP!" (
    echo Creating backup of stock qml...
    robocopy "!TRAKTOR_QML!" "!TRAKTOR_QML_BACKUP!" /E /COPYALL /NFL /NDL /NJH /NJS >nul
    if !ERRORLEVEL! LEQ 7 (
        echo   Backup saved: !TRAKTOR_QML_BACKUP!
    ) else (
        echo Error: Could not create backup. Aborting.
        goto :end
    )
) else (
    echo Backup exists: !TRAKTOR_QML_BACKUP!
)

:: In fresh mode, reset live qml to stock
if "!FRESH!"=="true" (
    echo Fresh mode: resetting live qml to stock...
    robocopy "!TRAKTOR_QML_BACKUP!" "!TRAKTOR_QML!" /MIR /NFL /NDL /NJH /NJS >nul
    if !ERRORLEVEL! GTR 7 (
        echo Error: Could not reset to stock. Aborting.
        goto :end
    )
)

:: Install mod using full replacement, symlinks, or copy
if "!FULL!"=="true" (
    :: Resolve MOD_QML to absolute path
    for /f "delims=" %%P in ('cd /d "!MOD_QML!" 2^>nul ^&^& cd') do set "MOD_QML_ABS=%%P"
    if not defined MOD_QML_ABS (
        echo Error: Could not resolve mod source path: !MOD_QML!
        goto :end
    )
    
    if "!SYMLINK!"=="true" (
        echo Installing mod (full replacement - symlinking entire qml)...
        rmdir /s /q "!TRAKTOR_QML!" 2>nul
        if !ERRORLEVEL! NEQ 0 (
            echo Error: Could not delete current qml folder. Is Traktor running?
            goto :end
        )
        mklink /d "!TRAKTOR_QML!" "!MOD_QML_ABS!" >nul 2>&1
        if !ERRORLEVEL! NEQ 0 (
            echo Error: Could not create symlink. Make sure you have sufficient permissions.
            goto :end
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
            goto :end
        )
        robocopy "!MOD_QML!" "!TRAKTOR_QML!" /E /COPYALL /NFL /NDL /NJH /NJS >nul
        if !ERRORLEVEL! LEQ 7 (
            echo Done.
        ) else (
            echo Error: Could not copy mod files. Aborting.
            goto :end
        )
    )
) else if "!SYMLINK!"=="true" (
    :: Resolve MOD_QML to absolute path
    for /f "delims=" %%P in ('cd /d "!MOD_QML!" 2^>nul ^&^& cd') do set "MOD_QML_ABS=%%P"
    if not defined MOD_QML_ABS (
        echo Error: Could not resolve mod source path: !MOD_QML!
        goto :end
    )
    echo Installing mod (symlinking overlay files into Traktor qml)...
    
    :: PowerShell symlink helper for overlay mode
    powershell -NoProfile -Command "try { $src = '!MOD_QML_ABS!'; $dst = '!TRAKTOR_QML!'; Get-ChildItem -Path $src -Recurse -File | ForEach-Object { $rel = $_.FullName.Substring($src.Length + 1); $dstFile = Join-Path $dst $rel; $dstDir = Split-Path $dstFile; if (!(Test-Path $dstDir)) { New-Item -ItemType Directory -Path $dstDir -Force | Out-Null }; if (Test-Path $dstFile) { Remove-Item $dstFile -Force }; cmd /c mklink '\"'$dstFile'\"' '\"'$_.FullName'\"' | Out-Null } } catch { Write-Error $_; exit 1 }"
    
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
        goto :end
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
echo To undo all mods:  install-traktor-mod restore

set /p LAUNCH="Launch Traktor now? [y/N] "
if /I "!LAUNCH!"=="y" (
    if exist "!TRAKTOR_APP!" (
        start "" "!TRAKTOR_APP!"
    ) else (
        echo Traktor executable not found at: !TRAKTOR_APP!
    )
)

goto :end

:: ============================================================
:: FUNCTIONS
:: ============================================================

:download_file
:: Download file from URL to destination
:: Arguments: %1=URL, %2=destination file
setlocal
set "URL=%~1"
set "DST=%~2"

if exist "%DST%" (
    exit /b 0
)

echo Downloading from: !URL!...
mkdir "%~dp2" 2>nul

:: Use PowerShell for download (built-in on Windows)
powershell -NoProfile -Command "try { (New-Object Net.WebClient).DownloadFile('%URL%', '%DST%'); Write-Host 'Downloaded to: %DST%' } catch { Write-Error $_; exit 1 }"
exit /b %ERRORLEVEL%

:get_logger_from_github
:: Download Logger.qml from GitHub to cache
setlocal
set "CACHE_DIR=%LOGGER_CACHE_DIR%"
set "CACHE_FILE=!CACHE_DIR!\Logger.qml"
set "URL=%LOGGER_GITHUB_URL%/qml/Logger.qml"

if exist "!CACHE_FILE!" (
    echo !CACHE_FILE!
    exit /b 0
)

mkdir "!CACHE_DIR!" 2>nul
call :download_file "!URL!" "!CACHE_FILE!"
if !ERRORLEVEL! EQU 0 (
    echo !CACHE_FILE!
    exit /b 0
) else (
    echo Error: Failed to download Logger.qml
    exit /b 1
)

:get_logger_server_from_github
:: Download entire traktor-logger package
setlocal
set "CACHE_DIR=%LOGGER_CACHE_DIR%"
set "BASE_URL=%LOGGER_GITHUB_URL%"

mkdir "!CACHE_DIR!\qml\CSI\Common\Api" 2>nul

:: List of files to download
set "FILES[0]=server.py"
set "FILES[1]=README.md"
set "FILES[2]=qml/Logger.qml"
set "FILES[3]=qml/qmldir"
set "FILES[4]=qml/CSI/Common/Api/ApiClient.js"
set "FILES[5]=qml/CSI/Common/Api/ApiDeck.qml"
set "FILES[6]=qml/CSI/Common/Api/ApiMasterClock.qml"
set "FILES[7]=qml/CSI/Common/Api/ApiModule.qml"

echo Downloading traktor-logger package from GitHub...

for /L %%i in (0,1,7) do (
    set "FILE=!FILES[%%i]!"
    set "URL=!BASE_URL!/!FILE!"
    set "DST=!CACHE_DIR!\!FILE!"
    mkdir "!DST!\..\" 2>nul
    call :download_file "!URL!" "!DST!"
    if !ERRORLEVEL! NEQ 0 (
        echo Warning: Failed to download !FILE!
    )
)

echo Package downloaded to: !CACHE_DIR!
exit /b 0

:update_logger_cache
echo Updating traktor-logger package from GitHub...
if exist "%LOGGER_CACHE_DIR%" (
    rmdir /s /q "%LOGGER_CACHE_DIR%" 2>nul
)
call :get_logger_server_from_github
exit /b 0

:install_logger_to_traktor
:: Install Logger.qml and Api modules to Traktor's live QML
if not exist "!TRAKTOR_QML!\Defines" (
    mkdir "!TRAKTOR_QML!\Defines"
)

:: Download Logger to cache first
call :get_logger_qml_path LOGGER_PATH
if !ERRORLEVEL! NEQ 0 (
    echo Error: Could not obtain Logger.qml
    exit /b 1
)

:: Copy Logger.qml
copy "!LOGGER_PATH!" "!TRAKTOR_QML!\Defines\Logger.qml" >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    echo   [OK] Logger.qml: !TRAKTOR_QML!\Defines\Logger.qml
) else (
    echo   [FAIL] Could not copy Logger.qml
    exit /b 1
)

:: Register in qmldir
if not exist "!TRAKTOR_QML!\Defines\qmldir" (
    (
        echo module Traktor.Defines
        echo Logger 1.0 Logger.qml
    ) > "!TRAKTOR_QML!\Defines\qmldir"
)

:: Download and copy Api modules
if not exist "!LOGGER_CACHE_DIR!\qml\CSI\Common\Api" (
    call :get_logger_server_from_github
)

if exist "!LOGGER_CACHE_DIR!\qml\CSI\Common\Api" (
    if not exist "!TRAKTOR_QML!\CSI\Common\Api" (
        mkdir "!TRAKTOR_QML!\CSI\Common\Api"
    )
    xcopy "!LOGGER_CACHE_DIR!\qml\CSI\Common\Api\*" "!TRAKTOR_QML!\CSI\Common\Api\" /E /Y /Q >nul 2>&1
    echo   [OK] Api modules: !TRAKTOR_QML!\CSI\Common\Api\
)

echo.
echo [OK] Logger installation complete!
exit /b 0

:install_logger_to_mod
:: Install Logger.qml to mod's folder
if not exist "!MOD_QML!\Defines" (
    mkdir "!MOD_QML!\Defines"
)

call :get_logger_qml_path LOGGER_PATH
if !ERRORLEVEL! NEQ 0 (
    echo Error: Could not obtain Logger.qml
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

exit /b 0

:get_logger_qml_path
:: Get path to Logger.qml (download if needed)
setlocal
set "CACHE_FILE=%LOGGER_CACHE_DIR%\Logger.qml"

if exist "!CACHE_FILE!" (
    endlocal & set "%~1=!CACHE_FILE!"
    exit /b 0
)

mkdir "%LOGGER_CACHE_DIR%" 2>nul
call :download_file "%LOGGER_GITHUB_URL%/qml/Logger.qml" "!CACHE_FILE!"
if !ERRORLEVEL! EQU 0 (
    endlocal & set "%~1=!CACHE_FILE!"
    exit /b 0
) else (
    exit /b 1
)

:enable_metadata_traktor
:: Enable metadata for Traktor's installed QML
setlocal
set "CONTROLLERS=%~1"

if "%CONTROLLERS%"=="" (
    echo Error: No controllers specified for metadata
    exit /b 1
)

:: Verify Api modules are installed
if not exist "!TRAKTOR_QML!\CSI\Common\Api" (
    echo Error: Api modules not found in Traktor qml
    echo.
    echo Install them first with:
    echo   install-traktor-mod logger install
    exit /b 1
)

echo Enabling metadata for: !CONTROLLERS!

:: Parse comma-separated list and enable metadata for each controller
setlocal enabledelayedexpansion
for %%C in (!CONTROLLERS!) do (
    set "CONTROLLER=%%C"
    set "CONTROLLER_FILE=!TRAKTOR_QML!\CSI\!CONTROLLER!\!CONTROLLER!.qml"
    
    if exist "!CONTROLLER_FILE!" (
        echo   Enabling: !CONTROLLER!
        
        :: Check if ApiModule is already present
        findstr /M "ApiModule" "!CONTROLLER_FILE!" >nul 2>&1
        if !ERRORLEVEL! NEQ 0 (
            :: Use PowerShell to safely inject ApiModule
            powershell -NoProfile -Command "try { $content = Get-Content '!CONTROLLER_FILE!'; $content = $content -replace '(\{)(\s*)', '`$1 // Automatic metadata collection`n  ApiModule {}' -replace '(\{)(\s*)(\/\/ Automatic metadata)', '`$1`$2`$3'; Set-Content '!CONTROLLER_FILE!' $content } catch { Write-Error $_; exit 1 }"
            
            if !ERRORLEVEL! EQU 0 (
                echo   [OK] !CONTROLLER! metadata enabled
            ) else (
                echo   [FAIL] Could not enable metadata for !CONTROLLER!
            )
        ) else (
            echo   [OK] !CONTROLLER! metadata already enabled
        )
    ) else (
        echo   [SKIP] !CONTROLLER! not found
    )
)

exit /b 0

:start_server
:: Start the traktor-logger HTTP server
setlocal
set "PYTHON_EXE=python"

echo Starting traktor-logger server...
echo.

:: Check if Python is available
where python >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    :: Find server.py
    if exist "!LOGGER_CACHE_DIR!\server.py" (
        echo Server running on http://localhost:8080
        echo Press Ctrl+C to stop
        echo.
        python "!LOGGER_CACHE_DIR!\server.py"
        exit /b 0
    ) else (
        echo Downloading server from GitHub...
        call :get_logger_server_from_github
        if exist "!LOGGER_CACHE_DIR!\server.py" (
            echo Server running on http://localhost:8080
            echo Press Ctrl+C to stop
            echo.
            python "!LOGGER_CACHE_DIR!\server.py"
            exit /b 0
        )
    )
)

echo Error: Python 3 not found or server.py not available
echo.
echo To install Python 3:
echo   Visit: https://www.python.org/downloads/
echo   Or: winget install Python.Python.3.11
exit /b 1

:showhelp
    echo.
    echo install-traktor-mod.bat - Install QML mods into Traktor Pro 4 (Windows)
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
    echo   install-traktor-mod.bat                  - merge mod (default)
    echo   install-traktor-mod.bat /fresh           - reset to stock, then merge
    echo   install-traktor-mod.bat /symlink         - symlink mode (dev)
    echo   install-traktor-mod.bat /fresh /symlink  - reset, then symlink
    echo.
    echo Full Replacement Mode Usage:
    echo   install-traktor-mod.bat /full            - replace entire qml
    echo   install-traktor-mod.bat /full /symlink   - replace with symlinks (dev mode)
    echo   install-traktor-mod.bat /full /fresh     - reset stock first, then replace
    echo   install-traktor-mod.bat /full /fresh /symlink - reset, then symlink with replacement
    echo.
    echo Logger (Monitoring) Options:
    echo   install-traktor-mod.bat logger install  - install Logger.qml and Api modules
    echo   install-traktor-mod.bat logger update   - update/refresh Logger and Api from GitHub
    echo   install-traktor-mod.bat --with-logger   - include Logger with a mod install
    echo.
    echo Server Launch:
    echo   install-traktor-mod.bat server start - launch traktor-logger server on localhost:8080
    echo.
    echo Metadata Collection:
    echo   install-traktor-mod.bat enable-metadata D2,S8,X1MK3 - inject ApiModule into controllers
    echo.
    echo General Options:
    echo   install-traktor-mod.bat restore         - restore stock, remove all mods
    echo   install-traktor-mod.bat -s C:\path\to\mod - use specific directory
    echo.
    echo Help:
    echo   install-traktor-mod.bat -h              - show this help
    echo   install-traktor-mod.bat --help          - show this help
    echo   install-traktor-mod.bat /?              - show this help
    echo.
    echo Notes:
    echo   - Backup created on first install (never overwritten)
    echo   - Restore returns to stock and removes all mods/symlinks
    echo   - Symlinks use absolute paths; moving repo breaks them (run again to fix)
    echo   - Supports both 32-bit and 64-bit Traktor installations
    echo   - Logger requires Python 3 for server (get from python.org)
    echo.

:end
    echo.
    pause
    endlocal
    exit /b
