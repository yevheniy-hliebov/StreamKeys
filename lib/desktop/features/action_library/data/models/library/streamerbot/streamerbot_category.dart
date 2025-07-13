import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_category.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/streamerbot/do_action.dart';

class StreamerBotCategory extends BindingActionCategory {
  const StreamerBotCategory() : super(name: 'Streamer.bot');

  @override
  Widget getIcon(BuildContext context) {
    return BindingActionIcons.of(context).streamerbot;
  }

  @override
  List<BindingAction> get actions {
    return [
      StreamerBotDoAction(),
    ];
  }
}
