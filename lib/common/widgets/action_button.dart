import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/custom/action_button_theme.dart';

class BaseActionButton extends StatefulWidget {
  final String tooltipMessage;
  final double size;
  final Color? backgroundColor;
  final void Function()? onTap;
  final Widget? child;

  const BaseActionButton({
    super.key,
    this.tooltipMessage = '',
    required this.size,
    this.backgroundColor,
    this.onTap,
    this.child,
  });

  @override
  State<BaseActionButton> createState() => _BaseActionButtonState();
}

class _BaseActionButtonState extends State<BaseActionButton> {
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
          decoration: theme.getDecoration(
            isPressed: _isPressed,
          ),
          transform: Matrix4.translationValues(
            _isPressed ? 2 : 0,
            _isPressed ? 2 : 0,
            0,
          ),
          child: ClipRRect(
            borderRadius: theme.borderRadius,
            child: Stack(
              children: [
                Container(
                  color: theme.backgroundColor,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: widget.child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell _settingInkWell({required Widget child}) {
    return InkWell(
      onTap: widget.onTap,
      hoverColor: Colors.transparent,
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
