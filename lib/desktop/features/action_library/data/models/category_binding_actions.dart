import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/index.dart';

class CategoryBindingActions {
  final String name;
  final List<BindingAction> actions;

  const CategoryBindingActions({
    required this.name,
    this.actions = const [],
  });

  static List<CategoryBindingActions> library = [
    CategoryBindingActions(name: 'System', actions: [
      // OpenAppAndFile(),
      WebsiteBindingAction(),
    ]),
  ];
}