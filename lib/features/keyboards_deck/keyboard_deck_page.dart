import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/common/widgets/resizable_columns.dart';
import 'package:streamkeys/common/widgets/resizable_rows.dart';
import 'package:streamkeys/features/action_library/action_library.dart';
import 'package:streamkeys/features/action_library/bloc/drag_status_bloc.dart';
import 'package:streamkeys/features/deck_pages/bloc/deck_pages_bloc.dart';
import 'package:streamkeys/features/deck_pages/data/repositories/deck_pages_repository.dart';
import 'package:streamkeys/features/deck_pages/deck_pages.dart';
import 'package:streamkeys/features/keyboards_deck/bloc/keyboard_map_bloc.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/keyboard_map_wrapper.dart';
import 'package:streamkeys/features/settings/widgets/setting_button.dart';

class KeyboardDeckPage extends StatelessWidget {
  const KeyboardDeckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DeckPagesBloc(
            DeckPagesRepository(DeckType.keyboard),
          ),
        ),
        BlocProvider(create: (_) => KeyboardMapBloc()),
        BlocProvider(create: (_) => DragStatusBloc()),
      ],
      child: DragAwareCursor(
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
                  KeyboardMapWrapper(),
                  ButtonActionsSetting(),
                ],
              ),
              const ActionLibrary(),
            ],
          ),
        ),
      ),
    );
  }
}

class DragAwareCursor extends StatelessWidget {
  final Widget? child;

  const DragAwareCursor({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DragStatusBloc, DragState>(builder: (context, state) {
      MouseCursor cursor = MouseCursor.defer;

      if (state is DragActive) {
        cursor = SystemMouseCursors.click;
      }

      return MouseRegion(
        cursor: cursor,
        child: child,
      );
    });
  }
}
