import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/common/widgets/resizable_columns.dart';
import 'package:streamkeys/common/widgets/resizable_rows.dart';
import 'package:streamkeys/features/action_library/action_library.dart';
import 'package:streamkeys/features/deck_pages/bloc/deck_pages_bloc.dart';
import 'package:streamkeys/features/deck_pages/data/repositories/deck_pages_repository.dart';
import 'package:streamkeys/features/deck_pages/deck_pages.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/button_actions_setting.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/keyboard_map.dart';
import 'package:streamkeys/features/settings/widgets/setting_button.dart';

class KeyboardDeckPage extends StatelessWidget {
  const KeyboardDeckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeckPagesBloc(
        DeckPagesRepository(DeckType.keyboard),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Keyboard deck'),
          actions: const [
            SettingButton(),
            SizedBox(width: 4),
          ],
          backgroundColor: SColors.of(context).surface,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: Container(
              height: 4,
              color: SColors.of(context).outlineVariant,
            ),
          ),
        ),
        body: ResizableColumns(
          storageKey: 'keyboard_deck_columns_layout',
          dividerWidth: 4,
          dividerColor: SColors.of(context).outlineVariant,
          initialWidths: const [216, 1459, 240],
          minWidths: const [201, 200, 240],
          children: [
            const DeckPages(),
            ResizableRows(
              storageKey: 'keyboard_deck_columns_layout',
              dividerHeight: 4,
              dividerColor: SColors.of(context).outlineVariant,
              initialHeights: const [500, 300],
              minHeights: const [196, 200],
              children: const [
                KeyboardMap(
                  keyboardType: KeyboardType.full,
                ),
                ButtonActionsSetting(),
              ],
            ),
            const ActionLibrary(),
          ],
        ),
      ),
    );
  }
}
