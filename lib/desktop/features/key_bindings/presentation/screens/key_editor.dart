import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/deck/presentation/widgets/deck_devider.dart';
import 'package:streamkeys/desktop/features/key_bindings/bloc/key_bindings_bloc.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_editor_loader.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_editor_placeholder.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_setting_panel.dart';

class KeyEditor<T extends KeyBindingsBloc> extends StatelessWidget {
  const KeyEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.of(context).surface,
      child: BlocBuilder<T, KeyBindingsState>(
        builder: (context, state) {
          if (state is KeyBindingsLoaded) {
            if (state.currentKeyData == null) {
              return const KeyEditorPlaceholder();
            }

            final keyData = state.currentKeyData!;
            final bloc = context.read<T>();
            final keyBindingData = bloc.getKeyBindingData(keyData.keyCode);

            return Row(
              key: Key('${keyData.keyCode}-${keyBindingData.id}'),
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 318,
                  ),
                  child: KeySettingPanel(
                    keyData: keyData,
                    keyBindingData: keyBindingData,
                    onClearPressed: () {
                      bloc.add(KeyBindingsSaveDataOnPage(
                        keyData.keyCode,
                        keyBindingData.clear(),
                      ));
                    },
                    onNameChanged: (newValue) {
                      bloc.add(KeyBindingsSaveDataOnPage(
                        keyData.keyCode,
                        keyBindingData.copyWith(name: newValue),
                      ));
                    },
                    onImagePathChanged: (newValue) {
                      bloc.add(KeyBindingsSaveDataOnPage(
                        keyData.keyCode,
                        keyBindingData.copyWith(imagePath: newValue),
                      ));
                    },
                    onColorChanged: (newValue) {
                      bloc.add(KeyBindingsSaveDataOnPage(
                        keyData.keyCode,
                        keyBindingData.copyWith(backgroundColor: newValue),
                      ));
                    },
                  ),
                ),
                const DeckDevider(axis: Axis.vertical),
                const Flexible(child: SizedBox()), // stub for actions
              ],
            );
          } else {
            return const KeyEditorLoader();
          }
        },
      ),
    );
  }
}
