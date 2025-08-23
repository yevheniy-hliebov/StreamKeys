import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/typedef.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/forms/twitch_send_announce_form.dart';
import 'package:streamkeys/desktop/features/twitch/data/models/twitch_announcement_color.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:uuid/uuid.dart';

class TwitchSendAnnouncementAction extends BindingAction {
  final String text;
  final TwitchAnnouncementColor color;
  final bool isBot;

  TwitchSendAnnouncementAction({
    String? id,
    this.text = '',
    this.color = TwitchAnnouncementColor.primary,
    this.isBot = false,
  }) : super(
         id: id ?? const Uuid().v4(),
         type: ActionTypes.twitchSendAnnouncement,
         name: 'Send Announcement',
       );

  @override
  String get dialogTitle => 'Enter announcement text to send to chat';

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
    return BindingActionIcons.of(context).twitchSendAnnouncementToChat;
  }

  @override
  Json toJson() {
    return {'type': type, 'text': text, 'color': color.name, 'is_bot': isBot};
  }

  factory TwitchSendAnnouncementAction.fromJson(Json json) {
    final colorString = json['color'];
    final color = TwitchAnnouncementColor.values.byName(colorString);

    return TwitchSendAnnouncementAction(
      text: json['text'] as String,
      color: color,
      isBot: json['is_bot'] as bool? ?? false,
    );
  }

  @override
  BindingAction copy() {
    return TwitchSendAnnouncementAction(text: text, color: color, isBot: isBot);
  }

  @override
  Future<void> execute({Object? data}) async {
    final twitchApi = sl<TwitchApiService>();
    await twitchApi.sendAnnouncement(message: text, color: color, isBot: isBot);
  }

  @override
  Widget? form(
    BuildContext context, {
    void Function(BindingAction updatedAction)? onUpdated,
  }) {
    return TwitchSendAnnounceForm(
      initialAction: this,
      onUpdated: (newValue) {
        onUpdated?.call(newValue);
      },
    );
  }

  @override
  List<Object?> get props => [id, type, name, text, color, isBot];
}
