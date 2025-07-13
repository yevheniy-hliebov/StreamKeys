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
  ColorFilter get _colorFilter => ColorFilter.mode(_iconColor, BlendMode.srcIn);

  Widget _getSvgPicture(
    String fileName, {
    bool isColorChangeAllowed = true,
  }) {
    return SvgPicture.asset(
      '$assetsPath/$fileName',
      colorFilter: isColorChangeAllowed ? _colorFilter : null,
    );
  }

  // System
  Widget get system => _getSvgPicture('system.svg');

  Widget get website => _getSvgPicture('website.svg');

  Widget get launcFileOrApp => _getSvgPicture('launch_file_or_app.svg');

  // OBS Studio

  Widget get obs => _getSvgPicture('obs.svg', isColorChangeAllowed: false);

  Widget get setActiveScene => _getSvgPicture('set_active_scene.svg');

  Widget get sourceMute => _getSvgPicture('source_mute.svg');

  Widget get sourceVisibility => _getSvgPicture('source_visibility.svg');

  Widget get obsScreenshot => _getSvgPicture('obs_screenshot.svg');

  Widget get obsRecord => _getSvgPicture('obs_record.svg');

  Widget get obsStream => _getSvgPicture('obs_stream.svg');
}
