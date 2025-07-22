@echo off
pushd %~dp0\..
dart compile exe bin/updater.dart -o build/release/windows/Updater.exe
popd
exit