import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:streamkeys/core/constants/spacing.dart';

class AppShell extends StatelessWidget {
  final Widget? leading;
  final String title;
  final List<Widget>? actions;
  final Widget Function(Widget appShell, bool isAppBar, bool isLandscapeLeft)
  builder;

  const AppShell({
    super.key,
    this.leading,
    this.title = '',
    this.actions,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return NativeDeviceOrientedWidget(
      useSensor: true,
      portrait: (context) {
        return builder(_buildAppBar(context), true, false);
      },
      landscapeLeft: (context) {
        return builder(_sideBar(context, true), false, true);
      },
      landscapeRight: (context) {
        return builder(_sideBar(context, false), false, false);
      },
      portraitDown: (context) {
        return builder(_sideBar(context, true), false, false);
      },
      fallback: (context) {
        return builder(const SizedBox(), false, false);
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: leading,
      centerTitle: true,
      title: Text(title, style: TextTheme.of(context).titleSmall),
      actions: actions,
    );
  }

  Widget _sideBar(BuildContext context, bool isLeft) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    final titleWidget = RotatedBox(
      quarterTurns: isLeft ? 3 : 1,
      child: Text(
        title,
        style: TextTheme.of(context).titleSmall,
        textAlign: TextAlign.center,
      ),
    );

    return Container(
      width: 72,
      padding: EdgeInsets.only(top: statusBarHeight),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Stack(
          alignment: Alignment.center,
          children: [
            titleWidget,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (leading != null) leading!,
                if (actions != null)
                  Column(
                    spacing: Spacing.xs,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: actions!,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
