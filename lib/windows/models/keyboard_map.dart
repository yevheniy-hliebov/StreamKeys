import 'package:streamkeys/windows/models/keyboard_key.dart';
import 'package:streamkeys/windows/models/typedefs.dart';

class KeyboardMap {
  final List<KeyboardKey> functionRow;
  final List<List<KeyboardKey>> mainBlock;
  final List<List<KeyboardKey>> navigationBlock;
  final List<List<KeyboardKey>> numpad;

  const KeyboardMap({
    required this.functionRow,
    required this.mainBlock,
    required this.navigationBlock,
    required this.numpad,
  });

  factory KeyboardMap.fromJson(Json json) {
    List<List<KeyboardKey>> parseKeys(dynamic jsonBlock) {
      return (jsonBlock as List).map((row) {
        return (row as List).map((key) {
          return KeyboardKey.fromJson(key);
        }).toList();
      }).toList();
    }

    return KeyboardMap(
      functionRow: (json['function_row'] as List).map((key) {
        return KeyboardKey.fromJson(key);
      }).toList(),
      mainBlock: parseKeys(json['main_block']),
      navigationBlock: parseKeys(json['navigation_block']),
      numpad: parseKeys(json['numpad']),
    );
  }

  List<int> get fullKeyboardlistCodes {
    return _getListCodes([functionRow]) +
        _getListCodes(mainBlock) +
        _getListCodes(navigationBlock) +
        _getListCodes(numpad);
  }

  List<int> get numpadListCodes {
    return _getListCodes(numpad);
  }

  List<int> get compactKeyboardListCodes {
    return _getListCodes(numpad);
  }

  List<int> _getListCodes(List<List<KeyboardKey>> keyBlocks) {
    return keyBlocks
        .expand((block) => block.expand((key) => [key.code]))
        .toList();
  }
}
