import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/deck_pages/data/repositories/deck_pages_repository.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key_data.dart';
import 'package:streamkeys/utils/json_read_and_save.dart';

class KeyboardMapRepository {
  late JsonHelper jsonHelper;

  KeyboardMapRepository() {
    jsonHelper = JsonHelper.storage('${DeckType.keyboard.name}_deck.json');
  }

  Future<Map<String, KeyboardKeyData>> getKeyMapByPageName(
    String pageName,
  ) async {
    Json? json = await jsonHelper.read();

    if (json == null) {
      return {};
    } else {
      Map<String, dynamic>? pageMap = json['map'][pageName];

      if (pageMap == null) {
        return {};
      }

      Map<String, KeyboardKeyData> result = pageMap.map(
        (key, value) => MapEntry(key, KeyboardKeyData.fromJson(value)),
      );

      return result;
    }
  }

  Future<void> saveKeyDataToPage(
    String pageName,
    KeyboardKeyData keyData,
  ) async {
    Json? json = await jsonHelper.read();

    json ??= {
      'current_page': pageName,
      'order_pages': [
        pageName,
      ],
      'map': {
        pageName: {},
      }
    };

    json['map'][pageName][keyData.code.toString()] = keyData.toJson();
    await jsonHelper.save(json);
  }
}
