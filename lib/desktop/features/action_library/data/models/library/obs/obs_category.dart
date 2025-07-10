import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_category.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/set_active_scene.dart';

class ObsCategory extends BindingActionCategory {
  const ObsCategory() : super(name: 'OBS Studio');

  @override
  Widget getIcon(BuildContext context) {
    return BindingActionIcons.of(context).obs;
  }

  @override
  List<BindingAction> get actions {
    return [
      SetActiveScene(),
    ];
  }
}
