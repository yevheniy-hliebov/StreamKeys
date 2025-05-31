import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/common/widgets/for.dart';

class SelectableTileList<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final T? selectedItem;
  final String Function(T item) getLabel;
  final String? Function(T item)? getTooltip;
  final void Function(T item) onTap;

  const SelectableTileList({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.getLabel,
    required this.onTap,
    this.getTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 16,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: SColors.of(context).surface,
            border: Border.all(
              width: 1,
              color: SColors.of(context).onSurface,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: For.generateWidgets(
              items.length,
              generator: (index) {
                final item = items[index];
                final isSelected = item == selectedItem;
                final tile = ListTile(
                  tileColor: isSelected
                      ? SColors.primary
                      : SColors.of(context).surface,
                  onTap: () => onTap(item),
                  title: Text(getLabel(item)),
                );

                return [
                  Material(
                    color: Colors.transparent,
                    child: getTooltip != null
                        ? Tooltip(
                            message: getTooltip!(item) ?? '',
                            waitDuration: const Duration(seconds: 2),
                            child: tile,
                          )
                        : tile,
                  )
                ];
              },
            ),
          ),
        ),
      ],
    );
  }
}
