import 'dart:convert';
import 'dart:math';

import 'package:streamkeys/windows/models/page_keyboard_data.dart';
import 'package:streamkeys/windows/models/typedefs.dart';
import 'package:streamkeys/windows/services/deck_pages_service.dart';
import 'package:streamkeys/windows/utils/json_read_and_write.dart';

class KeyboardDeckService {
  late Json jsonData;

  FutureVoid init() async {
    await getData();
  }

  final keyboardDeckJson = const JsonReadAndWrite(
    fileName: 'keyboard_deck.json',
  );

  final keyboardMapJson = const JsonReadAndWrite(
    fileName: 'keyboard_map.json',
    isAsset: true,
  );

  FutureVoid getData() async {
    final jsonString = await keyboardDeckJson.read();
    if (jsonString.isEmpty) {
      final generatedJson = generateKeyboardDeckJson();
      await keyboardDeckJson.save(jsonEncode(generatedJson));
      jsonData = generatedJson;
    }
    jsonData = jsonDecode(jsonString);
  }

  Future<void> saveData() async {
    await keyboardDeckJson.save(jsonEncode(jsonData));
  }

  List<PageKeyboardData> parseMapPages(Json mapPages) {
    return mapPages.entries.map((entry) {
      return PageKeyboardData.fromJson(
        entry.key,
        keyboardActionsJson: entry.value,
      );
    }).toList();
  }

  Future<String> addPage(
    String baseName,
  ) async {
    await getData();
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
    await getData();
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
    await getData();
    jsonData['current_page'] = pageName;
    await saveData();
  }

  Future<void> selectKeyboard(Json keyboard) async {
    await getData();
    jsonData['selected_keyboard'] = keyboard;
    await saveData();
  }

  Future<void> selectKeyboardType(String type) async {
    await getData();
    jsonData['selected_keyboard_type'] = type;
    await saveData();
  }

  Future<Json?> getKeyboardMap() async {
    final content = await keyboardMapJson.read();
    if (content.isEmpty) {
      return null;
    }
    try {
      return jsonDecode(content);
    } catch (e) {
      throw Exception('Failed to decode keyboard keys JSON: $e');
    }
  }

  Future<Json?> getKeyActionInfoJson(int keyCode) async {
    return jsonData['map_pages'][jsonData['current_page']][keyCode.toString()];
  }
}
