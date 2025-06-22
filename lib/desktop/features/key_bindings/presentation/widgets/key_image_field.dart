import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/image_preview.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/core/constants/typography.dart';
import 'package:streamkeys/desktop/features/key_bindings/presentation/widgets/key_field_label.dart';
import 'package:streamkeys/desktop/utils/helper_function.dart';

class KeyImageField extends StatefulWidget {
  final double buttonSize;
  final String initialValue;
  final void Function(String newValue)? onChanged;

  const KeyImageField({
    super.key,
    this.buttonSize = 80,
    this.initialValue = '',
    this.onChanged,
  });

  @override
  State<KeyImageField> createState() => _KeyImageFieldState();
}

class _KeyImageFieldState extends State<KeyImageField> {
  late String _imagePath;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.initialValue;
  }

  Future<void> _pickImage() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final imagePath = await HelperFunctions.pickFile(type: FileType.image);
      if (imagePath != null) {
        setState(() {
          _imagePath = imagePath;
        });
        widget.onChanged?.call(imagePath);
      }
    } finally {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Spacing.xs,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const KeyFieldLabel('Key Image'),
        InkWell(
          onTap: _pickImage,
          child: SizedBox(
            width: widget.buttonSize,
            height: widget.buttonSize,
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(8),
              color: AppColors.of(context).onSurface,
              dashPattern: const [5, 5],
              child: Center(
                child: _imagePath.isEmpty
                    ? _buildButtonText()
                    : ImagePreview(imagePath: _imagePath),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonText() {
    return const Text(
      'Upload\nyour\nimage',
      textAlign: TextAlign.center,
      style: AppTypography.caption,
    );
  }
}
