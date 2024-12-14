import 'dart:convert';

import 'package:streamkeys/windows/models/action_touch_button_info.dart';
import 'package:streamkeys/windows/models/grid_template.dart';
import 'package:streamkeys/windows/models/page_touch_data.dart';
import 'package:streamkeys/windows/models/typedefs.dart';
import 'package:streamkeys/windows/services/deck_pages_service.dart';
import 'package:streamkeys/windows/utils/json_read_and_write.dart';

class TouchDeckService {
  late Json jsonData;

  FutureVoid init() async {
    jsonData = await getData();
  }

  final jsonReadAndWrite = const JsonReadAndWrite(fileName: 'touch_deck.json');

  Future<Json> getData() async {
    final jsonString = await jsonReadAndWrite.read();
    if (jsonString.isEmpty) {
      final generatedJson = generateTouchDeckJson();
      await jsonReadAndWrite.save(jsonEncode(generatedJson));
      return generatedJson;
    }
    return jsonDecode(jsonString);
  }

  Future<void> saveData() async {
    await jsonReadAndWrite.save(jsonEncode(jsonData));
  }

  List<PageTouchData> parseMapPages(Map<String, dynamic> mapPages) {
    return mapPages.entries.map((entry) {
      return PageTouchData.fromJson(
        entry.key,
        List<Map<String, dynamic>>.from(entry.value),
      );
    }).toList();
  }

  Future<void> updateGridSize(GridTemplate newGrid, String? currentPage) async {
    await getData();
    jsonData['selected_grid'] = newGrid.toJson();

    if (currentPage != null) {
      List<dynamic>? listButtons = jsonData['map_pages'][currentPage];
      if (listButtons != null) {
        jsonData['map_pages'][currentPage] =
            generateButtonsForPage(listButtons, newGrid);
      }
    }

    await saveData();
  }

  List<dynamic> generateButtonsForPage(
    List<dynamic> listButtons,
    GridTemplate newGrid,
  ) {
    final int totalButtons = newGrid.numberOfColumns * newGrid.numberOfRows;
    final int currentButtonCount = listButtons.length;

    if (currentButtonCount < totalButtons) {
      final List<ActionButtonInfo> additionalButtons = List.generate(
        totalButtons - currentButtonCount,
        (index) => ActionButtonInfo(),
      );

      listButtons.addAll(
        additionalButtons.map((button) => button.toJson()).toList(),
      );
    }
    return listButtons;
  }
}
