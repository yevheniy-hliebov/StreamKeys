import 'dart:io';

import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_device_service.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_macro_service.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_startup_service.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/keycodes.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:xml/xml.dart';

abstract class IHidMacrosConfig {
  Future<void> init();

  bool isConfigExists();
  Future<void> read();
  Future<void> save();

  Future<void> generateXml({
    required List<String> keyboardIds,
    KeyboardDevice? selectedKeyboard,
    KeyboardType? selectedType,
  });

  IHidMacrosDeviceService get devices;
  IHidMacrosMacroService get macros;
  IHidMacrosStartupService get startup;
}

class HidMacrosConfig implements IHidMacrosConfig {
  final KeyCodes _keyCodes;
  final String _assetsPath;
  final Future<String> Function() _getPassword;

  final XmlDocument _xml = XmlDocument();

  @override
  late final IHidMacrosDeviceService devices;
  @override
  late final IHidMacrosMacroService macros;
  @override
  late final IHidMacrosStartupService startup;

  HidMacrosConfig({
    required String assetPath,
    required KeyCodes keyCodes,
    required Future<String> Function() getPassword,
  }) : _keyCodes = keyCodes,
       _assetsPath = assetPath,
       _getPassword = getPassword {
    devices = HidMacrosDeviceService(_xml);
    macros = HidMacrosMacroService(
      xml: _xml,
      assetsPath: _assetsPath,
      keyCodes: _keyCodes,
      getPassword: _getPassword,
    );
    startup = HidMacrosStartupService(_xml);
  }

  File get _configFile => File('$_assetsPath\\hidmacros\\hidmacros.xml');

  @override
  Future<void> init() async {
    await read();
  }

  @override
  bool isConfigExists() => _configFile.existsSync();

  @override
  Future<void> read() async {
    final content = await _configFile.readAsString();
    final parsed = XmlDocument.parse(content);

    _xml.children.clear();
    _xml.children.addAll(parsed.children.map((node) => node.copy()));
  }

  @override
  Future<void> save() async {
    await _configFile.writeAsString(
      _xml.toXmlString(pretty: true, indent: '  '),
    );
  }

  @override
  Future<void> generateXml({
    required List<String> keyboardIds,
    KeyboardDevice? selectedKeyboard,
    KeyboardType? selectedType,
  }) async {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    builder.element(
      'Config',
      nest: () {
        builder.element(
          'General',
          nest: () {
            builder.element('ScriptLanguage', nest: 'VBScript');
            builder.element('MinimizeToTray', nest: '0');
            builder.element('StartMinimized', nest: '0');
          },
        );
        builder.element('Macros', nest: () {});
        builder.element('Devices');
      },
    );

    final newDoc = builder.buildDocument();

    _xml.children.clear();
    _xml.children.addAll(newDoc.children.map((node) => node.copy()));

    final devicesList = [
      for (int i = 0; i < keyboardIds.length; i++)
        KeyboardDevice('Keyb${i + 1}', keyboardIds[i].toUpperCase()),
    ];
    await devices.setDevices(devicesList);

    if (selectedKeyboard != null && selectedType != null) {
      await macros.setMacros(selectedKeyboard, selectedType);
    }
  }
}
