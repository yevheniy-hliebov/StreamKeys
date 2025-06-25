import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/system/website_binding_action.dart';

class ActionTypes {
  static const website = 'website';
}

void registerBindingActions() {
  BindingAction.register(ActionTypes.website, WebsiteBindingAction.fromJson);
}
