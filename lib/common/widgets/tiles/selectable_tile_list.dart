import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/helpers/for.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/spacing.dart';

class SelectableTileList<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final T? selectedItem;
  final String Function(T item) getLabel;
  final String? Function(T item)? getTooltip;
  final void Function(T item)? onTap;

  const SelectableTileList({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.getLabel,
    this.onTap,
    this.getTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: Spacing.md,
      children: [
        Text(title, style: TextTheme.of(context).bodyLarge),
        Container(
          decoration: BoxDecoration(
            color: AppColors.of(context).surface,
            border: Border.all(
              width: 1,
              color: AppColors.of(context).onSurface,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            children: For.generateChildren(
              items.length,
              generator: (index) {
                final item = items[index];
                final isSelected = item == selectedItem;

                final tile = ListTile(
                  selected: isSelected,
                  tileColor: AppColors.of(context).surface,
                  selectedColor: AppColors.of(context).onPrimary,
                  selectedTileColor: AppColors.of(context).primary,
                  onTap: () => onTap?.call(item),
                  title: Text(getLabel(item)),
                );

                final tileWithTooltip = Tooltip(
                  message: getTooltip?.call(item) ?? '',
                  waitDuration: const Duration(seconds: 2),
                  child: tile,
                );

                return [
                  Material(
                    type: MaterialType.transparency,
                    child: getTooltip != null ? tileWithTooltip : tile,
                  ),
                ];
              },
            ),
          ),
        ),
      ],
    );
  }
}
