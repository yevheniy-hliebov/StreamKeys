import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/forms/field_label.dart';
import 'package:streamkeys/common/widgets/tiles/checkbox_tile.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/twitch/twitch_send_message_acton.dart';

class TwitchSendMessageForm extends StatefulWidget {
  final TwitchSendMessageAction initialAction;
  final void Function(TwitchSendMessageAction action)? onUpdated;

  const TwitchSendMessageForm({
    super.key,
    required this.initialAction,
    this.onUpdated,
  });

  @override
  State<TwitchSendMessageForm> createState() =>
      _TwitchSendMessageFormState();
}

class _TwitchSendMessageFormState
    extends State<TwitchSendMessageForm> {
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
      TwitchSendMessageAction(text: textController.text, isBot: isBot),
    );
  }
}

