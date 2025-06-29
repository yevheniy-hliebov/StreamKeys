import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streamkeys/common/widgets/square_icon_button.dart';

class CopyIconButton extends StatelessWidget {
  final double size;
  final String textToCopy;
  final IconData icon;

  const CopyIconButton({
    super.key,
    this.size = 40,
    required this.textToCopy,
    this.icon = Icons.copy,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Copy to clipboard',
      child: SquareIconButton(
        size: size,
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: textToCopy));
        },
        icon: icon,
      ),
    );
  }
}
