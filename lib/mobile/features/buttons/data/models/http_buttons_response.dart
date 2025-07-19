import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_json_keys.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/grid_template.dart';
import 'package:streamkeys/mobile/features/buttons/data/models/button_data.dart';

class HttpButtonsResponse {
  final GridTemplate gridTemplate;
  final String currentPageId;
  final Map<String, ButtonData> pageMap;

  HttpButtonsResponse({
    required this.gridTemplate,
    required this.currentPageId,
    required this.pageMap,
  });

  factory HttpButtonsResponse.fromJson(Map<String, dynamic> json) {
    final rawPageMap = json['page_map'] as Map<String, dynamic>? ?? {};

    final parsedPageMap = rawPageMap.map(
      (key, value) => MapEntry(
        key,
        ButtonData.fromJson(key, value as Map<String, dynamic>),
      ),
    );

    return HttpButtonsResponse(
      gridTemplate: GridTemplate.fromJson(json['grid_template']),
      currentPageId: json[DeckJsonKeys.currentPageId] as String,
      pageMap: parsedPageMap,
    );
  }
}
