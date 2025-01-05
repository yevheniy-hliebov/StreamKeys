// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/keyboard/keyboard_device.dart';
import 'package:streamkeys/windows/models/keyboard/keyboard_map.dart';
import 'package:streamkeys/windows/models/typedefs.dart';
import 'package:streamkeys/windows/server/server.dart';
import 'package:streamkeys/windows/services/file_picker_service.dart';
import 'package:streamkeys/windows/services/keyboard_deck_service.dart';
import 'package:xml/xml.dart';

class HidmacrosIntegrationProvider extends ChangeNotifier {
  late TextEditingController filePathController = TextEditingController();
  String filePath = '';

  final KeyboardDeckService _service = KeyboardDeckService();

  List<KeyboardDevice> keyboards = [];
  KeyboardDevice selectedKeyboard = KeyboardDevice('', '');

  bool _mounted = true;
  bool get mounted => _mounted;

  List<String> keyboardTypes = [
    'full',
    'compact',
    'numpad',
  ];
  String selectedKeyboardType = 'full';

  HidmacrosIntegrationProvider() {
    init();
  }

  FutureVoid init() async {
    await _service.init();
    filePath = _service.jsonData['hidmarcors_xml_path'] ?? '';
    filePathController.text = filePath;
    filePathController.addListener(
      () {
        filePath = filePathController.text;
        _service.jsonData['hidmarcors_xml_path'] = filePath;
        _service.saveData();
        if (mounted) {
          notifyListeners();
        }
      },
    );

    await getListKeyboard();

    selectedKeyboardType = _service.jsonData['selected_keyboard_type'];
    if (mounted) {
      notifyListeners();
    }
  }

  FutureVoid getListKeyboard() async {
    if (filePath.isNotEmpty) {
      keyboards = await _listKeyboards();

      if (_service.jsonData['selected_keyboard'] == null &&
          keyboards.isNotEmpty) {
        selectedKeyboard = keyboards.first;
      } else if (_service.jsonData['selected_keyboard'] != null) {
        selectedKeyboard = KeyboardDevice.fromJson(
          _service.jsonData['selected_keyboard'],
        );
      }
      _service.jsonData['selected_keyboard'] = selectedKeyboard.toJson();
      _service.saveData();
    }
  }

  Future<void> selectKeyboard(KeyboardDevice keyboardDevice) async {
    selectedKeyboard = keyboardDevice;
    _service.selectKeyboard(keyboardDevice.toJson());
    notifyListeners();
  }

  Future<void> selectKeyboardType(String type) async {
    selectedKeyboardType = type;
    _service.selectKeyboardType(type);
    notifyListeners();
  }

  Future<void> pickFile() async {
    final path = await FilePickerService.pickFile();
    if (path != null) {
      filePath = path;
      filePathController.text = path;

      await getListKeyboard();
      notifyListeners();
    }
  }

  Future<void> createKeysHandlerVBS() async {
    final directory = Directory(
      '${Platform.environment['APPDATA']}\\StreamKeys\\keysHandlerVBS',
    );

    List<int> keyCodes = await _codeList();

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    for (int buttonCode in keyCodes) {
      final vbsFile = File('${directory.path}\\button$buttonCode.vbs');
      await vbsFile.writeAsString('''
Set objShell = CreateObject("WScript.Shell")
objShell.Run "node _action.cjs $buttonCode", 0
    ''');

      if (kDebugMode) {
        if (const bool.fromEnvironment('dart.vm.product') == false) {
          print('VBS script created: ${vbsFile.path}');
        }
      }
    }

    final cjsFile = File('${directory.path}\\_action.cjs');
    await cjsFile.writeAsString('''
const http = require('http');

const buttonCode = process.argv[2]; // Отримуємо параметр buttonCode з аргументів командного рядка

const options = {
  hostname: 'localhost',
  port: ${Server.port},
  path: `/keyboard/\${buttonCode}/click`,
  method: 'GET'
};

const req = http.request(options, (res) => {
  let data = '';
  res.on('data', (chunk) => {
    data += chunk;
  });
  res.on('end', () => {
    console.log(`Response: \${data}`);
  });
});

req.on('error', (e) => {
  console.error(`Problem with request: \${e.message}`);
});

req.end();
  ''');

    if (kDebugMode) {
      if (const bool.fromEnvironment('dart.vm.product') == false) {
        print('CJS script created: ${cjsFile.path}');
      }
    }
  }

