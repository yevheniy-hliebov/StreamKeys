import 'dart:io';

import 'package:streamkeys/desktop/desktop_main.dart';
import 'package:streamkeys/mobile/mobile_main.dart';

void main() {
  if (Platform.isWindows) {
    desktopMain();
  } else if (Platform.isAndroid) {
    mobileMain();
  }
}
