import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'actions/index.dart';

abstract class BaseAction {
  final String actionType;
  final String dialogTitle;

  BaseAction({
    required this.actionType,
    required this.dialogTitle,
  });

  String get actionName;
  String get actionLabel;

  Json toJson();

  factory BaseAction.fromJson(Json json) {
    switch (json['action_type']) {
      case Website.actionTypeName:
        return Website.fromJson(json);
      case OpenAppAndFile.actionTypeName:
        return OpenAppAndFile.fromJson(json);
      case SetActiveScene.actionTypeName:
        return SetActiveScene.fromJson(json);
      case VisibleSource.actionTypeName:
        return VisibleSource.fromJson(json);
      case HiddenSource.actionTypeName:
        return HiddenSource.fromJson(json);
      case MuteSource.actionTypeName:
        return MuteSource.fromJson(json);
      case UnMuteSource.actionTypeName:
        return UnMuteSource.fromJson(json);
      case ToggleVisibleSource.actionTypeName:
        return ToggleVisibleSource.fromJson(json);
      case ToggleMuteSource.actionTypeName:
        return ToggleMuteSource.fromJson(json);
      default:
        throw UnsupportedError('Unknown action type');
    }
  }

  FutureVoid execute({dynamic data});

  List<Widget> formFields(BuildContext context);

  void clear() {}

  void save() {}

  void cancel() {}

  BaseAction copy();

  void dispose() {}
}
