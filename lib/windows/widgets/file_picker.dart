import 'package:flutter/material.dart';

class Picker extends StatelessWidget {
  final String? toolTipMessage;
  final void Function()? onTap;
  final double size;
  final Widget? child;

  const Picker({
    super.key,
    this.toolTipMessage = '',
    this.onTap,
    this.size = 48,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: toolTipMessage,
      child: OutlinedButton(
        onPressed: onTap,
        style: ButtonStyle(
            padding: const WidgetStatePropertyAll(EdgeInsets.all(0)),
            fixedSize: WidgetStatePropertyAll(Size(size, size))),
        child: Container(
          child: child ?? const Icon(Icons.drive_folder_upload_outlined),
        ),
      ),
    );
  }
}
