import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/custom/action_button_theme.dart';
import 'package:streamkeys/windows/models/action.dart';

class ActionButton extends StatefulWidget {
  final ButtonAction action;
  final double size;
  final void Function()? onTap;

  const ActionButton({
    super.key,
    required this.action,
    required this.size,
    this.onTap,
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
      message: widget.action.name,
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
          child: _buildButtonActionContent(),
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

  Widget _buildButtonActionContent() {
    if (widget.action.imagePath == '') {
      return const Icon(Icons.add);
    }
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.file(widget.action.getImageFile()),
    );
  }
}
