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

  // System
  Widget get system {
    return SvgPicture.asset(
      '$assetsPath/system.svg',
      colorFilter: _colorFilter,
    );
  }

  Widget get website {
    return SvgPicture.asset(
      '$assetsPath/website.svg',
      colorFilter: _colorFilter,
    );
  }

  Widget get launcFileOrApp {
    return SvgPicture.asset(
      '$assetsPath/launch_file_or_app.svg',
      colorFilter: _colorFilter,
    );
  }

  // OBS Studio

  Widget get obs {
    return SvgPicture.asset(
      '$assetsPath/obs.svg',
    );
  }

  Widget get setActiveScene {
    return SvgPicture.asset(
      '$assetsPath/set_active_scene.svg',
      colorFilter: _colorFilter,
    );
  }

  Widget get sourceMute {
    return SvgPicture.asset(
      '$assetsPath/source_mute.svg',
      colorFilter: _colorFilter,
    );
  }

  Widget get sourceVisibility {
    return SvgPicture.asset(
      '$assetsPath/source_visibility.svg',
      colorFilter: _colorFilter,
    );
  }

  Widget get obsScreenshot {
    return SvgPicture.asset(
      '$assetsPath/obs_screenshot.svg',
      colorFilter: _colorFilter,
    );
  }

  Widget get obsRecord {
    return SvgPicture.asset(
      '$assetsPath/obs_record.svg',
      colorFilter: _colorFilter,
    );
  }

  Widget get obsStream {
    return SvgPicture.asset(
      '$assetsPath/obs_stream.svg',
      colorFilter: _colorFilter,
    );
  }
}
