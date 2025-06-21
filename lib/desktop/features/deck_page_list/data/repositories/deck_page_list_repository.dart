import 'package:streamkeys/common/models/typedef.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_json_keys.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_page.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_type.dart';
import 'package:streamkeys/desktop/utils/local_json_file_manager.dart';

class DeckPageListRepository {
  DeckType deckType;
  late LocalJsonFileManager _jsonFile;
  late Json json;

  DeckPageListRepository(this.deckType, {LocalJsonFileManager? jsonFile}) {
    if (jsonFile != null) {
      _jsonFile = jsonFile;
    } else {
      _jsonFile = LocalJsonFileManager.storage('${deckType.name}_deck.json');
    }
  }

  String get currentPageId => json[DeckJsonKeys.currentPageId];
  List<DeckPage> get orderPages {
    final rawList = json[DeckJsonKeys.orderPages] as List<dynamic>;
    return DeckPage.fromJsonList(
      rawList.map((e) => Map<String, dynamic>.from(e as Map)).toList(),
    );
  }

  List<dynamic> get _orderPagesJson =>
      json[DeckJsonKeys.orderPages] as List<dynamic>;
  Map<String, dynamic> get _mapJson =>
      json[DeckJsonKeys.map] as Map<String, dynamic>;

  Future<void> init() => _loadJson();

  Future<void> addAndSelectPage(DeckPage page) async {
    json[DeckJsonKeys.currentPageId] = page.id;
    _orderPagesJson.add(page.toJson());
    _mapJson[page.id] = {};

    await _save();
  }

  Future<void> selectPage(String pageId) async {
    json[DeckJsonKeys.currentPageId] = pageId;
    await _save();
  }

  Future<void> renameCurrentPage(String newName) async {
    final int index = _orderPagesJson.indexWhere(
      (p) => p[DeckJsonKeys.pageId] == currentPageId,
    );
    if (index == -1) return;

    _orderPagesJson[index][DeckJsonKeys.pageName] = newName;
    await _save();
  }

  Future<void> deletePage(String pageId) async {
    final orderPagesJson = _orderPagesJson;
    if (orderPagesJson.length <= 1) return;

    final index = orderPagesJson.indexWhere(
      (p) => p[DeckJsonKeys.pageId] == pageId,
    );
    if (index == -1) return;

    orderPagesJson.removeAt(index);
    _mapJson.remove(pageId);

    _selectPageAfterDeletion(index, orderPagesJson);

    await _save();
  }

  void _selectPageAfterDeletion(int removedIndex, List<dynamic> pagesJson) {
    final fallbackIndex = removedIndex > 0 ? removedIndex - 1 : 0;
    json[DeckJsonKeys.currentPageId] =
        pagesJson[fallbackIndex][DeckJsonKeys.pageId];
  }

  Future<void> reorderPages(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    if (newIndex < 0) {
      newIndex = 0;
    } else if (newIndex > _orderPagesJson.length) {
      newIndex = _orderPagesJson.length;
    }

    final movedItem = _orderPagesJson.removeAt(oldIndex);
    _orderPagesJson.insert(newIndex, movedItem);

    await _save();
  }

  Future<void> _loadJson() async {
    json = await _jsonFile.read() ?? await _generateStarterJson();
  }

  Future<Json> _generateStarterJson() async {
    final defaultPage = DeckPage.create(name: 'Default page');

    final generatedJson = {
      DeckJsonKeys.currentPageId: defaultPage.id,
      DeckJsonKeys.orderPages: [
        defaultPage.toJson(),
      ],
      DeckJsonKeys.map: {
        defaultPage.id: <String, dynamic>{},
      }
    };
    await _jsonFile.save(generatedJson);
    return generatedJson;
  }

  Future<void> _save() async {
    _jsonFile.save(json);
  }
}
