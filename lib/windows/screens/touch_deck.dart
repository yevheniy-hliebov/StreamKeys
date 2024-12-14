import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/windows/providers/deck_pages_provider.dart';
import 'package:streamkeys/windows/widgets/left_side_bar.dart';
import 'package:streamkeys/windows/widgets/right_side_bar.dart';
import 'package:streamkeys/windows/widgets/touch/touch_map_setting.dart';

class TouchDeck extends StatelessWidget {
  const TouchDeck({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DeckPagesProvider('touch'),
      child: Consumer<DeckPagesProvider>(builder: (context, provider, child) {
        return Row(
          children: [
            const LeftSideBar(),
            VerticalDivider(
              thickness: 4,
              color: SColors.of(context).outlineVariant,
              width: 0,
            ),
            TouchMapSetting(currentPage: provider.currentPage),
            VerticalDivider(
              thickness: 4,
              color: SColors.of(context).outlineVariant,
              width: 0,
            ),
            const SizedBox(width: 4),
            const RightSideBar(),
          ],
        );
      }),
    );
  }
}
