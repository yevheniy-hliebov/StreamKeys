import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/core/constants/typography.dart';

class DeckPageListTile extends StatelessWidget {
  final String pageName;
  final bool isCurrent;
  final bool isEditing;
  final Widget? trailing;
  final VoidCallback? onSelect;
  final void Function(String newPageName)? onStopEditing;

  const DeckPageListTile({
    super.key,
    required this.pageName,
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
        contentPadding: const EdgeInsets.all(Spacing.xs),
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
    return Text(
      pageName,
      style: AppTypography.body,
    );
  }

  TextFormField _buildTextField(BuildContext context) {
    return TextFormField(
      initialValue: pageName,
      onFieldSubmitted: onStopEditing,
      textInputAction: TextInputAction.done,
      style: AppTypography.body,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(Spacing.xs),
      ),
    );
  }
}
