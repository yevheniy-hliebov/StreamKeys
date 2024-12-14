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
  ];
}
