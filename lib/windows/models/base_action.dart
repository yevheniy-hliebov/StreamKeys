import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/actions/obs/hidden_source.dart';
import 'package:streamkeys/windows/models/actions/obs/mute_source.dart';
import 'package:streamkeys/windows/models/actions/obs/set_active_scene.dart';
import 'package:streamkeys/windows/models/actions/obs/toogle_mute_source.dart';
import 'package:streamkeys/windows/models/actions/obs/toogle_visible_source.dart';
import 'package:streamkeys/windows/models/actions/obs/unmute_source.dart';
import 'package:streamkeys/windows/models/actions/obs/visible_source.dart';
import 'package:streamkeys/windows/models/actions/toolbox/open_app_and_file.dart';
import 'package:streamkeys/windows/models/actions/toolbox/website.dart';
import 'package:streamkeys/windows/models/typedefs.dart';
export 'package:streamkeys/windows/models/typedefs.dart';

abstract class BaseAction {
  final String actionType;

  BaseAction({required this.actionType});

  FutureVoid execute({dynamic data});

  Json toJson();

  factory BaseAction.fromJson(Json json) {
    switch (json['action_type']) {
      case OpenAppAndFile.actionTypeName:
        return OpenAppAndFile.fromJson(json);
      case Website.actionTypeName:
        return Website.fromJson(json);
      case SetActiveScene.actionTypeName:
        return SetActiveScene.fromJson(json);
      case MuteSource.actionTypeName:
        return MuteSource.fromJson(json);
      case UnmuteSource.actionTypeName:
        return UnmuteSource.fromJson(json);
      case ToogleMuteSource.actionTypeName:
        return ToogleMuteSource.fromJson(json);
      case VisibleSource.actionTypeName:
        return VisibleSource.fromJson(json);
      case ToogleVisibleSource.actionTypeName:
        return ToogleVisibleSource.fromJson(json);
      case HiddenSource.actionTypeName:
        return HiddenSource.fromJson(json);
      default:
        throw UnsupportedError('Unknown action type');
    }
  }

  List<Widget> formFields(BuildContext context);

  void clear() {}

  BaseAction copy();

  void dispose() {}
}
