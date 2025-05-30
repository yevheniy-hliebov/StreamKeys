import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/deck_pages/data/models/deck_pages.dart';
import 'package:streamkeys/utils/json_read_and_save.dart';

enum DeckType { grid, keyboard }

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
    json['current_page'] = deckPagesData.currentPage;
    json['order_pages'] = deckPagesData.orderPages;

    return jsonHelper.save(json);
  }
}
