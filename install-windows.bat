@echo off
setlocal EnableDelayedExpansion

:: Check for admin rights
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :admin
) else (
    echo Requesting administrative privileges...
    goto :UACPrompt
)

:UACPrompt
    echo Set UAC = CreateObject("Shell.Application") > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:admin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

set "SOURCE_DIR=qml"
set "DEST_DIR=C:\Program Files\Native Instruments\Traktor Pro 4\Resources64"

echo This script will copy the "%SOURCE_DIR%" directory to "%DEST_DIR%".
echo Are you sure you want to proceed?
echo Type 'Y' for Yes or any other key for No:

choice /c YN /n >nul

if errorlevel 2 (
    echo Operation cancelled.
    goto :end
)

if not exist "%SOURCE_DIR%" (
    echo Error: Source directory "%SOURCE_DIR%" does not exist.
    goto :end
)

if not exist "%DEST_DIR%" (
    echo Error: Destination directory "%DEST_DIR%" does not exist.
    goto :end
)

xcopy "%SOURCE_DIR%" "%DEST_DIR%\%SOURCE_DIR%" /E /I /Y

if %ERRORLEVEL% equ 0 (
    echo Directory copied successfully.
) else (
    echo An error occurred while copying the directory.
    echo Error code: %ERRORLEVEL%
)

:end
echo.
pause
endlocal
