import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'actions/index.dart';

abstract class BaseAction {
  final String actionType;
  final String actionName;

  BaseAction({
    required this.actionType,
    required this.actionName,
  });

  Json toJson();

  factory BaseAction.fromJson(Json json) {
    switch (json['action_type']) {
      case Website.actionTypeName:
        return Website.fromJson(json);
      default:
        throw UnsupportedError('Unknown action type');
    }
  }

  FutureVoid execute({dynamic data});

  List<Widget> formFields(BuildContext context);

  void clear() {}

  BaseAction copy();

  void dispose() {}
}
