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
      OpenAppAndFile(),
      Website(),
    ]),
    CategoryActions(name: 'OBS Studio', actions: [
      SetActiveScene(),
      MuteSource(),
      UnMuteSource(),
      ToggleMuteSource(),
      VisibleSource(),
      HiddenSource(),
      ToggleVisibleSource(),
    ]),
  ];

  static String? getCategoryByActionType(String actionType) {
    try {
      final category = library.firstWhere(
        (category) =>
            category.actions.any((action) => action.actionType == actionType),
      );
      return category.name;
    } catch (e) {
      return null;
    }
  }
}
