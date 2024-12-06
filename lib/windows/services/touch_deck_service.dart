import 'dart:convert';
import 'dart:math';

import 'package:streamkeys/windows/models/action_touch_button_info.dart';
import 'package:streamkeys/windows/models/grid_template.dart';
import 'package:streamkeys/windows/models/page_touch_data.dart';
import 'package:streamkeys/windows/models/typedefs.dart';
import 'package:streamkeys/windows/utils/json_read_and_write.dart';

class TouchDeckService {
  final jsonReadAndWrite = const JsonReadAndWrite(fileName: 'touch_deck.json');

  Future<Json> getData() async {
    final jsonString = await jsonReadAndWrite.read();
    if (jsonString.isEmpty) {
      final generatedJson = generateStartJson();
      await jsonReadAndWrite.save(jsonEncode(generatedJson));
      return generatedJson;
    }
    return jsonDecode(jsonString);
  }

  Future<void> saveData(Json jsonData) async {
    await jsonReadAndWrite.save(jsonEncode(jsonData));
  }

  Json generateStartJson() {
    final selectedGrid = GridTemplate(3, 2);
    final pageTouchData = PageTouchData(
      pageName: 'Default page',
      actionButtonInfos: List.generate(
        selectedGrid.numberOfColumns * selectedGrid.numberOfRows,
        (index) => ActionTouchButtonInfo(),
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

  Future<String> addPage(Json jsonData, List<PageTouchData> pages,
      String baseName, GridTemplate currentGrid) async {
    String uniquePageName = baseName;
    int counter = 1;

    while (pages.any((page) => page.pageName == uniquePageName)) {
      uniquePageName = '$baseName $counter';
      counter++;
    }

    final newPage = PageTouchData(
      pageName: uniquePageName,
      actionButtonInfos: List.generate(
        currentGrid.numberOfColumns * currentGrid.numberOfRows,
        (index) => ActionTouchButtonInfo(),
      ),
    );

    jsonData['map_pages'][uniquePageName] = newPage.toJson();
    jsonData['page_order'].add(uniquePageName);
    pages.add(newPage);

    await saveData(jsonData);
    return uniquePageName;
  }

  Future<void> deletePage(
      Json jsonData,
      String pageName,
      List<PageTouchData> pages,
      List<String> orderPages,
      String? currentPage) async {
    orderPages.remove(pageName);
    pages.removeWhere((page) => page.pageName == pageName);
    jsonData['map_pages'].remove(pageName);

    if (currentPage == pageName) {
      final newCurrentPage = orderPages.isNotEmpty
          ? orderPages[max(0, orderPages.indexOf(pageName) - 1)]
          : null;
      jsonData['current_page'] = newCurrentPage;
    }

    jsonData['page_order'] = orderPages;
    await saveData(jsonData);
  }

  Future<void> selectPage(Json jsonData, String pageName) async {
    jsonData['current_page'] = pageName;
    await saveData(jsonData);
  }

  List<PageTouchData> parseMapPages(Map<String, dynamic> mapPages) {
    return mapPages.entries.map((entry) {
      return PageTouchData.fromJson(
          entry.key, List<Map<String, dynamic>>.from(entry.value));
    }).toList();
  }

  Future<void> updateGridSize(
      Json jsonData, GridTemplate newGrid, String? currentPage) async {
    jsonData['selected_grid'] = newGrid.toJson();

    if (currentPage != null) {
      List<dynamic>? listButtons = jsonData['map_pages'][currentPage];
      if (listButtons != null) {
        jsonData['map_pages'][currentPage] = regenerateButtonsForPage(listButtons, newGrid);
      }
    }

    await saveData(jsonData);
  }

  List<dynamic> regenerateButtonsForPage(
      List<dynamic> listButtons, GridTemplate newGrid) {
    final int totalButtons = newGrid.numberOfColumns * newGrid.numberOfRows;
    final int currentButtonCount = listButtons.length;

    if (currentButtonCount < totalButtons) {
      final List<ActionTouchButtonInfo> additionalButtons = List.generate(
        totalButtons - currentButtonCount,
        (index) => ActionTouchButtonInfo(),
      );

      listButtons.addAll(
        additionalButtons.map((button) => button.toJson()).toList(),
      );
    }
    return listButtons;
  }
}
