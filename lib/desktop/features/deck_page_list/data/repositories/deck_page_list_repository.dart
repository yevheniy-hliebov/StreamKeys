import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_type.dart';
import 'package:streamkeys/desktop/utils/local_json_file_manager.dart';

class DeckPagesRepository {
  DeckType deckType;
  late LocalJsonFileManager deckJsonFile;

  DeckPagesRepository(this.deckType) {
    deckJsonFile = LocalJsonFileManager.storage('${deckType.name}_deck.json');
  }

  Future<(String, List<String>)> getDeckPageList() async {
    Map<String, dynamic>? json = await deckJsonFile.read();

    if (json == null) {
      json ??= <String, dynamic>{
        'current_page': 'Default page',
        'order_pages': <String>[
          'Default page',
        ],
        'map': <String, dynamic>{
          'Default page': <String, dynamic>{},
        }
      };
      await deckJsonFile.save(json);
    }

    final String currentPageName = json['current_page'] ?? '';
    final List<String> orderPages = List<String>.from(json['order_pages'] ?? <dynamic>[]);
    return (currentPageName, orderPages);
  }

  Future<void> save(String currentPageName, List<String> orderPages) async {
    Map<String, dynamic>? json = await deckJsonFile.read();

    json ??= <String, dynamic>{};
    json['current_page'] = currentPageName;
    json['order_pages'] = orderPages;

    return deckJsonFile.save(json);
  }
}
