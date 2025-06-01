import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/features/deck_pages/data/models/deck_type_enum.dart';
import 'package:streamkeys/features/deck_pages/widgets/deck_pages_header.dart';
import 'package:streamkeys/features/deck_pages/widgets/deck_pages_list.dart';

class DeckPages extends StatelessWidget {
  final DeckType deckType;

  const DeckPages({
    super.key,
    required this.deckType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SColors.of(context).surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DeckPagesHeaderWrapper(deckType: deckType),
          Divider(
            color: SColors.of(context).outlineVariant,
            thickness: 4,
            height: 0,
          ),
          DeckPagesListWrapper(deckType: deckType),
        ],
      ),
    );
  }
}
