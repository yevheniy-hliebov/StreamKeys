import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/android/models/action_button_info.dart';
import 'package:streamkeys/android/providers/buttons_provider.dart';
import 'package:streamkeys/common/widgets/action_button.dart';

class ActionButton extends StatelessWidget {
  final ActionButtonInfo buttonInfo;
  final int buttonIndex;
  final double buttonSize;

  const ActionButton({
    super.key,
    required this.buttonInfo,
    required this.buttonIndex,
    required this.buttonSize,
  });

  @override
  Widget build(BuildContext context) {
    final actionProvider = Provider.of<ButtonsProvider>(context);

    Widget? child;
    if (buttonInfo.hasImage) {
      final imageUrl = actionProvider.getImageUrl(buttonIndex);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final cacheBusterUrl = '$imageUrl?timestamp=$timestamp';

      child = Image.network(
        cacheBusterUrl,
        fit: BoxFit.cover,
      );
    }

    return BaseActionButton(
      onTap: () => actionProvider.clickButton(buttonIndex),
      tooltipMessage: buttonInfo.name,
      size: buttonSize,
      backgroundColor: buttonInfo.backgroundColor,
      child: child ?? const Icon(Icons.lock),
    );
  }
}
