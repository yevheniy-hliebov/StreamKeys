import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/desktop/features/deck/presentation/widgets/deck_devider.dart';
import 'package:streamkeys/desktop/features/key_bindings/bloc/key_bindings_bloc.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/models/key_binding_data.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_binding_action_list.dart';
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
            final keyBindingData =
                state.currentKeyBindingData ?? KeyBindingData.create();
            final bloc = context.read<T>();

            return Row(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 318),
                  child: KeySettingPanel(
                    key: Key(keyBindingData.id),
                    keyData: keyData,
                    keyBindingData: keyBindingData,
                    onClearPressed: () {
                      bloc.add(
                        KeyBindingsSaveDataOnPage(
                          keyCode: keyData.keyCode,
                          keyBindingData: keyBindingData.clear(),
                        ),
                      );
                    },
                    onNameChanged: (newValue) {
                      bloc.add(
                        KeyBindingsSaveDataOnPage(
                          keyCode: keyData.keyCode,
                          keyBindingData: keyBindingData.copyWith(
                            name: newValue,
                          ),
                        ),
                      );
                    },
                    onImagePathChanged: (newValue) {
                      bloc.add(
                        KeyBindingsSaveDataOnPage(
                          keyCode: keyData.keyCode,
                          keyBindingData: keyBindingData.copyWith(
                            imagePath: newValue,
                          ),
                        ),
                      );
                    },
                    onColorChanged: (newValue) {
                      bloc.add(
                        KeyBindingsSaveDataOnPage(
                          keyCode: keyData.keyCode,
                          keyBindingData: keyBindingData.copyWith(
                            backgroundColor: newValue,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const DeckDevider(axis: Axis.vertical),
                Flexible(
                  child: KeyBindingActionList(
                    actions: keyBindingData.actions,
                    onActionAdded: (action) {
                      bloc.add(
                        KeyBindingsAddAction(
                          keyCode: keyData.keyCode,
                          action: action.copy(),
                        ),
                      );
                    },
                    onActionUpdated: (index, updatedAction) {
                      bloc.add(
                        KeyBindingsUpdateAction(
                          keyCode: keyData.keyCode,
                          index: index,
                          updatedAction: updatedAction,
                        ),
                      );
                    },
                    onDeleteActionPressed: (index) {
                      bloc.add(
                        KeyBindingsDeleteAction(
                          keyCode: keyData.keyCode,
                          index: index,
                        ),
                      );
                    },
                    onReorderActons: (oldIndex, newIndex) {
                      bloc.add(
                        KeyBindingsReorderActions(
                          keyCode: keyData.keyCode,
                          oldIndex: oldIndex,
                          newIndex: newIndex,
                        ),
                      );
                    },
                  ),
                ),
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
