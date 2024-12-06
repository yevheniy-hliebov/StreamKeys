import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/windows/providers/browse_provider.dart';
import 'package:streamkeys/windows/widgets/left_side_bar.dart';
import 'package:streamkeys/windows/widgets/right_side_bar.dart';
import 'package:streamkeys/windows/widgets/touch_map_setting.dart';

class TouchDeck extends StatelessWidget {
  const TouchDeck({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            const LeftSideBar(),
            VerticalDivider(
              thickness: 4,
              color: SColors.of(context).outlineVariant,
              width: 0,
            ),
            const TouchMapSetting(),
            VerticalDivider(
              thickness: 4,
              color: SColors.of(context).outlineVariant,
              width: 0,
            ),
            const SizedBox(width: 4),
            const RightSideBar(),
          ],
        ),
        Consumer<BrowseProvider>(
          builder: (context, provider, child) {
            if (provider.isLockedApp) {
              return const ModalBarrier(
                dismissible: false,
                color: Colors.black54,
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
