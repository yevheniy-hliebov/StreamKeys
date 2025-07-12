import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_category.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/record_or_stream_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/screenshot_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/set_active_scene_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/source_mute_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/source_visibility_action.dart';

class ObsCategory extends BindingActionCategory {
  const ObsCategory() : super(name: 'OBS Studio');

  @override
  Widget getIcon(BuildContext context) {
    return BindingActionIcons.of(context).obs;
  }

  @override
  List<BindingAction> get actions {
    return [
      RecordOrStreamAction(type: ActionTypes.obsRecord),
      RecordOrStreamAction(type: ActionTypes.obsStream),
      SetActiveSceneAction(),
      SourceMuteAction(),
      SourceVisibilityAction(),
      ScreenshotAction(),
    ];
  }
}
