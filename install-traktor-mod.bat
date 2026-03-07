@echo off
setlocal enabledelayedexpansion

:: ============================================================
:: install-traktor-mod.bat — Install a QML overlay mod into Traktor Pro 4 (Windows)
::
:: Usage (double-click or run from Command Prompt):
::   install-traktor-mod.bat                          — merge mod on top of current live qml (stack mode)
::   install-traktor-mod.bat /fresh                   — restore stock first, then merge mod (clean mode)
::   install-traktor-mod.bat /symlink                 — symlink mod files into live qml (dev mode)
::   install-traktor-mod.bat /fresh /symlink          — restore stock first, then symlink mod files
::   install-traktor-mod.bat /full                    — replace entire qml with complete mod (full replacement)
::   install-traktor-mod.bat /full /symlink           — symlink complete mod (full replacement dev mode)
::   install-traktor-mod.bat /full /fresh             — restore stock first, then replace entire qml
::   install-traktor-mod.bat /full /fresh /symlink    — restore stock, then symlink complete mod
::   install-traktor-mod.bat restore                  — restore stock qml and remove all mods/symlinks
::
:: Specifying source directory (optional; defaults to current directory):
::   install-traktor-mod.bat -s C:\path\to\mod       — use specific directory
::   install-traktor-mod.bat --source ..\my-mod      — use subdirectory, relative path
::   install-traktor-mod.bat -s C:\mods\mod /fresh   — use custom directory, fresh mode
::
:: Stack mode (default): copies overlay mod files into Traktor's live qml. Other installed mods stay.
::
:: Fresh mode (/fresh): resets qml to stock first, then applies only this mod.
::
:: Symlink mode (/symlink): creates symlinks in Traktor's qml pointing back to the files
:: in this mod repo. Edit a file in your repo and restart Traktor — no reinstall needed.
:: Useful during active development. Combine with /fresh for an isolated dev environment.
:: Works with both overlay mods and complete mods (/full).
:: Note: symlinks use absolute paths; moving this repo will break them (run again to fix).
::
:: Full replacement mode (/full): replaces Traktor's entire qml with this complete mod.
:: Use only for standalone complete mods not meant to combine with other mods.
:: Combine with /symlink for development mode with complete mods.
:: WARNING: Other installed mods will be overwritten.
::
:: Restore: replaces the live qml with the stock backup, removing ALL mods and symlinks.
:: There is no "undo just this mod" — restore always goes back to stock.
::
:: The stock backup is created on first install and never overwritten. After 'restore' the
:: backup is removed (moved back to qml), so the next install creates a fresh one.
::
:: Install this script to your PATH once, then use it from any mod directory.
:: See 08_SHARING_CHANGES.md for setup instructions.
:: ============================================================

:: Check for admin rights and re-launch elevated if needed, forwarding all args
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :admin
) else (
    echo Requesting administrative privileges...
    goto :UACPrompt
)

:UACPrompt
    set "ELEV_ARGS=%*"
    set "ELEV_ARGS=!ELEV_ARGS:"=""!"
    echo Set UAC = CreateObject("Shell.Application") > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~f0", "!ELEV_ARGS!", "%CD%", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:admin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║ WARNING: This script (install-traktor-mod.bat) is not yet tested ║
echo ║ Feedback and bug reports appreciated at:                        ║
echo ║ https://github.com/lsmith77/traktor-kontrol-qml/issues          ║
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

:: --- initialize variables ---

set "SOURCE_DIR=."
set "MOD_QML=.\qml"
set "FRESH=false"
set "SYMLINK=false"
set "FULL=false"
set "MODE=install"
set "NEXT_IS_SOURCE=false"

:: --- parse arguments ---

