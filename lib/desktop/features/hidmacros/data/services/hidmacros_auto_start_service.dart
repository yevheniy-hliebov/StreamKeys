import 'package:streamkeys/service_locator.dart';

abstract class IHidMacrosAutoStartPreferences {
  Future<void> setAutoStart(bool value);
  bool getAutoStart();
}

class HidMacrosAutoStartPreferences implements IHidMacrosAutoStartPreferences {
  final SharedPreferences prefs;

  const HidMacrosAutoStartPreferences(this.prefs);

  static const _autoStartKey = 'hidmacros_auto_start';

  @override
  Future<void> setAutoStart(bool value) async {
    await prefs.setBool(_autoStartKey, value);
  }

  @override
  bool getAutoStart() {
    return prefs.getBool(_autoStartKey) ?? false;
  }
}
