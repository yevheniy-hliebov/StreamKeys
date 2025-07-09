import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BindingActionIcons {
  final BuildContext context;

  const BindingActionIcons._(this.context);

  factory BindingActionIcons.of(BuildContext context) {
    return BindingActionIcons._(context);
  }

  static String assetsPath = 'assets/action_icons';

  bool get _isLight => Theme.of(context).brightness == Brightness.light;
  Color get _iconColor => _isLight ? Colors.black : Colors.white;

  Widget get system {
    return SvgPicture.asset(
      '$assetsPath/system.svg',
      colorFilter: ColorFilter.mode(_iconColor, BlendMode.srcIn),
    );
  }

  Widget get website {
    return SvgPicture.asset(
      '$assetsPath/website.svg',
      colorFilter: ColorFilter.mode(_iconColor, BlendMode.srcIn),
    );
  }

  Widget get launcFileOrApp {
    return SvgPicture.asset(
      '$assetsPath/launch_file_or_app.svg',
      colorFilter: ColorFilter.mode(_iconColor, BlendMode.srcIn),
    );
  }
}
