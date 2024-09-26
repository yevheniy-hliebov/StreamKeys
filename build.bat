@echo off

REM Save the current directory (path to the project)
SET PROJECT_PATH=%CD%

REM Clear the build/release folder if it exists
IF EXIST "%PROJECT_PATH%\build\release" (
    rmdir /s /q "%PROJECT_PATH%\build\release"
)

REM Create a new build/release folder
mkdir "%PROJECT_PATH%\build\release"

REM Run build_apk.bat
call "%PROJECT_PATH%\build_apk.bat"

REM Check for successful completion of build_apk.bat
IF ERRORLEVEL 1 (
    echo APK build failed. Exiting...
    exit /b 1
)

REM Copy APK to build/release
copy "%PROJECT_PATH%\build\app\outputs\flutter-apk\app-release.apk" "%PROJECT_PATH%\build\release\StreamKeys-Android.apk"

REM Run build_windows.bat
call "%PROJECT_PATH%\build_windows.bat"

REM Check for successful completion of build_windows.bat
IF ERRORLEVEL 1 (
    echo Windows build failed. Exiting...
    exit /b 1
)

REM Create a ZIP archive for Windows from files in build/windows/x64/runner/Release
powershell Compress-Archive -Path "%PROJECT_PATH%\build\windows\x64\runner\Release\*.*" -DestinationPath "%PROJECT_PATH%\build\release\StreamKeys-Windows.zip"

echo Build and packaging completed successfully!
exit
