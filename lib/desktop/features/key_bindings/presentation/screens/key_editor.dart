import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/spacing.dart';
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
      padding: const EdgeInsets.all(Spacing.sm),
      child: BlocBuilder<T, KeyBindingsState>(
        builder: (context, state) {
          if (state is KeyBindingsLoaded) {
            if (state.currentKeyData == null) {
              return const KeyEditorPlaceholder();
            }

            final keyData = state.currentKeyData!;
            final bloc = context.read<T>();
            final keyBindingData = bloc.getKeyBindingData(keyData.keyCode);

            return KeySettingPanel(
              key: Key('${keyData.keyCode}-${keyBindingData.id}'),
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
            );
          } else {
            return const KeyEditorLoader();
          }
        },
      ),
    );
  }
}
