@echo off
setlocal enabledelayedexpansion

:: ---------------------- General Setup ----------------------
echo [INFO] Starting build process...
SET PROJECT_PATH=%CD%
SET ICON_PATH=%PROJECT_PATH%\windows\runner\resources\app_icon.ico

:: Read version from pubspec.yaml
for /f "tokens=2 delims=: " %%v in ('findstr /b /c:"version:" "%PROJECT_PATH%\pubspec.yaml"') do set VERSION=%%v
for /f "tokens=1 delims=+" %%a in ("%VERSION%") do set VERSION=%%a
echo [INFO] Detected version: %VERSION%

SET RELEASE_PATH=%PROJECT_PATH%\build\release\windows\app-%VERSION%

:: ---------------------- Clean Previous Builds ----------------------
echo [INFO] Cleaning release folder...
IF EXIST "%PROJECT_PATH%\build\release" (
    rmdir /s /q "%PROJECT_PATH%\build\release"
    echo [OK] Release folder cleaned.
) ELSE (
    echo [INFO] No previous release folder found — skipping cleanup.
)

:: ---------------------- Build Main Application ----------------------
echo [INFO] Building main application...
call "%PROJECT_PATH%\tools\build_windows_command.bat"
IF ERRORLEVEL 1 (
    echo [ERROR] Main application build failed. Exiting...
    exit /b 1
)
echo [OK] Main application build completed.

:: ---------------------- Copy Build Files ----------------------
echo [INFO] Copying build files...
xcopy /E /Y /I "%PROJECT_PATH%\build\windows\x64\runner\Release\*" "%RELEASE_PATH%"
IF ERRORLEVEL 1 (
    echo [ERROR] Failed to copy build files.
    exit /b 1
)
echo [OK] Files copied to %RELEASE_PATH%.

:: ---------------------- Build Updater ----------------------
echo [INFO] Building updater...
call "%PROJECT_PATH%\tools\build_updater_command.bat"
IF ERRORLEVEL 1 (
    echo [ERROR] Updater build failed.
    exit /b 1
)
echo [OK] Updater build completed.

:: ---------------------- Set Icon for Updater.exe ----------------------
echo [INFO] Setting icon for Updater.exe...
"%PROJECT_PATH%\tools\rcedit.exe" "%PROJECT_PATH%\build\release\windows\Updater.exe" --set-icon "%ICON_PATH%"
IF ERRORLEVEL 1 (
    echo [ERROR] Failed to set icon on Updater.exe.
    exit /b 1
)
echo [OK] Icon set for Updater.exe.

:: ---------------------- Build Launcher ----------------------
echo [INFO] Building launcher...
call "%PROJECT_PATH%\tools\build_launcher_command.bat"
IF ERRORLEVEL 1 (
    echo [ERROR] Launcher build failed.
    exit /b 1
)
echo [OK] Launcher build completed.

:: ---------------------- Change Subsystem for EXE ----------------------
echo [INFO] Changing subsystem for streamKeys.exe...
powershell editbin /subsystem:windows "%PROJECT_PATH%\build\release\windows\StreamKeys.exe"
IF ERRORLEVEL 1 (
    echo [ERROR] Failed to change subsystem.
    exit /b 1
)
echo [OK] Subsystem changed successfully.

:: ---------------------- Set Icon for streamKeys.exe ----------------------
echo [INFO] Setting icon for StreamKeys.exe...
"%PROJECT_PATH%\tools\rcedit.exe" "%PROJECT_PATH%\build\release\windows\StreamKeys.exe" --set-icon "%ICON_PATH%"
IF ERRORLEVEL 1 (
    echo [ERROR] Failed to set icon on StreamKeys.exe.
    exit /b 1
)
echo [OK] Icon set for StreamKeys.exe.

:: ---------------------- Create ZIP Archive ----------------------
echo [INFO] Creating ZIP archive: StreamKeys-Windows.zip...
powershell Compress-Archive -Path "%PROJECT_PATH%\build\release\windows\*" -DestinationPath "%PROJECT_PATH%\build\release\StreamKeys-Windows.zip"
IF ERRORLEVEL 1 (
    echo [ERROR] Failed to create ZIP archive.
    exit /b 1
)
echo [OK] ZIP archive created successfully.

:: ---------------------- Done ----------------------
echo [SUCCESS] Build and packaging completed successfully!
exit /b 0
