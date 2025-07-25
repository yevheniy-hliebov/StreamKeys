import 'dart:io';
import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/desktop/server/server.dart';
import 'package:streamkeys/desktop/utils/local_json_file_manager.dart';
import 'package:xml/xml.dart';
import 'package:streamkeys/desktop/utils/helper_functions.dart';

class HidMacrosXmlService {
  HidMacrosXmlService._internal();

  static final HidMacrosXmlService _instance = HidMacrosXmlService._internal();

  factory HidMacrosXmlService() => _instance;

  static const xmlFileName = 'hidmacros.xml';
  static String assetsPath = HelperFunctions.getAssetsFolderPath();
  static String filePath = '$assetsPath\\hidmacros\\$xmlFileName';

  late XmlDocument xml;
  List<int>? keyCodes;
  KeyboardType keyboardType = KeyboardType.full;

  bool get isConfigExists {
    final configFile = File(filePath);
    return configFile.existsSync();
  }

  Future<void> read() async {
    final content = await File(filePath).readAsString();
    xml = XmlDocument.parse(content);
  }

  Future<void> save() async {
    await File(
      filePath,
    ).writeAsString(xml.toXmlString(pretty: true, indent: '  '));
  }

  void setMinimizeToTray(bool enabled) {
    final generalElement = xml.findAllElements('General').firstOrNull;
    if (generalElement == null) return;

    final element = generalElement.findElements('MinimizeToTray').firstOrNull;
    if (element != null) {
      element.innerText = enabled ? '1' : '0';
    } else {
      generalElement.children.add(
        XmlElement(XmlName('MinimizeToTray'), [], [
          XmlText(enabled ? '1' : '0'),
        ]),
      );
    }
  }

  bool getMinimizeToTray() {
    final generalElement = xml.findAllElements('General').firstOrNull;
    if (generalElement == null) return false;

    final element = generalElement.findElements('MinimizeToTray').firstOrNull;
    return element?.innerText.trim() == '1';
  }

  void setStartMinimized(bool enabled) {
    final generalElement = xml.findAllElements('General').firstOrNull;
    if (generalElement == null) return;

    final element = generalElement.findElements('StartMinimized').firstOrNull;
    if (element != null) {
      element.innerText = enabled ? '1' : '0';
    } else {
      generalElement.children.add(
        XmlElement(XmlName('StartMinimized'), [], [
          XmlText(enabled ? '1' : '0'),
        ]),
      );
    }
  }

  bool getStartMinimized() {
    final generalElement = xml.findAllElements('General').firstOrNull;
    if (generalElement == null) return false;

    final element = generalElement.findElements('StartMinimized').firstOrNull;
    return element?.innerText.trim() == '1';
  }

  List<KeyboardDevice> getDevices() {
    final devicesXml = xml.findAllElements('Devices').first;
    return devicesXml.findAllElements('Keyboard').map((k) {
      final name = k.findElements('Name').first.innerText;
      final id = k.findElements('SystemID').first.innerText;
      return KeyboardDevice(name, id);
    }).toList();
  }

  Future<void> regenerateMacros({
    required KeyboardDevice keyboard,
    required KeyboardType type,
    required String apiPassword,
  }) async {
    final macrosXml = xml.findAllElements('Macros').first;
    macrosXml.children.clear();

    final codes = type == keyboardType
        ? keyCodes ?? await _getKeyCodes(type)
        : await _getKeyCodes(type);

    for (var code in codes) {
      macrosXml.children.add(_createMacro(apiPassword, code, keyboard.name));
    }
  }

  void updateApiPassword(String newPassword) {
    final macros = xml.findAllElements('Macro');

    for (final macro in macros) {
      final scriptSource = macro.getElement('ScriptSource');
      if (scriptSource == null) continue;

      final cdataNode = scriptSource.children.whereType<XmlCDATA>().firstOrNull;

      if (cdataNode == null) continue;

      final oldScript = cdataNode.value;

      final updatedScript = oldScript.replaceAllMapped(
        RegExp(r'(X-Api-Password",\s*")(.+?)(")'),
        (match) => '${match.group(1)}$newPassword${match.group(3)}',
      );

      if (updatedScript == oldScript) continue;

      scriptSource.children
        ..clear()
        ..add(XmlCDATA(updatedScript));
    }
  }

  Future<List<int>> _getKeyCodes(KeyboardType type) async {
    final helper = LocalJsonFileManager.asset('keyboard_key_codes.json');
    final json = await helper.read();
    if (json == null) return [];

    final List<int> codes = [];
    if ([KeyboardType.full, KeyboardType.compact].contains(type)) {
      codes
        ..addAll(List<int>.from(json['function_block']))
        ..addAll(List<int>.from(json['main_block']))
        ..addAll(List<int>.from(json['navigation_block']));
    }
    if ([KeyboardType.full, KeyboardType.numpad].contains(type)) {
      codes.addAll(List<int>.from(json['numpad']));
    }
    return codes;
  }

  XmlElement _createMacro(String apiPassword, int code, String name) {
    final script =
        'Set shell = CreateObject("WScript.Shell")\n'
        'shell.Run """$assetsPath\\click_button.exe"" $code $apiPassword ${Server.port}", 0, False';

    return XmlElement(XmlName('Macro'), [], [
      XmlElement(XmlName('Device'), [], [XmlText(name)]),
      XmlElement(XmlName('Name'), [], [XmlText('Macro $code')]),
      XmlElement(XmlName('KeyCode'), [], [XmlText(code.toString())]),
      XmlElement(XmlName('Direction'), [], [XmlText('down')]),
      XmlElement(XmlName('Action'), [], [XmlText('SCR')]),
      XmlElement(XmlName('Sequence')),
      XmlElement(XmlName('SCEvent')),
      XmlElement(XmlName('XPLCommand')),
      XmlElement(XmlName('ScriptSource'), [], [XmlCDATA(script)]),
      XmlElement(XmlName('SCText'), [], [XmlText('0')]),
      XmlElement(XmlName('Command')),
    ]);
  }
}
