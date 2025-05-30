import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/keyboards_deck/models/keyboard_key.dart';

class KeyboardMapData {
  final List<List<KeyboardKey>> functionBlock;
  final List<List<KeyboardKey>> mainBlock;
  final List<List<KeyboardKey>> navigationBlock;
  final List<List<KeyboardKey>> numpad;

  const KeyboardMapData({
    required this.functionBlock,
    required this.mainBlock,
    required this.navigationBlock,
    required this.numpad,
  });

  factory KeyboardMapData.fromJson(Json json) {
    List<List<KeyboardKey>> parseKeys(dynamic jsonBlock) {
      return (jsonBlock as List).map((row) {
        return (row as List).map((key) {
          return KeyboardKey.fromJson(key);
        }).toList();
      }).toList();
    }

    return KeyboardMapData(
      functionBlock: parseKeys(json['function_row']),
      mainBlock: parseKeys(json['main_block']),
      navigationBlock: parseKeys(json['navigation_block']),
      numpad: parseKeys(json['numpad']),
    );
  }

  List<int> get fullKeyboardlistCodes {
    return _getListCodes(functionBlock) +
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

