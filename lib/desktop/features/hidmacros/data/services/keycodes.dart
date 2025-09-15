import 'package:streamkeys/common/models/typedef.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/desktop/utils/local_json_file_manager.dart';

class KeyCodes {
  final helper = LocalJsonFileManager.asset('keyboard_key_codes.json');
  Json? json;

  Future<void> init() async {
    json = await helper.read();
  }

  List<int> getList(KeyboardType type) {
    if (json == null) return [];

    final List<int> codes = [];
    if ([KeyboardType.full, KeyboardType.compact].contains(type)) {
      codes
        ..addAll(List<int>.from(json?['function_block']))
        ..addAll(List<int>.from(json?['main_block']))
        ..addAll(List<int>.from(json?['navigation_block']));
    }
    if ([KeyboardType.full, KeyboardType.numpad].contains(type)) {
      codes.addAll(List<int>.from(json?['numpad']));
    }
    return codes;
  }
}
