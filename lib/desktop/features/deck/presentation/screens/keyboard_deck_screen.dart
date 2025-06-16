import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/widgets/page_tab.dart';
import 'package:streamkeys/desktop/features/deck/presentation/widgets/deck_layout.dart';
import 'package:streamkeys/desktop/features/deck_page_list/bloc/deck_page_list_bloc.dart';
import 'package:streamkeys/desktop/features/deck_page_list/presentation/widgets/deck_page_list.dart';

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
      mainTop: Container(
        color: AppColors.of(context).background,
      ),
      mainBottom: Container(
        color: AppColors.of(context).surface,
      ),
    );
  }
}
