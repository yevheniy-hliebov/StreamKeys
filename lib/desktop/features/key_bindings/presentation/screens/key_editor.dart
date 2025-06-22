import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_bindings/bloc/key_bindings_bloc.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_color_field.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_editor_header.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_editor_loader.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_editor_placeholder.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_image_field.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_name_field.dart';

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
            final keyBindingData = bloc.getKeyBingingData(keyData.keyCode);

            return Column(
              key: Key(keyBindingData.id),
              spacing: Spacing.xs,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KeyEditorHeader(
                  keyData: keyData,
                  onClearPressed: () {
                    bloc.add(KeyBindingsSaveDataOnPage(
                      keyData.keyCode,
                      keyBindingData.clear(),
                    ));
                  },
                ),
                KeyNameField(
                  initialValue: keyBindingData.name,
                  onChanged: (newValue) {
                    bloc.add(KeyBindingsSaveDataOnPage(
                      keyData.keyCode,
                      keyBindingData.copyWith(name: newValue),
                    ));
                  },
                ),
                Row(
                  spacing: Spacing.lg,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KeyImageField(
                      initialValue: keyBindingData.imagePath,
                      onChanged: (newValue) {
                        bloc.add(KeyBindingsSaveDataOnPage(
                          keyData.keyCode,
                          keyBindingData.copyWith(imagePath: newValue),
                        ));
                      },
                    ),
                    KeyColorField(
                      initialValue: keyBindingData.backgroundColor,
                      onChanged: (newValue) {
                        bloc.add(KeyBindingsSaveDataOnPage(
                          keyData.keyCode,
                          keyBindingData.copyWith(backgroundColor: newValue),
                        ));
                      },
                    ),
                  ],
                )
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
