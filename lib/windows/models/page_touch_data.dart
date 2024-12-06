import 'package:streamkeys/windows/models/action_touch_button_info.dart';
import 'package:streamkeys/windows/models/typedefs.dart';

class PageTouchData {
  final String pageName;
  final List<ActionTouchButtonInfo> actionButtonInfos;

  const PageTouchData({
    required this.pageName,
    this.actionButtonInfos = const [],
  });

  List<Json> toJson() {
    return actionButtonInfos.map((ActionTouchButtonInfo actionButtonInfo) {
      return actionButtonInfo.toJson();
    }).toList();
  }

  static PageTouchData fromJson(
    String pageName,
    List<Json> actionButtonInfoJsons,
  ) {
    return PageTouchData(
      pageName: pageName,
      actionButtonInfos: actionButtonInfoJsons.map((Json json) {
        return ActionTouchButtonInfo.fromJson(json);
      }).toList(),
    );
  }
}
