import 'package:streamkeys/windows/models/action_touch_button_info.dart';
import 'package:streamkeys/windows/models/base_action.dart';

class KeyboardActionButtonInfo extends ActionButtonInfo {
  final int keyCode;

  KeyboardActionButtonInfo({
    required this.keyCode,
    super.name,
    super.imagePath,
    super.backgroundColor,
    super.action,
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
      action: baseInfo.action,
    );
  }

  @override
  KeyboardActionButtonInfo copy() {
    return KeyboardActionButtonInfo(
      keyCode: keyCode,
      name: name,
      action: action,
      backgroundColor: backgroundColor,
      imagePath: imagePath,
    );
  }

  ActionButtonInfo get actionButtonInfo {
    return ActionButtonInfo(
      action: action,
      backgroundColor: backgroundColor,
      imagePath: imagePath,
      name: name,
    );
  }
}
