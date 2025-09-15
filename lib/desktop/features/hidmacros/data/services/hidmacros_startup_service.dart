import 'package:streamkeys/desktop/features/hidmacros/data/models/hidmacros_startup_options.dart';
import 'package:xml/xml.dart';

abstract class IHidMacrosStartupService {
  Future<HidMacrosStartupOptions> getStartupOptions();
  Future<void> setStartupOptions(HidMacrosStartupOptions options);
}

class HidMacrosStartupService implements IHidMacrosStartupService {
  final XmlDocument xml;

  HidMacrosStartupService(this.xml);

  @override
  Future<HidMacrosStartupOptions> getStartupOptions() async {
    final general = xml.findAllElements('General').firstOrNull;
    if (general == null) return const HidMacrosStartupOptions();
    bool getOption(String name) =>
        general.findElements(name).firstOrNull?.innerText.trim() == '1';
    return HidMacrosStartupOptions(
      minimizeToTray: getOption('MinimizeToTray'),
      startMinimized: getOption('StartMinimized'),
    );
  }

  @override
  Future<void> setStartupOptions(HidMacrosStartupOptions options) async {
    void setOption(String name, bool enabled) {
      final general = xml.findAllElements('General').firstOrNull;
      if (general == null) return;
      final element = general.findElements(name).firstOrNull;
      final text = enabled ? '1' : '0';
      if (element != null) {
        element.innerText = text;
      } else {
        general.children.add(XmlElement(XmlName(name), [], [XmlText(text)]));
      }
    }

    setOption('MinimizeToTray', options.minimizeToTray);
    setOption('StartMinimized', options.startMinimized);
  }
}
