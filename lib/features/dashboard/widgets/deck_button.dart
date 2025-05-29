import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';

class DeckButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const DeckButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      constraints: const BoxConstraints(
        maxWidth: 240,
      ),
      child: FilledButton(
        onPressed: onPressed,
        style: _getButtonStyle(context),
        child: Text(text),
      ),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(SColors.of(context).surface),
      foregroundColor: WidgetStatePropertyAll(SColors.of(context).onSurface),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 22),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 30, vertical: 24),
      ),
    );
  }
}
