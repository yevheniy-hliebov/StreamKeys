import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/small_icon_button.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/core/constants/typography.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/base_key_data.dart';

class KeyEditorHeader extends StatelessWidget {
  final BaseKeyData keyData;
  final VoidCallback? onClearPressed;

  const KeyEditorHeader({
    super.key,
    required this.keyData,
    this.onClearPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Spacing.xs,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: Spacing.xs,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Bind key: ${keyData.name}',
              style: AppTypography.subtitle,
            ),
            SmallIconButton(
              tooltip: 'Clear',
              onPressed: onClearPressed,
              icon: Icons.cleaning_services,
            ),
          ],
        ),
        Divider(
          height: 2,
          thickness: 2,
          color: AppColors.of(context).onSurface,
        ),
      ],
    );
  }
}
