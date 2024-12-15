import 'package:streamkeys/windows/models/touch/action_touch_button_info.dart';
import 'package:streamkeys/windows/models/base_action.dart';

class KeyboardActionButtonInfo extends ActionButtonInfo {
  final int keyCode;

  KeyboardActionButtonInfo({
    required this.keyCode,
    super.name,
    super.imagePath,
    super.backgroundColor,
    super.actions,
  });

  @override
  Json toJson() {
    final json = super.toJson();
    json['key_code'] = keyCode;
    return json;
  }

  factory KeyboardActionButtonInfo.fromJson(Json json) {
    final baseInfo = ActionButtonInfo.fromJson(json);
    final keyCode = json['key_code'];
    return KeyboardActionButtonInfo(
      keyCode: keyCode,
      name: baseInfo.name,
      imagePath: baseInfo.imagePath,
      backgroundColor: baseInfo.backgroundColor,
      actions: baseInfo.actions,
    );
  }

  @override
  KeyboardActionButtonInfo copy() {
    return KeyboardActionButtonInfo(
      keyCode: keyCode,
      name: name,
      actions: List<BaseAction>.from(actions),
      backgroundColor: backgroundColor,
      imagePath: imagePath,
    );
  }

  ActionButtonInfo get actionButtonInfo {
    return ActionButtonInfo(
      actions: List<BaseAction>.from(actions),
      backgroundColor: backgroundColor,
      imagePath: imagePath,
      name: name,
    );
  }
}
