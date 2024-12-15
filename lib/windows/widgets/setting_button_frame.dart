import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/touch/action_touch_button_info.dart';
import 'package:streamkeys/windows/widgets/setting_button.dart';

class SettingButtonFrame extends StatelessWidget {
  final String deckType;
  final ActionButtonInfo? selectedButtonInfo;
  final void Function(dynamic)? onUpdate;

  const SettingButtonFrame({
    super.key,
    required this.deckType,
    this.selectedButtonInfo,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedButtonInfo == null) {
      return _buildMessage(
        'Select a button',
      );
    } else if (selectedButtonInfo?.action == null) {
      return _buildMessage('Drag an action from right, place it on the button');
    }
    return SettingButton(
      deckType: deckType,
      buttonInfo: selectedButtonInfo!,
    );
  }

  Widget _buildMessage(String message) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
