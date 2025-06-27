import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/system/website_action.dart';

class ActionTypes {
  static const website = 'website';
  static const openAppFile = 'open_app_file';
}

void registerBindingActions() {
  BindingAction.register(ActionTypes.website, WebsiteAction.fromJson);
}
