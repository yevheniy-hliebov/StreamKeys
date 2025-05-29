import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/features/deck_pages/bloc/deck_pages_bloc.dart';
import 'package:streamkeys/features/deck_pages/widgets/deck_pages_action_button.dart';

class DeckPagesHeader extends StatelessWidget {
  const DeckPagesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DeckPagesBloc>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Pages',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            DeckPagesActionButton(
              iconData: Icons.add,
              onPressed: () => bloc.add(const DeckPagesAddEvent()),
            ),
            DeckPagesActionButton(
              iconData: Icons.edit,
              onPressed: () => bloc.add(const DeckPagesStartRenameEvent()),
            ),
            DeckPagesActionButton(
              iconData: Icons.delete,
              onPressed: () => bloc.add(const DeckPagesDeleteEvent()),
            ),
          ],
        ),
      ],
    );
  }
}
