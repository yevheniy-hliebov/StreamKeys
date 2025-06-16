import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/deck/presentation/widgets/deck_devider.dart';
import 'package:streamkeys/desktop/features/deck_page_list/presentation/widgets/deck_page_list_header.dart';
import 'package:streamkeys/desktop/features/deck_page_list/presentation/widgets/deck_page_list_items.dart';

class DeckPageList extends StatelessWidget {
  const DeckPageList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.of(context).surface,
      child: const Column(
        children: <Widget>[
          DeckPageListHeader(),
          DeckDevider(axis: Axis.vertical),
          DeckPageListItems()
        ],
      ),
    );
  }
}
