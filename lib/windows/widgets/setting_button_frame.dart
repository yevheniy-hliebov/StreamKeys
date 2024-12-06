import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/windows/providers/touch_deck_provider.dart';
import 'package:streamkeys/windows/widgets/setting_touch_button.dart';

class SettingButtonFrame extends StatelessWidget {
  const SettingButtonFrame({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TouchDeckProvider>(builder: (context, provider, child) {
      final buttonInfo = provider.selectedButtonInfo;
      if (buttonInfo == null) {
        return _buildMessage(
          'Select a button',
        );
      } else if (buttonInfo.action == null) {
        return _buildMessage(
            'Drag an action from right, place it on the button');
      }
      return SettingTouchButton(
        buttonInfo: buttonInfo,
        onUpdate: (updatedButtonInfo) {
          provider.updateSelectedButtonInfo(updatedButtonInfo);
        },
      );
    });
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
