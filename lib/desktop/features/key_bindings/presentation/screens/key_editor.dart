import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_color_field.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_image_field.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_name_field.dart';

class KeyEditor extends StatelessWidget {
  const KeyEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.of(context).surface,
      padding: const EdgeInsets.all(Spacing.sm),
      child: const Column(
        spacing: Spacing.md,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KeyNameField(),
          Row(
            spacing: Spacing.lg,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KeyImageField(),
              KeyColorField(),
            ],
          )
        ],
      ),
    );
  }
}
