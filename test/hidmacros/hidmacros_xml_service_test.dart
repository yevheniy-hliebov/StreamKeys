import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_xml_service.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:xml/xml.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HidMacrosXmlService service;
  late File tempFile;

  setUp(() async {
    const testXml = '''
<Root>
  <General>
    <MinimizeToTray>1</MinimizeToTray>
    <StartMinimized>0</StartMinimized>
  </General>
  <Devices>
    <Keyboard>
      <Name>Test Keyboard</Name>
      <SystemID>usb://123</SystemID>
    </Keyboard>
  </Devices>
  <Macros></Macros>
</Root>
''';

    final dir = Directory.systemTemp.createTempSync();
    final testFile = File('${dir.path}/hidmacros.xml');
    await testFile.writeAsString(testXml);
    HidMacrosXmlService.filePath = testFile.path;

    service = HidMacrosXmlService();
    await service.read();

    tempFile = testFile;
  });

  tearDown(() {
    tempFile.deleteSync();
  });

  group('HidMacrosXmlService', () {
    test('isConfigExists returns true if file exists', () {
      expect(service.isConfigExists, isTrue);
    });

    test('getDevices returns parsed keyboard devices', () {
      final devices = service.getDevices();
      expect(devices, hasLength(1));
      expect(devices.first.name, 'Test Keyboard');
      expect(devices.first.systemId, 'usb://123');
    });

    test('getMinimizeToTray returns true', () {
      expect(service.getMinimizeToTray(), isTrue);
    });

    test('getStartMinimized returns false', () {
      expect(service.getStartMinimized(), isFalse);
    });

    test('setMinimizeToTray changes value', () {
      service.setMinimizeToTray(false);
      expect(service.getMinimizeToTray(), isFalse);

      service.setMinimizeToTray(true);
      expect(service.getMinimizeToTray(), isTrue);
    });

    test('setStartMinimized changes value', () {
      service.setStartMinimized(true);
      expect(service.getStartMinimized(), isTrue);

      service.setStartMinimized(false);
      expect(service.getStartMinimized(), isFalse);
    });

    test('save writes updated xml to file', () async {
      service.setMinimizeToTray(false);
      await service.save();

      final reloaded = await File(tempFile.path).readAsString();
      expect(reloaded.contains('<MinimizeToTray>0</MinimizeToTray>'), isTrue);
    });

    test('regenerateMacros adds macro elements', () async {
      const keyboard = KeyboardDevice('Test Keyboard', '12345');
      const type = KeyboardType.full;

      await service.regenerateMacros(
        keyboard: keyboard,
        type: type,
        apiPassword: 'test-password',
      );

      final macrosElement = service.xml.findAllElements('Macros').first;
      final macros = macrosElement.findElements('Macro').toList();

      expect(macros, isNotEmpty);

      final firstMacro = macros.first;
      expect(firstMacro.findElements('Device').first.innerText,
          equals('Test Keyboard'));
      expect(firstMacro.findElements('Name').first.innerText, contains('Macro'));
      expect(firstMacro.findElements('KeyCode').first.innerText, isNotEmpty);
      expect(firstMacro.findElements('ScriptSource').first.innerText,
          contains('X-Api-Password", "test-password'));
    });
  });
}
