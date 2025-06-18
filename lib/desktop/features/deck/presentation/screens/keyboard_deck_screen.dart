import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/widgets/page_tab.dart';
import 'package:streamkeys/desktop/features/deck/presentation/widgets/deck_layout.dart';
import 'package:streamkeys/desktop/features/deck_page_list/bloc/deck_page_list_bloc.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_type.dart';
import 'package:streamkeys/desktop/features/deck_page_list/presentation/widgets/deck_page_list.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/key_grid_area.dart';

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
    return DeckLayout(
      leftSide: const DeckPageList<KeyboardDeckPageListBloc>(),
      rightSide: Container(
        color: AppColors.of(context).surface,
      ),
      mainTop: const KeyGridArea(deckType: DeckType.keyboard),
      mainBottom: Container(
        color: AppColors.of(context).surface,
      ),
    );
  }
}
