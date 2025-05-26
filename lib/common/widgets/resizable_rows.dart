import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResizableRows extends StatefulWidget {
  final List<Widget> children;
  final List<double> minHeights;
  final List<double>? initialHeights;
  final Color dividerColor;
  final double dividerHeight;
  final String? storageKey;

  const ResizableRows({
    super.key,
    required this.children,
    required this.minHeights,
    this.initialHeights,
    this.dividerColor = const Color(0xFFBDBDBD),
    this.dividerHeight = 8.0,
    this.storageKey,
  }) : assert(children.length == minHeights.length && children.length >= 2);

  @override
  State<ResizableRows> createState() => _ResizableRowsState();
}

class _ResizableRowsState extends State<ResizableRows> {
  late List<double> _heights;
  OverlayEntry? _cursorOverlay;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _heights = List.filled(widget.children.length, 0);
    if (widget.storageKey != null) {
      _loadSavedHeights();
    }
  }

  Future<void> _loadSavedHeights() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(widget.storageKey!);
    if (data != null) {
      try {
        final List<dynamic> decoded = jsonDecode(data);
        if (decoded.length == widget.children.length &&
            decoded.every((e) => e is num)) {
          setState(() {
            _heights = decoded.map((e) => (e as num).toDouble()).toList();
            _initialized = true;
          });
        }
      } catch (_) {}
    }
  }

  Future<void> _saveHeights() async {
    if (widget.storageKey == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(widget.storageKey!, jsonEncode(_heights));
  }

  void _showGlobalResizeCursor() {
    if (_cursorOverlay != null) return;
    _cursorOverlay = OverlayEntry(
      builder: (context) => MouseRegion(
        cursor: SystemMouseCursors.resizeRow,
        child: Container(color: Colors.transparent),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_cursorOverlay!);
  }

  void _removeGlobalResizeCursor() {
    _cursorOverlay?.remove();
    _cursorOverlay = null;
  }

  void _initHeights(double totalHeight, double totalDividerHeight) {
    final n = widget.children.length;
    if (_initialized) return;

    if (widget.initialHeights != null && widget.initialHeights!.length == n) {
      _heights = List.from(widget.initialHeights!);
      _heights[n - 2] = 0;
    } else {
      final equalHeight = (totalHeight - totalDividerHeight) / n;
      _heights = List.filled(n, equalHeight);
      _heights[n - 2] = 0;
    }

    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final totalHeight = constraints.maxHeight;
      final n = widget.children.length;
      final numDividers = n - 1;
      final totalDividerHeight = widget.dividerHeight * numDividers;

      if (_heights.every((h) => h == 0)) {
        _initHeights(totalHeight, totalDividerHeight);
      }

      final fixedHeightSum = _heights
          .asMap()
          .entries
          .where((e) => e.key != n - 2)
          .fold(0.0, (sum, e) => sum + e.value);

      final penultimateHeight =
          (totalHeight - totalDividerHeight - fixedHeightSum)
              .clamp(widget.minHeights[n - 2], double.infinity);

      _heights[n - 2] = penultimateHeight;

      List<Widget> children = [];

      for (int i = 0; i < n; i++) {
        children.add(SizedBox(
          height: _heights[i],
          child: widget.children[i],
        ));
        if (i < n - 1) {
          children.add(_buildDivider(i));
        }
      }

      return Column(children: children);
    });
  }

  Widget _buildDivider(int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: (_) => _showGlobalResizeCursor(),
      onVerticalDragUpdate: (details) {
        setState(() {
          final dy = details.delta.dy;
          final topIndex = index;
          final bottomIndex = index + 1;

          double topHeight = _heights[topIndex];
          double bottomHeight = _heights[bottomIndex];

          final minTop = widget.minHeights[topIndex];
          final minBottom = widget.minHeights[bottomIndex];

          double newTop = (topHeight + dy)
              .clamp(minTop, topHeight + bottomHeight - minBottom);
          double newBottom = topHeight + bottomHeight - newTop;

          _heights[topIndex] = newTop;
          _heights[bottomIndex] = newBottom;
        });
      },
      onVerticalDragEnd: (_) {
        _removeGlobalResizeCursor();
        _saveHeights();
      },
      onVerticalDragCancel: () {
        _removeGlobalResizeCursor();
        _saveHeights();
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeRow,
        child: Container(
          height: widget.dividerHeight,
          color: widget.dividerColor,
        ),
      ),
    );
  }
}
