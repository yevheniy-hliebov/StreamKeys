import 'dart:io';
import 'package:streamkeys/run_windows_app.dart';

void main() async {
  if (Platform.isWindows) {
    await runWindowsApp();
  }
}
