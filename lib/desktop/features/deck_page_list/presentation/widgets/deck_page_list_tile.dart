import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/core/constants/typography.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_page.dart';

class DeckPageListTile extends StatelessWidget {
  final DeckPage page;
  final bool isCurrent;
  final bool isEditing;
  final Widget? trailing;
  final VoidCallback? onSelect;
  final void Function(String newPageName)? onStopEditing;

  const DeckPageListTile({
    super.key,
    required this.page,
    this.isCurrent = false,
    this.isEditing = false,
    this.trailing,
    this.onSelect,
    this.onStopEditing,
  });

  @override
  Widget build(BuildContext context) {
    final AppColorsData colors = AppColors.of(context);

    return Material(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: Spacing.xs,
          vertical: isEditing ? Spacing.xxs : Spacing.xs,
        ),
        minTileHeight: 20,
        iconColor: colors.onBackground,
        onTap: onSelect,
        trailing: trailing,
        textColor: colors.onBackground,
        selectedTileColor: colors.primary,
        selectedColor: colors.onPrimary,
        selected: isCurrent,
        title: _buildText(context),
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    if (isEditing && isCurrent) {
      return _buildTextField(context);
    }
    return Text(page.name, style: AppTypography.body);
  }

  TextFormField _buildTextField(BuildContext context) {
    return TextFormField(
      cursorHeight: 18,
      initialValue: page.name,
      onFieldSubmitted: onStopEditing,
      textInputAction: TextInputAction.done,
    );
  }
}
