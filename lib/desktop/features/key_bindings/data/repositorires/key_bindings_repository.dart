import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_json_keys.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_type.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/models/key_binding_data.dart';
import 'package:streamkeys/desktop/utils/local_json_file_manager.dart';

class KeyBindingsRepository {
  DeckType deckType;
  late LocalJsonFileManager deckJsonFile;

  KeyBindingsRepository(this.deckType) {
    deckJsonFile = LocalJsonFileManager.storage('${deckType.name}_deck.json');
  }

  Future<(String, KeyBindingPagesMap)> getKeyMap() async {
    final Map<String, dynamic>? json = await deckJsonFile.read();

    if (json == null) {
      return ('', <String, KeyBindingMap>{});
    }

    final String currentPageId = json[DeckJsonKeys.currentPageId] ?? '';
    final Map<String, dynamic> rawMap = json[DeckJsonKeys.map] ?? {};

    final KeyBindingPagesMap parsedMap = rawMap.map((pageName, pageContent) {
      final rawBindings = pageContent as Map<String, dynamic>;

      final KeyBindingMap bindings = rawBindings.map((keyCode, keyData) {
        return MapEntry(keyCode, KeyBindingData.fromJson(keyData));
      });

      return MapEntry(pageName, bindings);
    });

    return (currentPageId, parsedMap);
  }

  Future<void> saveKeyBindingDataOnPage(
    String pageId,
    int keyCode,
    KeyBindingData keyData,
  ) async {
    Map<String, dynamic>? json = await deckJsonFile.read();

    json ??= {};
    json['map'][pageId][keyCode.toString()] = keyData.toJson();

    return deckJsonFile.save(json);
  }
}
