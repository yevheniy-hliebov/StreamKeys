import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/windows/models/keyboard_device.dart';
import 'package:streamkeys/windows/providers/browse_provider.dart';
import 'package:streamkeys/windows/providers/deck_pages_provider.dart';
import 'package:streamkeys/windows/providers/hidmacros_integration_provider.dart';
import 'package:streamkeys/windows/providers/keyboard_deck_provider.dart';
import 'package:streamkeys/windows/widgets/hid_macros_dialog.dart';
import 'package:streamkeys/windows/widgets/keyboard/keyboard_button_map.dart';
import 'package:streamkeys/windows/widgets/setting_button_frame.dart';
import 'package:streamkeys/windows/widgets/menu_anchor.dart';

class KeyboardMapSetting extends StatelessWidget {
  const KeyboardMapSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final deckPagesProvider = Provider.of<DeckPagesProvider>(context);
    final browseProvider = Provider.of<BrowseProvider>(context);
    final hidmacrosIntegrationProvider =
        Provider.of<HidmacrosIntegrationProvider>(context);

    if (deckPagesProvider.currentPage == null) {
      return const SizedBox();
    }
    return ListenableProvider(
      key: ValueKey(deckPagesProvider.currentPage),
      create: (context) => KeyboardDeckProvider(deckPagesProvider.currentPage!),
      child: Consumer<KeyboardDeckProvider>(
        builder: (context, provider, child) {
          return Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 24,
                    left: 24,
                    right: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Select Keyboard'),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 250,
                                child: SMenuAchor<KeyboardDevice>(
                                  items: hidmacrosIntegrationProvider.keyboards,
                                  currentItem: hidmacrosIntegrationProvider
                                      .selectedKeyboard,
                                  getItemText: (keyboardDevice) {
                                    return keyboardDevice.name;
                                  },
                                  getItemTooltipMessage: (keyboardDevice) {
                                    return keyboardDevice.toString();
                                  },
                                  onPressed: hidmacrosIntegrationProvider
                                      .selectKeyboard,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Select Keyboard Type'),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 250,
                                child: SMenuAchor<String>(
                                  items: hidmacrosIntegrationProvider
                                      .keyboardTypes,
                                  currentItem: hidmacrosIntegrationProvider
                                      .selectedKeyboardType,
                                  getItemText: (keyboardType) {
                                    return keyboardType;
                                  },
                                  getItemTooltipMessage: (keyboardType) {
                                    return keyboardType;
                                  },
                                  onPressed: hidmacrosIntegrationProvider
                                      .selectKeyboardType,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () async {
                          await showHIDMacrosDialog(
                            context,
                            hidmacrosIntegrationProvider.selectedKeyboard,
                            browseProvider,
                          );
                        },
                        child: const Text('HidMacros'),
                      ),
                    ],
                  ),
                ),
                Scrollbar(
                  controller: scrollController,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    child: const KeyboardButtonMap(),
                  ),
                ),
                const SizedBox(height: 5),
                Divider(
                  thickness: 4,
                  color: SColors.of(context).outlineVariant,
                  height: 0,
                ),
                SettingButtonFrame(
                  key: Key(
                    provider.selectedButtonInfo == null
                        ? 'Empty'
                        : provider.selectedButtonInfo!.keyCode.toString(),
                  ),
                  deckType: 'keyboard',
                  selectedButtonInfo: provider.selectedButtonInfo,
                  onUpdate: (updatedInfo) {
                    provider.updateSelectedButtonInfo(updatedInfo);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
