import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:streamkeys/common/models/typedefs.dart';

class ResizableColumns extends StatefulWidget {
  final List<Widget> children;
  final List<double> minWidths;
  final List<double>? initialWidths;
  final Color dividerColor;
  final double dividerWidth;
  final String? storageKey;

  const ResizableColumns({
    super.key,
    required this.children,
    required this.minWidths,
    this.initialWidths,
    this.dividerColor = const Color(0xFFBDBDBD),
    this.dividerWidth = 8.0,
    this.storageKey,
  }) : assert(children.length == minWidths.length && children.length >= 2);

  @override
  State<ResizableColumns> createState() => _ResizableColumnsState();
}

class _ResizableColumnsState extends State<ResizableColumns> {
  late List<double> _widths;
  OverlayEntry? _cursorOverlay;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _widths = List.filled(widget.children.length, 0);
    if (widget.storageKey != null) {
      _loadSavedWidths();
    }
  }

  FutureVoid _loadSavedWidths() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(widget.storageKey!);
    if (data != null) {
      try {
        final List<dynamic> decoded = jsonDecode(data);
        if (decoded.length == widget.children.length &&
            decoded.every((e) => e is num)) {
          setState(() {
            _widths = decoded.map((e) => (e as num).toDouble()).toList();
            _initialized = true;
          });
        }
      } catch (_) {}
    }
  }

  FutureVoid _saveWidths() async {
    if (widget.storageKey == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(widget.storageKey!, jsonEncode(_widths));
  }

  void _showGlobalResizeCursor() {
    if (_cursorOverlay != null) return;

    _cursorOverlay = OverlayEntry(
      builder: (context) => MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: Container(color: Colors.transparent),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_cursorOverlay!);
  }

  void _removeGlobalResizeCursor() {
    _cursorOverlay?.remove();
    _cursorOverlay = null;
  }

  void _initWidths(double totalWidth, double totalDividerWidth) {
    final n = widget.children.length;

    if (_initialized) return;

    if (widget.initialWidths != null && widget.initialWidths!.length == n) {
      _widths = List.from(widget.initialWidths!);
      _widths[n - 2] = 0;
    } else {
      final equalWidth = (totalWidth - totalDividerWidth) / n;
      _widths = List.filled(n, equalWidth);
      _widths[n - 2] = 0;
    }

    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final totalWidth = constraints.maxWidth;
      final n = widget.children.length;
      final numDividers = n - 1;
      final totalDividerWidth = widget.dividerWidth * numDividers;

      if (_widths.every((w) => w == 0)) {
        _initWidths(totalWidth, totalDividerWidth);
      }

      final fixedWidthSum = _widths
          .asMap()
          .entries
          .where((e) => e.key != n - 2)
          .fold(0.0, (sum, e) => sum + e.value);

      final penultimateWidth = (totalWidth - totalDividerWidth - fixedWidthSum)
          .clamp(widget.minWidths[n - 2], double.infinity);

      _widths[n - 2] = penultimateWidth;

      List<Widget> children = [];

      for (int i = 0; i < n; i++) {
        children.add(SizedBox(width: _widths[i], child: widget.children[i]));
        if (i < n - 1) {
          children.add(_buildDivider(i));
        }
      }

      return Row(children: children);
    });
  }

  Widget _buildDivider(int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (_) {
        _showGlobalResizeCursor();
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          final dx = details.delta.dx;
          final leftIndex = index;
          final rightIndex = index + 1;

          double leftWidth = _widths[leftIndex];
          double rightWidth = _widths[rightIndex];

          final minLeft = widget.minWidths[leftIndex];
          final minRight = widget.minWidths[rightIndex];

          double newLeft = (leftWidth + dx)
              .clamp(minLeft, leftWidth + rightWidth - minRight);
          double newRight = leftWidth + rightWidth - newLeft;

          _widths[leftIndex] = newLeft;
          _widths[rightIndex] = newRight;
        });
      },
      onHorizontalDragEnd: (_) {
        _removeGlobalResizeCursor();
        _saveWidths();
      },
      onHorizontalDragCancel: () {
        _removeGlobalResizeCursor();
        _saveWidths();
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: Container(
          width: widget.dividerWidth,
          color: widget.dividerColor,
        ),
      ),
    );
  }
}
