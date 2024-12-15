import 'package:streamkeys/windows/models/actions/obs/hidden_source.dart';
import 'package:streamkeys/windows/models/actions/obs/mute_source.dart';
import 'package:streamkeys/windows/models/actions/obs/set_active_scene.dart';
import 'package:streamkeys/windows/models/actions/obs/toogle_mute_source.dart';
import 'package:streamkeys/windows/models/actions/obs/toogle_visible_source.dart';
import 'package:streamkeys/windows/models/actions/obs/unmute_source.dart';
import 'package:streamkeys/windows/models/actions/obs/visible_source.dart';
import 'package:streamkeys/windows/models/actions/open_app_and_file.dart';
import 'package:streamkeys/windows/models/actions/website.dart';
import 'package:streamkeys/windows/models/base_action.dart';

class CategoryActions {
  final String name;
  final ListActions actions;

  const CategoryActions({
    required this.name,
    this.actions = const [],
  });

  static List<CategoryActions> categories = [
    CategoryActions(name: 'Toolbox', actions: [
      OpenAppAndFile(),
      Website(),
    ]),
    CategoryActions(name: 'OBS Studio', actions: [
      SetActiveScene(),
      MuteSource(),
      UnmuteSource(),
      ToogleMuteSource(),
      VisibleSource(),
      HiddenSource(),
      ToogleVisibleSource(),
    ]),
  ];
}
