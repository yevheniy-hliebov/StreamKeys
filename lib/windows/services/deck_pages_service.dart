import 'dart:convert';
import 'dart:math';

import 'package:streamkeys/windows/models/touch/action_touch_button_info.dart';
import 'package:streamkeys/windows/models/keyboard/grid_template.dart';
import 'package:streamkeys/windows/models/keyboard/page_keyboard_data.dart';
import 'package:streamkeys/windows/models/touch/page_touch_data.dart';
import 'package:streamkeys/windows/models/typedefs.dart';
import 'package:streamkeys/windows/utils/json_read_and_write.dart';

class DeckPagesService {
  final String deckType;

  DeckPagesService(this.deckType);

  late Json jsonData;
  late JsonReadAndWrite buttonActionsJson;

  FutureVoid init() async {
    buttonActionsJson = JsonReadAndWrite(
      fileName: '${deckType}_deck.json',
    );
    jsonData = await getData();
  }

  Future<Json> getData() async {
    final jsonString = await buttonActionsJson.read();
    if (jsonString.isEmpty) {
      final generatedJson = deckType == 'touch'
          ? generateTouchDeckJson()
          : generateKeyboardDeckJson();
      await buttonActionsJson.save(jsonEncode(generatedJson));
      return generatedJson;
    }
    return jsonDecode(jsonString);
  }

  Future<void> saveData() async {
    await buttonActionsJson.save(jsonEncode(jsonData));
  }

  Future<String> addPage(
    String baseName,
  ) async {
    jsonData = await getData();
    String uniquePageName = baseName;
    int counter = 1;

    final mapPage = jsonData['map_pages'] as Json;

    while (mapPage.containsKey(uniquePageName)) {
      uniquePageName = '$baseName $counter';
      counter++;
    }

    final newPage = PageKeyboardData(
      pageName: uniquePageName,
    );

    jsonData['map_pages'][uniquePageName] = newPage.toJson()['keys'];
    jsonData['page_order'].add(uniquePageName);

    await saveData();
    return uniquePageName;
  }

  Future<void> deletePage(
    String pageName,
    List<String> orderPages,
    String? currentPage,
  ) async {
    jsonData = await getData();
    orderPages.remove(pageName);
    jsonData['map_pages'].remove(pageName);

    if (currentPage == pageName) {
      final newCurrentPage = orderPages.isNotEmpty
          ? orderPages[max(0, orderPages.indexOf(pageName) - 1)]
          : null;
      jsonData['current_page'] = newCurrentPage;
    }

    jsonData['page_order'] = orderPages;
    await saveData();
  }

  Future<void> selectPage(String pageName) async {
    jsonData = await getData();
    jsonData['current_page'] = pageName;
    await saveData();
  }
}

Json generateTouchDeckJson() {
  final selectedGrid = GridTemplate(3, 2);
  final pageTouchData = PageTouchData(
    pageName: 'Default page',
    actionButtonInfos: List.generate(
      selectedGrid.numberOfColumns * selectedGrid.numberOfRows,
      (index) => ActionButtonInfo(),
    ),
  );

  return {
    'current_page': pageTouchData.pageName,
    'page_order': [pageTouchData.pageName],
    'selected_grid': selectedGrid.toJson(),
    'map_pages': {
      pageTouchData.pageName: pageTouchData.toJson(),
    }
  };
}

Json generateKeyboardDeckJson() {
  final pageKeyboardData = PageKeyboardData(
    pageName: 'Default page',
  );

  return {
    'hidmarcors_xml_path': null,
    'selected_keyboard': null,
    'selected_keyboard_type': 'full',
    'current_page': pageKeyboardData.pageName,
    'page_order': [pageKeyboardData.pageName],
    'map_pages': pageKeyboardData.toJson(),
  };
}
