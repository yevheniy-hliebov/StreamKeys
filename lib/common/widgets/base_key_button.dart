import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/common/theme/custom/key_button_theme.dart';

class BaseKeyButton extends StatefulWidget {
  final String tooltipMessage;
  final double size;
  final Color? backgroundColor;
  final bool isSelected;
  final bool isDragHighlighted;
  final void Function()? onTap;
  final Widget? child;

  const BaseKeyButton({
    super.key,
    this.onTap,
    required this.size,
    this.backgroundColor,
    this.isSelected = false,
    this.isDragHighlighted = false,
    this.tooltipMessage = '',
    this.child,
  });

  @override
  State<BaseKeyButton> createState() => _BaseKeyButtonState();
}

class _BaseKeyButtonState extends State<BaseKeyButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = KeyButtonTheme(context: context);

    return Tooltip(
      message: widget.isDragHighlighted ? '' : widget.tooltipMessage,
      child: _settingInkWell(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 20),
          width: widget.size,
          height: widget.size,
          decoration: theme.getDecoration(
            isSelected: widget.isSelected,
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
                  color: SColors.of(context).actionButtonBackground,
                ),
                Container(
                  color: widget.isDragHighlighted
                      ? SColors.primaryWithOpacity
                      : widget.backgroundColor,
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
