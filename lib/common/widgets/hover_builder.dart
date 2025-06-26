import 'package:flutter/material.dart';

class HoverBuilder extends StatefulWidget {
  final MouseCursor cursor;
  final Widget Function(bool isHover) builder;

  const HoverBuilder({
    super.key,
    required this.builder,
    this.cursor = MouseCursor.defer,
  });

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
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