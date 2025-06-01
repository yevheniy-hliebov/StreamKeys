import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/features/deck_pages/bloc/deck_pages_bloc.dart';

class DeckPageListTile extends StatelessWidget {
  final String pageName;
  final int index;
  final bool isCurrent;
  final bool isEditing;
  final void Function()? onTap;

  const DeckPageListTile({
    super.key,
    required this.pageName,
    required this.index,
    this.isCurrent = false,
    this.isEditing = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(5),
      iconColor: SColors.of(context).onBackground,
      onTap: onTap,
      trailing: ReorderableDragStartListener(
        index: index,
        child: const Icon(Icons.drag_handle),
      ),
      textColor: SColors.of(context).onBackground,
      title: _title(context),
    );
  }

  Widget _title(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: isEditing && isCurrent ? _buildTextField(context) : Text(pageName),
    );
  }

  TextFormField _buildTextField(BuildContext context) {
    return TextFormField(
      initialValue: pageName,
      onFieldSubmitted: (value) {
        context.read<DeckPagesBloc>().add(DeckPagesRenamedEvent(value));
      },
      textInputAction: TextInputAction.done,
      style: const TextStyle(fontSize: 16),
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        border: OutlineInputBorder(),
      ),
    );
  }
}
