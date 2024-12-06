import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/actions/open_app_and_file.dart';
import 'package:streamkeys/windows/models/actions/website.dart';
import 'package:streamkeys/windows/models/typedefs.dart';
export 'package:streamkeys/windows/models/typedefs.dart';
export 'package:flutter/material.dart';

abstract class BaseAction {
  final String actionType;

  BaseAction({required this.actionType});

  FutureVoid execute();

  Json toJson();

  factory BaseAction.fromJson(Json json) {
    switch (json['action_type']) {
      case OpenAppAndFile.actionTypeName:
        return OpenAppAndFile.fromJson(json);
      case Website.actionTypeName:
        return Website.fromJson(json);
      default:
        throw UnsupportedError('Unknown action type');
    }
  }

  List<Widget> formFields(BuildContext context);

  void clear() {}

  void dispose() {}
}