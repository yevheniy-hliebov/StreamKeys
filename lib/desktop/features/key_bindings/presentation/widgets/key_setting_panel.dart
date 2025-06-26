import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/models/key_binding_data.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_color_field.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_editor_header.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_image_field.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_name_field.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/base_key_data.dart';

class KeySettingPanel extends StatelessWidget {
  final BaseKeyData keyData;
  final KeyBindingData keyBindingData;
  final void Function()? onClearPressed;
  final void Function(String newValue)? onNameChanged;
  final void Function(String newValue)? onImagePathChanged;
  final void Function(Color newValue)? onColorChanged;

  const KeySettingPanel({
    super.key,
    required this.keyData,
    required this.keyBindingData,
    this.onClearPressed,
    this.onNameChanged,
    this.onImagePathChanged,
    this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Spacing.xs,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KeyEditorHeader(
          keyData: keyData,
          onClearPressed: onClearPressed,
        ),
        KeyNameField(
          initialValue: keyBindingData.name,
          onChanged: onNameChanged,
        ),
        Row(
          spacing: Spacing.lg,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KeyImageField(
              initialValue: keyBindingData.imagePath,
              onChanged: onImagePathChanged,
            ),
            KeyColorField(
              initialValue: keyBindingData.backgroundColor,
              onChanged: onColorChanged,
            ),
          ],
        )
      ],
    );
  }
}
