import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_category.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/system/website_action.dart';

class SystemCategory extends BindingActionCategory {
  const SystemCategory() : super(name: 'System');

  @override
  Widget getIcon(BuildContext context) {
    return BindingActionIcons.of(context).system;
  }

  @override
  List<BindingAction> get actions {
    return [
      WebsiteAction(),
    ];
  }
}
