import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/set_active_scene_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/system/launch_file_or_app_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/system/website_action.dart';

class ActionTypes {
  static const website = 'website';
  static const launcFileOrApp = 'launch_file_or_app';

  static const setActiveScene = 'set_active_scene';
}

void registerBindingActions() {
  BindingAction.register(ActionTypes.website, WebsiteAction.fromJson);
  BindingAction.register(
    ActionTypes.launcFileOrApp,
    LaunchFileOrAppAction.fromJson,
  );
  BindingAction.register(
    ActionTypes.setActiveScene,
    SetActiveSceneAction.fromJson,
  );
}
