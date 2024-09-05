import 'package:flutter/material.dart';
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
    return Tooltip(
      message: widget.action.name,
      child: _settingGestureDetector(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 20),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            border: Border.all(
              color: const Color(0xFF2F2F2F),
              width: 1,
            ),
            boxShadow: _boxShadow,
            borderRadius: BorderRadius.circular(5),
          ),
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

  GestureDetector _settingGestureDetector({required Widget child}) {
    return GestureDetector(
      onTap: widget.onTap,
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

  List<BoxShadow> get _boxShadow {
    const boxShadow = BoxShadow(
      offset: Offset(2, 2),
      blurRadius: 0,
      color: Colors.black,
    );
    return _isPressed ? [] : [boxShadow];
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
