import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:xml/xml.dart';

abstract class IHidMacrosDeviceService {
  Future<List<KeyboardDevice>> getDevices();
  Future<void> setDevices(List<KeyboardDevice> devices);
  Future<void> renameKeyboard(KeyboardDevice keyboard, String newName);
}

class HidMacrosDeviceService implements IHidMacrosDeviceService {
  final XmlDocument xml;

  HidMacrosDeviceService(this.xml);

  @override
  Future<List<KeyboardDevice>> getDevices() async {
    final devicesXml = xml.findAllElements('Devices').firstOrNull;
    if (devicesXml == null) return [];
    return devicesXml.findAllElements('Keyboard').map((k) {
      final name = k.findElements('Name').firstOrNull?.innerText ?? '';
      final id = k.findElements('SystemID').firstOrNull?.innerText ?? '';
      return KeyboardDevice(name, id);
    }).toList();
  }

  @override
  Future<void> setDevices(List<KeyboardDevice> devices) async {
    final XmlElement devicesXml =
        xml.findAllElements('Devices').firstOrNull ??
        XmlElement(XmlName('Devices'));
    devicesXml.children.clear();
    for (final device in devices) {
      devicesXml.children.add(
        XmlElement(XmlName('Keyboard'), [], [
          XmlElement(XmlName('Name'), [], [XmlText(device.name)]),
          XmlElement(XmlName('SystemID'), [], [XmlText(device.systemId)]),
        ]),
      );
    }
    if (xml.findAllElements('Devices').isEmpty) {
      xml.rootElement.children.add(devicesXml);
    }
  }

  @override
  Future<void> renameKeyboard(KeyboardDevice keyboard, String newName) async {
    final devicesXml = xml.findAllElements('Devices').firstOrNull;
    if (devicesXml == null) return;
    for (final k in devicesXml.findAllElements('Keyboard')) {
      final id = k.findElements('SystemID').firstOrNull?.innerText;
      if (id == keyboard.systemId) {
        final nameElement = k.findElements('Name').firstOrNull;
        if (nameElement != null) {
          nameElement.innerText = newName;
        } else {
          k.children.add(XmlElement(XmlName('Name'), [], [XmlText(newName)]));
        }
        break;
      }
    }

    final macros = xml.findAllElements('Macro');
    for (final macro in macros) {
      final deviceElement = macro.getElement('Device');
      if (deviceElement != null) {
        deviceElement.innerText = newName;
      }
    }
  }
}
