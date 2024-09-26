import 'dart:io';

import 'package:streamkeys/android/run_android_app.dart';
import 'package:streamkeys/windows/run_windows_app.dart';

void main() {
  if (Platform.isWindows) {
    runWindowsApp();
  } else {
    runAndroidApp();
  }
}
