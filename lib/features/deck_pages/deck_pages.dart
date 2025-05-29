import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/features/deck_pages/bloc/deck_pages_bloc.dart';
import 'package:streamkeys/features/deck_pages/widgets/deck_pages_header.dart';
import 'package:streamkeys/features/deck_pages/widgets/deck_pages_list.dart';

class DeckPages extends StatelessWidget {
  const DeckPages({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeckPagesBloc, DeckPagesState>(
      builder: (context, state) {
        return Container(
          color: SColors.of(context).surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DeckPagesHeader(),
              Divider(
                color: SColors.of(context).outlineVariant,
                thickness: 4,
                height: 0,
              ),
              const DeckPagesList(),
            ],
          ),
        );
      },
    );
  }
}
