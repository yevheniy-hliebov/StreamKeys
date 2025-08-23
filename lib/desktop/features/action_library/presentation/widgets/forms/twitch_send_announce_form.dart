import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/buttons/custom_dropdown_button.dart';
import 'package:streamkeys/common/widgets/forms/field_label.dart';
import 'package:streamkeys/common/widgets/tiles/checkbox_tile.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/twitch/twitch_send_announcement_action.dart';
import 'package:streamkeys/desktop/features/twitch/data/models/twitch_announcement_color.dart';

class TwitchSendAnnounceForm extends StatefulWidget {
  final TwitchSendAnnouncementAction initialAction;
  final void Function(TwitchSendAnnouncementAction action)? onUpdated;

  const TwitchSendAnnounceForm({
    super.key,
    required this.initialAction,
    this.onUpdated,
  });

  @override
  State<TwitchSendAnnounceForm> createState() => _TwitchSendAnnounceFormState();
}

class _TwitchSendAnnounceFormState extends State<TwitchSendAnnounceForm> {
  late TextEditingController textController;
  late int indexColor;
  late bool isBot;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.initialAction.text);
    indexColor = TwitchAnnouncementColor.values.indexOf(
      widget.initialAction.color,
    );
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
        const FieldLabel('Color'),
        CustomDropdownButton(
          itemCount: TwitchAnnouncementColor.values.length,
          index: indexColor,
          constraints: const BoxConstraints(),
          itemBuilder: (index) =>
              Text(TwitchAnnouncementColor.values[index].name),
          onChanged: (newIndex) {
            if (newIndex == null || newIndex == indexColor) return;
            setState(() => indexColor = newIndex);
            _onUpdate();
          },
        ),
        const FieldLabel('Message'),
        TextFormField(
          controller: textController,
          onChanged: (value) => _onUpdate(),
        ),
        CheckboxTile(
          label: 'send announce via bot',
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
      TwitchSendAnnouncementAction(
        text: textController.text,
        color: TwitchAnnouncementColor.values[indexColor],
        isBot: isBot,
      ),
    );
  }
}
