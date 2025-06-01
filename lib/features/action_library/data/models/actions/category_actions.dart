import 'package:streamkeys/features/action_library/data/models/actions/index.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';

class CategoryActions {
  final String name;
  final List<BaseAction> actions;

  const CategoryActions({
    required this.name,
    this.actions = const [],
  });

  static List<CategoryActions> library = [
    CategoryActions(name: 'System', actions: [
      Website(),
    ]),
    CategoryActions(name: 'OBS Studio', actions: [
      SetActiveScene(),
      // MuteSource(),
      // UnmuteSource(),
      // ToogleMuteSource(),
      // VisibleSource(),
      // HiddenSource(),
      // ToogleVisibleSource(),
    ]),
  ];
}
