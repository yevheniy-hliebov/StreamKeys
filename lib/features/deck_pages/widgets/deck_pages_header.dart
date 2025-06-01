import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/features/deck_pages/bloc/deck_pages_bloc.dart';
import 'package:streamkeys/features/deck_pages/data/models/deck_type_enum.dart';
import 'package:streamkeys/features/deck_pages/widgets/deck_pages_action_button.dart';

class DeckPagesHeaderWrapper extends StatelessWidget {
  final DeckType deckType;

  const DeckPagesHeaderWrapper({
    super.key,
    required this.deckType,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = deckType == DeckType.keyboard
        ? context.read<KeyboardDeckPagesBloc>()
        : context.read<GridDeckPagesBloc>();

    return DeckPagesHeader(
      onAdd: () => bloc.add(const DeckPagesAddEvent()),
      onEdit: () => bloc.add(const DeckPagesStartRenameEvent()),
      onDelete: () => bloc.add(const DeckPagesDeleteEvent()),
    );
  }
}

class DeckPagesHeader extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DeckPagesHeader({
    super.key,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
              onPressed: onAdd,
            ),
            DeckPagesActionButton(
              iconData: Icons.edit,
              onPressed: onEdit,
            ),
            DeckPagesActionButton(
              iconData: Icons.delete,
              onPressed: onDelete,
            ),
          ],
        ),
      ],
    );
  }
}
