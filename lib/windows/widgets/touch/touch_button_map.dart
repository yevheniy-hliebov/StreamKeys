import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/windows/models/base_action.dart';
import 'package:streamkeys/windows/models/keyboard/grid_template.dart';
import 'package:streamkeys/windows/providers/touch_deck_provider.dart';
import 'package:streamkeys/windows/widgets/menu_anchor.dart';
import 'package:streamkeys/windows/widgets/touch/touch_button.dart';

class TouchButtonMap extends StatelessWidget {
  const TouchButtonMap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TouchDeckProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              SMenuAchor<GridTemplate>(
                items: provider.grids,
                currentItem: provider.currentGrid,
                getItemText: (grid) {
                  return 'Grid [${grid.toString()}]';
                },
                onPressed: provider.updateGrid,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: SColors.of(context).outline,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              color: SColors.of(context).surface,
            ),
            child: SizedBox(
              width: provider.currentGrid.numberOfColumns * 55 +
                  (provider.currentGrid.numberOfColumns - 1) * 16,
              child: ReorderableWrap(
                spacing: 16,
                runSpacing: 16,
                onReorder: provider.reorderButton,
                children: [
                  for (int i = 0; i < provider.currentGrid.totalCells; i++) ...[
                    DragTarget<BaseAction>(
                      onAcceptWithDetails: (details) {
                        final action = details.data;
                        provider.setAction(i, action);
                      },
                      builder: (context, _, __) {
                        return TouchButton(
                          isSelected: provider.isSelectedTouchButton(i),
                          onTap: () {
                            provider.selectButton(i);
                          },
                          info: provider.getButonInfo(i),
                        );
                      },
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
