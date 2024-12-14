import 'package:streamkeys/windows/models/action_touch_button_info.dart';
import 'package:streamkeys/windows/models/typedefs.dart';

class PageTouchData {
  final String pageName;
  final List<ActionButtonInfo> actionButtonInfos;

  const PageTouchData({
    required this.pageName,
    this.actionButtonInfos = const [],
  });

  List<Json> toJson() {
    return actionButtonInfos.map((ActionButtonInfo actionButtonInfo) {
      return actionButtonInfo.toJson();
    }).toList();
  }

  factory PageTouchData.fromJson(
    String pageName,
    List<Json> actionButtonInfoJsons,
  ) {
    return PageTouchData(
      pageName: pageName,
      actionButtonInfos: actionButtonInfoJsons.map((Json json) {
        return ActionButtonInfo.fromJson(json);
      }).toList(),
    );
  }
}
