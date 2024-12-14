import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/windows/providers/browse_provider.dart';
import 'package:streamkeys/windows/providers/deck_pages_provider.dart';
import 'package:streamkeys/windows/providers/hidmacros_integration_provider.dart';
import 'package:streamkeys/windows/widgets/hid_macros_dialog.dart';
import 'package:streamkeys/windows/widgets/keyboard/keyboard_map_setting.dart';
import 'package:streamkeys/windows/widgets/left_side_bar.dart';
import 'package:streamkeys/windows/widgets/right_side_bar.dart';

class KeyboardDeck extends StatelessWidget {
  const KeyboardDeck({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DeckPagesProvider('keyboard'),
        ),
        ChangeNotifierProvider(
          create: (context) => HidmacrosIntegrationProvider(),
        ),
      ],
      child: Consumer<HidmacrosIntegrationProvider>(
        builder: (context, provider, child) {
          // print('provider.filePath.isEmpty ${provider.filePath.isEmpty}');
          if (provider.filePath.isEmpty) {
            final browseProvider = Provider.of<BrowseProvider>(context);
            return HidMacrosDialog(
              browseProvider: browseProvider,
              selectedKeyboard: provider.selectedKeyboard,
            );
          }

          return Row(
            children: [
              const LeftSideBar(),
              VerticalDivider(
                thickness: 4,
                color: SColors.of(context).outlineVariant,
                width: 0,
              ),
              const KeyboardMapSetting(),
              VerticalDivider(
                thickness: 4,
                color: SColors.of(context).outlineVariant,
                width: 0,
              ),
              const SizedBox(width: 4),
              const RightSideBar(),
            ],
          );
        },
      ),
    );
  }
}
