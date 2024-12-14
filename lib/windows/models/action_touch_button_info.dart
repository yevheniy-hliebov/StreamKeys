import 'package:streamkeys/windows/models/base_action.dart';
import 'package:streamkeys/windows/services/file_picker_service.dart';
import 'package:streamkeys/windows/utils/color_helper.dart';

class ActionButtonInfo {
  String name;
  String imagePath;
  Color backgroundColor;
  BaseAction? action;

  ActionButtonInfo({
    this.name = '',
    this.imagePath = '',
    this.backgroundColor = Colors.transparent,
    this.action,
  });

  void onClick() {
    action?.execute();
  }

  Future<void> pickImage() async {
    final path = await FilePickerService.pickImage();
    if (path != null) {
      imagePath = path;
    }
  }

  bool get isHaveAction => action != null;

  Json toJson() {
    return {
      'name': name,
      'image_path': imagePath,
      'background_color': ColorHelper.getHexString(backgroundColor),
      'action': action?.toJson(),
    };
  }

  ActionButtonInfo copy() {
    return ActionButtonInfo(
      name: name,
      action: action,
      backgroundColor: backgroundColor,
      imagePath: imagePath,
    );
  }

  void clear() {
    name = '';
    imagePath = '';
    backgroundColor = Colors.transparent;
    action?.clear();
  }

  void delete() {
    clear();
    action = null;
  }

  factory ActionButtonInfo.fromJson(Json json) {
    final backgroundColor = json['background_color'] != null
        ? ColorHelper.hexToColor(json['background_color'])
        : Colors.transparent;
    return ActionButtonInfo(
      name: json['name'],
      imagePath: json['image_path'],
      backgroundColor: backgroundColor,
      action:
          json['action'] == null ? null : BaseAction.fromJson(json['action']),
    );
  }
}
