import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_category.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/twitch/twitch_send_message_to_chat_acton.dart';

class TwitchCategory extends BindingActionCategory {
  const TwitchCategory() : super(name: 'Twitch');

  @override
  Widget getIcon(BuildContext context) {
    return BindingActionIcons.of(context).twitch;
  }

  @override
  List<BindingAction> get actions {
    return [TwitchSendMessageToChatAction()];
  }
}
