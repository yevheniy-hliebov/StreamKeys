import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/screen/action_library.dart';
import 'package:streamkeys/common/widgets/tabs/page_tab.dart';
import 'package:streamkeys/desktop/features/deck/presentation/widgets/deck_layout.dart';
import 'package:streamkeys/desktop/features/deck_page_list/bloc/deck_page_list_bloc.dart';
import 'package:streamkeys/desktop/features/deck_page_list/presentation/widgets/deck_page_list.dart';
import 'package:streamkeys/desktop/features/key_bindings/bloc/key_bindings_bloc.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/screens/key_editor.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/grid/grid_area_stack.dart';

class GridDeckScreen extends StatelessWidget with PageTab {
  const GridDeckScreen({super.key});

  @override
  Widget get pageView => this;

  @override
  String get label => 'Grid Deck';

  @override
  Widget get icon => const Icon(Icons.grid_view, size: 18);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GridKeyBindingsBloc(context.read<GridDeckPageListBloc>())
            ..add(KeyBindingsInit()),
      child: DeckLayout(
        leftSide: const DeckPageList<GridDeckPageListBloc>(),
        rightSide: Container(
          color: AppColors.of(context).surface,
          child: const ActionLibrary(),
        ),
        mainTop: const GridAreaStack(),
        mainBottom: const KeyEditor<GridKeyBindingsBloc>(),
      ),
    );
  }
}
