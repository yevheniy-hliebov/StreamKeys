import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/forms/field_label.dart';
import 'package:streamkeys/common/widgets/tiles/checkbox_tile.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/twitch/twitch_send_message_to_chat_acton.dart';

class TwitchSendMessageToChatForm extends StatefulWidget {
  final TwitchSendMessageToChatAction initialAction;
  final void Function(TwitchSendMessageToChatAction action)? onUpdated;

  const TwitchSendMessageToChatForm({
    super.key,
    required this.initialAction,
    this.onUpdated,
  });

  @override
  State<TwitchSendMessageToChatForm> createState() =>
      _TwitchSendMessageToChatFormState();
}

class _TwitchSendMessageToChatFormState
    extends State<TwitchSendMessageToChatForm> {
  late TextEditingController textController;
  late bool isBot;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.initialAction.text);
    isBot = widget.initialAction.isBot;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Spacing.xs,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const FieldLabel('Message'),
        TextFormField(
          controller: textController,
          onChanged: (value) => _onUpdate(),
        ),
        CheckboxTile(
          label: 'send message via bot',
          value: isBot,
          onChanged: (value) {
            setState(() => isBot = value);
            _onUpdate();
          },
        ),
      ],
    );
  }

  void _onUpdate() {
    widget.onUpdated?.call(
      TwitchSendMessageToChatAction(text: textController.text, isBot: isBot),
    );
  }
}

