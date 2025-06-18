import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/utils/local_json_file_manager.dart';

class KeyboardMapRepository {
  late LocalJsonFileManager keyboardMapJsonFile;

  KeyboardMapRepository() {
    keyboardMapJsonFile = LocalJsonFileManager.asset(
      'keyboard_map.json',
    );
  }

  static const String functionsBlockKey = 'function_block';
  static const String mainBlockKey = 'main_block';
  static const String navigationBlockKey = 'navigation_block';
  static const String numpadBlockKey = 'numpad_block';

  Future<Map<String, KeyboardKeyBlock>> loadKeyboardMap() async {
    final Map<String, dynamic>? json = await keyboardMapJsonFile.read();
    if (json == null) return <String, KeyboardKeyBlock>{};

    KeyboardKeyBlock parseBlock(Object? blockJson) {
      final KeyboardKeyBlock result = <List<KeyboardKeyData>>[];
      if (blockJson is List) {
        for (final dynamic row in blockJson) {
          if (row is List) {
            final List<KeyboardKeyData> parsedRow =
                row.map<KeyboardKeyData>((Object? keyJson) {
              return KeyboardKeyData.fromJson(keyJson as Map<String, dynamic>);
            }).toList();
            result.add(parsedRow);
          }
        }
      }
      return result;
    }

    return <String, KeyboardKeyBlock>{
      functionsBlockKey: parseBlock(json[functionsBlockKey]),
      mainBlockKey: parseBlock(json[mainBlockKey]),
      navigationBlockKey: parseBlock(json[navigationBlockKey]),
      numpadBlockKey: parseBlock(json[numpadBlockKey]),
    };
  }
}
