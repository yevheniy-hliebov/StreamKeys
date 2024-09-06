import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/custom/action_button_theme.dart';

class ActionButton extends StatefulWidget {
  final String tooltipMessage;
  final double size;
  final void Function()? onTap;
  final Widget? child;

  const ActionButton({
    super.key,
    this.tooltipMessage = '',
    required this.size,
    this.onTap,
    this.child,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = ActionButtonTheme(context: context);

    return Tooltip(
      message: widget.tooltipMessage,
      child: _settingInkWell(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 20),
          width: widget.size,
          height: widget.size,
          decoration: theme.getDecoration(isPressed: _isPressed),
          transform: Matrix4.translationValues(
            _isPressed ? 2 : 0,
            _isPressed ? 2 : 0,
            0,
          ),
          child: widget.child,
        ),
      ),
    );
  }

  InkWell _settingInkWell({required Widget child}) {
    return InkWell(
      onTap: widget.onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: child,
    );
  }
}