for %%A in (%*) do (
    if "!NEXT_IS_SOURCE!"=="true" (
        if "%%A"=="" (
            echo Error: -s/--source requires a directory path to follow
            goto :end
        )
        if "%%A:~0,1"=="/" (
            echo Error: -s/--source requires a directory path, not a flag: %%A
            goto :end
        )
        if "%%A:~0,1"=="-" (
            echo Error: -s/--source requires a directory path, not a flag: %%A
            goto :end
        )
        if not exist "%%A" (
            echo Error: Source directory not found: %%A
            goto :end
        )
        for /f "delims=" %%D in ('cd /d "%%A" 2^>nul ^&^& cd') do set "SOURCE_DIR=%%D"
        set "MOD_QML=!SOURCE_DIR!\qml"
        set "NEXT_IS_SOURCE=false"
    ) else if /I "%%A"=="-s" (
        set "NEXT_IS_SOURCE=true"
    ) else if /I "%%A"=="--source" (
        set "NEXT_IS_SOURCE=true"
    ) else if /I "%%A"=="/fresh" (
        set "FRESH=true"
    ) else if /I "%%A"=="--fresh" (
        set "FRESH=true"
    ) else if /I "%%A"=="/symlink" (
        set "SYMLINK=true"
    ) else if /I "%%A"=="--symlink" (
        set "SYMLINK=true"
    ) else if /I "%%A"=="/full" (
        set "FULL=true"
    ) else if /I "%%A"=="--full" (
        set "FULL=true"
    ) else if /I "%%A"=="restore" (
        set "MODE=restore"
    ) else (
        echo Error: Unknown argument: %%A
        goto :end
    )
)

if "!NEXT_IS_SOURCE!"=="true" (
    echo Error: -s/--source requires a directory path to follow
    goto :end
)

:: --- restore mode ---

if "!MODE!"=="restore" (
    if not exist "!TRAKTOR_QML!" (
        echo Error: Traktor Pro 4 not found at expected path.
        echo   Expected: !TRAKTOR_QML!
        echo   If Traktor is installed elsewhere, edit TRAKTOR_RESOURCES in this script.
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
        echo   Try closing Traktor and running restore again.
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

:: --- install mode ---

:: Check Traktor is installed
if not exist "!TRAKTOR_QML!" (
    echo Error: Traktor Pro 4 not found at expected path.
    echo   Expected: !TRAKTOR_QML!
    echo   If Traktor is installed elsewhere, edit TRAKTOR_RESOURCES in this script.
    goto :end
)

:: Check mod has qml folder
if not exist "!MOD_QML!" (
    if exist "!SOURCE_DIR!" (
        echo Error: No 'qml' folder found.
        echo   Source: !SOURCE_DIR!
        echo   Looking for: !MOD_QML!
        echo   The mod directory must contain a 'qml' subfolder with your changes.
    ) else (
        echo Error: Source directory not found.
        echo   Source: !SOURCE_DIR!
    )
    goto :end
)

:: Create backup on first install (only when it doesn't exist yet)
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

:: In fresh mode, reset live qml to stock before applying
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
    :: Resolve MOD_QML to absolute path for proper symlink operations
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
    :: Resolve MOD_QML to absolute path for proper symlink operations
    for /f "delims=" %%P in ('cd /d "!MOD_QML!" 2^>nul ^&^& cd') do set "MOD_QML_ABS=%%P"
    if not defined MOD_QML_ABS (
        echo Error: Could not resolve mod source path: !MOD_QML!
        goto :end
    )
    echo Installing mod (symlinking overlay files into Traktor qml)...
    for /R "!MOD_QML_ABS!" %%F in (*) do (
        set "FULL=%%F"
        set "REL=!FULL:!MOD_QML_ABS!\=!"
        set "DST=!TRAKTOR_QML!\!REL!"
        for %%D in ("!DST!") do (
            if not exist "%%~dpD" mkdir "%%~dpD"
        )
        if exist "!DST!" del "!DST!" 2>nul
        mklink "!DST!" "%%F" >nul 2>&1
        if !ERRORLEVEL! NEQ 0 (
            echo Warning: Could not create symlink for !REL!
        )
    )
    echo Done.
    echo.
    echo Symlinks point to: !MOD_QML_ABS!
    echo Edit files there and restart Traktor — no reinstall needed.
) else (
    echo Installing mod (merging overlay into Traktor qml)...
    robocopy "!MOD_QML!" "!TRAKTOR_QML!" /E /NFL /NDL /NJH /NJS >nul
    if !ERRORLEVEL! LEQ 7 (
        echo Done.
    ) else (
        echo Error: An error occurred while copying the mod files.
        echo   Error code: !ERRORLEVEL!
        goto :end
    )
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
    echo General Options:
    echo   install-traktor-mod.bat restore          - restore stock, remove all mods
    echo   install-traktor-mod.bat -s C:\path\to\mod         - use specific directory
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
    echo.

:end
    echo.
    pause
    endlocal
    exit /b
