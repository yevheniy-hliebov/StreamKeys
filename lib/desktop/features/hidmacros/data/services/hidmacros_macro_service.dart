import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/keycodes.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/desktop/server/server.dart';
import 'package:xml/xml.dart';

abstract class IHidMacrosMacroService {
  Future<void> setMacros(KeyboardDevice keyboard, KeyboardType type);
  Future<void> updatePasswordInMacros(String password);
}

class HidMacrosMacroService implements IHidMacrosMacroService {
  final XmlDocument _xml;
  final String _assetsPath;
  final KeyCodes _keyCodes;
  final Future<String> Function() _getPassword;

  HidMacrosMacroService({
    required XmlDocument xml,
    required String assetsPath,
    required KeyCodes keyCodes,
    required Future<String> Function() getPassword,
  }) : _getPassword = getPassword,
       _keyCodes = keyCodes,
       _assetsPath = assetsPath,
       _xml = xml;

  @override
  Future<void> setMacros(KeyboardDevice keyboard, KeyboardType type) async {
    final macrosXml = _xml.findAllElements('Macros').firstOrNull;
    if (macrosXml == null) return;
    macrosXml.children.clear();
    final codes = _keyCodes.getList(type);
    final password = await _getPassword();
    for (final code in codes) {
      macrosXml.children.add(_createMacro(password, code, keyboard.name));
    }
  }

  @override
  Future<void> updatePasswordInMacros(String password) async {
    final macros = _xml.findAllElements('Macro');
    for (final macro in macros) {
      final script = macro.getElement('ScriptSource');
      final cdata = script?.children.whereType<XmlCDATA>().firstOrNull;
      if (cdata == null) continue;
      final oldScript = cdata.value;
      final updatedScript = oldScript.replaceAllMapped(
        RegExp(r'(X-Api-Password",\s*")(.+?)(")'),
        (m) => '${m.group(1)}$password${m.group(3)}',
      );
      if (updatedScript != oldScript) {
        script!.children
          ..clear()
          ..add(XmlCDATA(updatedScript));
      }
    }
  }

  XmlElement _createMacro(String password, int code, String name) {
    final script =
        'Set shell = CreateObject("WScript.Shell")\n'
        'shell.Run """$_assetsPath\\click_button.exe"" $code $password ${Server.port}", 0, False';

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
