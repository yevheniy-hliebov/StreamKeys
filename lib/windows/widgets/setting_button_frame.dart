import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/touch/action_touch_button_info.dart';
import 'package:streamkeys/windows/widgets/setting_button_form.dart';

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
    }
    return SettingButtonForm(
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
