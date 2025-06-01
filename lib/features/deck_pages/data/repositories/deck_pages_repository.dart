import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/deck_pages/data/models/deck_pages.dart';
import 'package:streamkeys/features/deck_pages/data/models/deck_type_enum.dart';
import 'package:streamkeys/utils/json_read_and_save.dart';

class DeckPagesRepository {
  DeckType deckType;
  late JsonHelper jsonHelper;

  DeckPagesRepository(this.deckType) {
    jsonHelper = JsonHelper.storage('${deckType.name}_deck.json');
  }

  Future<DeckPagesData> getDeckPages() async {
    Json? json = await jsonHelper.read();

    if (json == null) {
      json ??= {
        'current_page': 'Default page',
        'order_pages': [
          'Default page',
        ],
        'map': {
          'Default page': deckType == DeckType.keyboard ? {} : [],
        }
      };
      await jsonHelper.save(json);
    }

    return DeckPagesData(
      currentPage: json['current_page'] ?? '',
      orderPages: json['order_pages']?.cast<String>() ?? [],
    );
  }

  FutureVoid save(DeckPagesData deckPagesData) async {
    Json? json = await jsonHelper.read();
    json ??= {};

    final oldOrderPages = json['order_pages']?.cast<String>() ?? [];
    final map = (json['map'] as Map?)?.cast<String, dynamic>() ?? {};

    for (final oldName in oldOrderPages) {
      if (!deckPagesData.orderPages.contains(oldName)) {
        for (final newName in deckPagesData.orderPages) {
          if (!oldOrderPages.contains(newName) && !map.containsKey(newName)) {
            map[newName] = map[oldName];
            map.remove(oldName);
            break;
          }
        }
      }
    }

    final pagesToRemove =
        map.keys.where((k) => !deckPagesData.orderPages.contains(k)).toList();
    for (final page in pagesToRemove) {
      map.remove(page);
    }

    for (final page in deckPagesData.orderPages) {
      if (!map.containsKey(page)) {
        map[page] = deckType == DeckType.keyboard ? {} : [];
      }
    }

    json['map'] = map;
    json['current_page'] = deckPagesData.currentPage;
    json['order_pages'] = deckPagesData.orderPages;

    return jsonHelper.save(json);
  }
}