  Future<void> updateConfigFile(
    String keyboardSystemId,
  ) async {
    if (filePath.isNotEmpty) {
      final file = File(filePath);
      String xmlContent = await file.readAsString();

      final document = XmlDocument.parse(xmlContent);

      String? deviceName;

      for (var device in document.findAllElements('Devices').first.children) {
        if (device is XmlElement && device.name.local == 'Keyboard') {
          String systemId = device.findElements('SystemID').first.text;

          if (systemId == keyboardSystemId) {
            deviceName = device.findElements('Name').first.text;
          }
        }
      }

      if (deviceName == null) {
        if (kDebugMode) {
          print('Device with SystemID $keyboardSystemId not found.');
        }
        return;
      }

      final macros = document.findAllElements('Macros').first;
      macros.children.clear();

      List<int> keyCodes = await _codeList();

      final directoryVBSFiles = Directory(
        '${Platform.environment['APPDATA']}\\StreamKeys\\keysHandlerVBS',
      );
      if (kDebugMode) {
        print(directoryVBSFiles.path);
      }
      for (var keyCode in keyCodes) {
        final macroElement = XmlElement(XmlName('Macro'), [], [
          XmlElement(XmlName('Device'), [], [XmlText(deviceName)]),
          XmlElement(XmlName('Name'), [], [XmlText('Macro $keyCode')]),
          XmlElement(XmlName('KeyCode'), [], [XmlText('$keyCode')]),
          XmlElement(XmlName('Direction'), [], [XmlText('down')]),
          XmlElement(XmlName('Action'), [], [XmlText('CMD')]),
          XmlElement(XmlName('Sequence'), [], []),
          XmlElement(XmlName('SCEvent'), [], []),
          XmlElement(XmlName('XPLCommand'), [], []),
          XmlElement(XmlName('ScriptSource'), [], []),
          XmlElement(XmlName('SCText'), [], [XmlText('0')]),
          XmlElement(XmlName('Command'), [], [
            XmlText('${directoryVBSFiles.path}\\button$keyCode.vbs'),
          ]),
        ]);
        macros.children.add(macroElement);
      }

      final updatedXmlContent = document.toXmlString(pretty: true);
      await file.writeAsString(updatedXmlContent);

      if (const bool.fromEnvironment('dart.vm.product') == false) {
        if (kDebugMode) {
          print('Config file updated at $filePath');
        }
      }
    }
  }

  Future<List<KeyboardDevice>> _listKeyboards() async {
    final String? filePath = _service.jsonData['hidmarcors_xml_path'];

    if (filePath == null || filePath.isEmpty) {
      return [];
    }

    final file = File(filePath);
    String xmlContent = await file.readAsString();
    final document = XmlDocument.parse(xmlContent);

    final devices = document.findAllElements('Devices').first;
    return devices.findAllElements('Keyboard').map(
      (keyboard) {
        final name = keyboard.findElements('Name').first.text;
        final systemId = keyboard.findElements('SystemID').first.text;
        return KeyboardDevice(name, systemId);
      },
    ).toList();
  }

  Future<List<int>> _codeList() async {
    final mapData = await _service.getKeyboardMap();
    if (mapData != null) {
      final keyboardMap = KeyboardMap.fromJson(mapData);
      if (selectedKeyboardType == 'numpad') {
        return keyboardMap.numpadListCodes;
      } else if (selectedKeyboardType == 'compact') {
        return keyboardMap.compactKeyboardListCodes;
      } else {
        return keyboardMap.fullKeyboardlistCodes;
      }
    }
    return [];
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
