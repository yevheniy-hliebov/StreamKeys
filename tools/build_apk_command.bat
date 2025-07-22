@echo off
pushd %~dp0\..
flutter build apk
popd
exit