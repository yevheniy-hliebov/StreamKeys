import 'package:streamkeys/android/models/action_button_info.dart';
import 'package:streamkeys/windows/models/grid_template.dart';
import 'package:streamkeys/windows/models/typedefs.dart';

class PageData {
  final String currentPage;
  final GridTemplate grid;
  final List<ActionButtonInfo> actionButtonInfos;

  const PageData({
    required this.currentPage,
    required this.grid,
    required this.actionButtonInfos,
  });

  factory PageData.fromJson(Json json) {
    return PageData(
      currentPage: json['current_page'],
      grid: GridTemplate.fromJson(json['grid']),
      actionButtonInfos:
          (json['buttons'] as List<dynamic>).cast<Json>().map((buttonInfoJson) {
        return ActionButtonInfo.fromJson(buttonInfoJson);
      }).toList(),
    );
  }
}
