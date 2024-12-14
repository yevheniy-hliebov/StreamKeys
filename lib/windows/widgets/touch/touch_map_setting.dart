import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/windows/providers/touch_deck_provider.dart';
import 'package:streamkeys/windows/widgets/setting_button_frame.dart';
import 'package:streamkeys/windows/widgets/touch/touch_button_map.dart';

class TouchMapSetting extends StatelessWidget {
  final String? currentPage;

  const TouchMapSetting({
    super.key,
    this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    if (currentPage == null) {
      return const SizedBox();
    }

    return ChangeNotifierProvider(
      key: ValueKey(currentPage),
      create: (context) => TouchDeckProvider(currentPage!),
      child: Consumer<TouchDeckProvider>(builder: (context, provider, child) {
        return Expanded(
          child: Column(
            children: [
              const TouchButtonMap(),
              Divider(
                thickness: 4,
                color: SColors.of(context).outlineVariant,
                height: 0,
              ),
              SettingButtonFrame(
                deckType: 'touch',
                selectedButtonInfo: provider.selectedButtonInfo,
                onUpdate: (updatedInfo) {
                  provider.updateSelectedButtonInfo(updatedInfo);
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
