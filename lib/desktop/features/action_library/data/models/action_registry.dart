import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/system/launch_file_or_app_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/system/website_action.dart';

class ActionTypes {
  static const website = 'website';
  static const launcFileOrApp = 'launch_file_or_app';
}

void registerBindingActions() {
  BindingAction.register(ActionTypes.website, WebsiteAction.fromJson);
  BindingAction.register(
      ActionTypes.launcFileOrApp, LaunchFileOrAppAction.fromJson);
}
