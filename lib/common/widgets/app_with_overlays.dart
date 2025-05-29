import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/utils/navigate_to_page.dart';

class AppWithOverlays extends StatelessWidget {
  final Widget home;
  final List<Widget> overlays;
  final double spacing;

  const AppWithOverlays({
    required this.home,
    required this.overlays,
    this.spacing = 8.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Navigator(
          key: appNavigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (_) => home,
              settings: settings,
            );
          },
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            color: SColors.of(context).surface,
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: overlays
                  .map((widget) => Padding(
                        padding: EdgeInsets.only(left: spacing),
                        child: widget,
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
