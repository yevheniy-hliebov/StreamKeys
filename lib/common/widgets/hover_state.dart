import 'package:flutter/material.dart';

class HoverState extends StatefulWidget {
  final MouseCursor cursor;
  final Widget Function(bool isHover) builder;

  const HoverState({
    super.key,
    required this.builder,
    this.cursor = MouseCursor.defer,
  });

  @override
  State<HoverState> createState() => _HoverStateState();
}

class _HoverStateState extends State<HoverState> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHover = true),
      onExit: (_) => setState(() => _isHover = false),
      cursor: widget.cursor,
      child: widget.builder(_isHover),
    );
  }
}
