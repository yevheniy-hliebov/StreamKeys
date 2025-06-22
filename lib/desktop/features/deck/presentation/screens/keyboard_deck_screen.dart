import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/widgets/page_tab.dart';
import 'package:streamkeys/desktop/features/deck/presentation/widgets/deck_layout.dart';
import 'package:streamkeys/desktop/features/deck_page_list/bloc/deck_page_list_bloc.dart';
import 'package:streamkeys/desktop/features/deck_page_list/presentation/widgets/deck_page_list.dart';
import 'package:streamkeys/desktop/features/key_bindings/bloc/key_bindings_bloc.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/key_grid_area.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_area_wrapper.dart';

class KeyboardDeckScreen extends StatelessWidget with PageTab {
  const KeyboardDeckScreen({super.key});

  @override
  Widget get pageView => this;

  @override
  String get label => 'Keyboard Deck';

  @override
  IconData get iconData => Icons.keyboard_outlined;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => KeyboardKeyBindingsBloc(
        context.read<KeyboardDeckPageListBloc>(),
      )..add(KeyBindingsInit()),
      child: DeckLayout(
        leftSide: const DeckPageList<KeyboardDeckPageListBloc>(),
        rightSide: Container(
          color: AppColors.of(context).surface,
        ),
        mainTop: const KeyGridArea(
          child: KeyboardAreaWrapper(
            keyboardType: KeyboardType.numpad,
          ),
        ),
        mainBottom: Container(
          color: AppColors.of(context).surface,
        ),
      ),
    );
  }
}
