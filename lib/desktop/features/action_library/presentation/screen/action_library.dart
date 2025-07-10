import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/helpers/for.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_category.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/category_expansion_tile.dart';
import 'package:streamkeys/desktop/features/deck/presentation/widgets/deck_devider.dart';

class ActionLibrary extends StatelessWidget {
  const ActionLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    final library = BindingActionCategory.library;

    return Column(
      children: For.fromList<BindingActionCategory>(
        items: library,
        generator: (category) {
          return [
            CategoryExpansionTile(category: category),
            const DeckDevider(axis: Axis.horizontal),
          ];
        },
      ),
    );
  }
}
