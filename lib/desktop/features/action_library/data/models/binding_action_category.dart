import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/obs_category.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/streamerbot/streamerbot_category.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/system/system_category.dart';

abstract class BindingActionCategory {
  final String name;

  const BindingActionCategory({
    required this.name,
  });

  List<BindingAction> get actions => [];
  Widget getIcon(BuildContext context);

  static List<BindingActionCategory> library = const [
    SystemCategory(),
    ObsCategory(),
    StreamerBotCategory(),
  ];
}
