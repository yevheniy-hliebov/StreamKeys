import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/typedef.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/forms/twitch_send_message_form.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:uuid/uuid.dart';

class TwitchSendMessageAction extends BindingAction {
  final String text;
  final bool isBot;

  TwitchSendMessageAction({String? id, this.text = '', this.isBot = false})
    : super(
        id: id ?? const Uuid().v4(),
        type: ActionTypes.twitchSendMessageToChat,
        name: 'Send Message to Chat',
      );

  @override
  String get dialogTitle => 'Enter text to send to chat';

  @override
  String get label {
    if (text.isEmpty) {
      return 'Twitch | $name';
    } else {
      final isBotText = isBot ? ' via bot ' : '';
      return 'Twitch | $name $isBotText($text)';
    }
  }

  @override
  Widget getIcon(BuildContext context) {
    return BindingActionIcons.of(context).twitchSendMessageToChat;
  }

  @override
  Json toJson() {
    return {'type': type, 'text': text, 'is_bot': isBot};
  }

  factory TwitchSendMessageAction.fromJson(Json json) {
    return TwitchSendMessageAction(
      text: json['text'] as String,
      isBot: json['is_bot'] as bool? ?? false,
    );
  }

  @override
  BindingAction copy() {
    return TwitchSendMessageAction(text: text, isBot: isBot);
  }

  @override
  Future<void> execute({Object? data}) async {
    final twitchApi = sl<TwitchApiService>();
    await twitchApi.sendMessage(message: text, isBot: isBot);
  }

  @override
  Widget? form(
    BuildContext context, {
    void Function(BindingAction updatedAction)? onUpdated,
  }) {
    return TwitchSendMessageForm(
      initialAction: this,
      onUpdated: (newValue) {
        onUpdated?.call(newValue);
      },
    );
  }

  @override
  List<Object?> get props => [id, type, name, text, isBot];
}
