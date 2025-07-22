@echo off
pushd %~dp0\..
dart compile exe bin/launcher.dart -o build/release/windows/StreamKeys.exe
popd
exit