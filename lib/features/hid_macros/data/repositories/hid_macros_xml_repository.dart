import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/hid_macros/data/models/keyboard_device.dart';
import 'package:streamkeys/utils/hid_macros_helper.dart';
import 'package:streamkeys/features/keyboards_deck/models/keyboard_type.dart';
import 'package:xml/xml.dart';

class HidMacrosRepository {
  final file = File('${HidMacrosHelper.folderPath}\\hidmacros.xml');

  XmlDocument? xml;

  FutureVoid read() async {
    String xmlContent = await file.readAsString();
    xml = XmlDocument.parse(xmlContent);
  }

  Future<List<KeyboardDevice>> getDeviceList() async {
    if (xml == null) {
      await read();
    }

    if (xml == null) return [];

    final devicesXml = xml!.findAllElements('Devices').first;
    return devicesXml.findAllElements('Keyboard').map(
      (keyboard) {
        final name = keyboard.findElements('Name').first.innerText;
        final systemId = keyboard.findElements('SystemID').first.innerText;
        return KeyboardDevice(name, systemId);
      },
    ).toList();
  }

  FutureVoid updateKeyboardName(String systemId, String newName) async {
    if (xml == null) {
      await read();
    }

    if (xml == null) return;

    final devicesXml = xml!.findAllElements('Devices').first;
    final keyboards = devicesXml.findAllElements('Keyboard');

    final keyboard = keyboards.firstWhere(
      (k) => k.findElements('SystemID').first.innerText == systemId,
      orElse: () =>
          throw Exception('Keyboard with systemId $systemId not found'),
    );

    final nameElement = keyboard.findElements('Name').first;
    nameElement.innerText = newName;

    await file.writeAsString(xml!.toXmlString(pretty: true, indent: '  '));
  }

  FutureVoid saveSelectedKeyboard(String systemId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_keyboard', systemId);
  }

  Future<String?> getSelectedKeyboard() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_keyboard');
  }

  FutureVoid saveSelectedKeyboardType(KeyboardType keyboardType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_keyboard_type', keyboardType.name);
  }

  Future<KeyboardType> getSelectedKeyboardType() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('selected_keyboard_type');
    if (value == KeyboardType.numpad.name) {
      return KeyboardType.numpad;
    } else if (value == KeyboardType.compact.name) {
      return KeyboardType.compact;
    } else {
      return KeyboardType.full;
    }
  }
}
