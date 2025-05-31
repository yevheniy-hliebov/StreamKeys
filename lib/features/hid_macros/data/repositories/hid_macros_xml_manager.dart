import 'dart:io';
import 'package:streamkeys/utils/assets_helper.dart';
import 'package:xml/xml.dart';
import 'package:streamkeys/utils/hid_macros_helper.dart';
import 'package:streamkeys/utils/json_read_and_save.dart';
import 'package:streamkeys/features/hid_macros/data/models/keyboard_device.dart';
import 'package:streamkeys/features/keyboards_deck/models/keyboard_type.dart';

class HidMacrosXmlManager {
  final String filePath =
      '${{AssetsHelper.assetsFolderPath}}\\hid_macros\\hidmacros.xml';
  final String clickScriptPath =
      '${{AssetsHelper.assetsFolderPath}}\\keyboard_click.cjs';
  XmlDocument? xml;

  Future<void> load() async {
    final content = await File(filePath).readAsString();
    xml = XmlDocument.parse(content);
  }

  Future<void> save() async {
    bool isRunning = await HidMacrosHelper.isRunning();
    if (isRunning) await HidMacrosHelper.stop();

    await File(filePath)
        .writeAsString(xml!.toXmlString(pretty: true, indent: '  '));

    if (!await HidMacrosHelper.isRunning()) await HidMacrosHelper.start();
  }

  List<KeyboardDevice> getDevices() {
    final devicesXml = xml!.findAllElements('Devices').first;
    return devicesXml.findAllElements('Keyboard').map((k) {
      final name = k.findElements('Name').first.innerText;
      final id = k.findElements('SystemID').first.innerText;
      return KeyboardDevice(name, id);
    }).toList();
  }

  void updateKeyboardName(String systemId, String newName) {
    final devicesXml = xml!.findAllElements('Devices').first;
    final keyboard = devicesXml.findAllElements('Keyboard').firstWhere(
          (k) => k.findElements('SystemID').first.innerText == systemId,
          orElse: () => throw Exception('Keyboard not found'),
        );
    keyboard.findElements('Name').first.innerText = newName;
  }

  void assignDeviceToMacros(String name) {
    for (var macro in xml!.findAllElements('Macro')) {
      macro.findElements('Device').first.innerText = name;
    }
  }

  Future<void> regenerateMacros(
      KeyboardDevice keyboard, KeyboardType type) async {
    final macrosXml = xml!.findAllElements('Macros').first;
    macrosXml.children.clear();
    final codes = await _getKeyCodes(type);
    for (var code in codes) {
      macrosXml.children.add(_createMacro(code, keyboard.name));
    }
  }

  Future<List<int>> _getKeyCodes(KeyboardType type) async {
    final helper = JsonHelper.asset('key_code.json');
    final json = await helper.read();
    if (json == null) return [];

    List<int> codes = [];
    if ([KeyboardType.full, KeyboardType.compact].contains(type)) {
      codes
        ..addAll(List<int>.from(json['function_row']))
        ..addAll(List<int>.from(json['main_block']))
        ..addAll(List<int>.from(json['navigation_block']));
    }
    if ([KeyboardType.full, KeyboardType.numpad].contains(type)) {
      codes.addAll(List<int>.from(json['numpad']));
    }
    return codes;
  }

  XmlElement _createMacro(int code, String name) {
    final script = 'Set objShell = CreateObject("WScript.Shell")\n'
        'objShell.Run "node $clickScriptPath $code", 0';

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
