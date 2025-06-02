import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/common/widgets/image_preview.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key_data.dart';
import 'package:streamkeys/utils/file_picker_helper.dart';

class KeyIconPicker extends StatefulWidget {
  final KeyboardKeyData keyData;
  final void Function()? onSaved;

  const KeyIconPicker({
    super.key,
    required this.keyData,
    required this.onSaved,
  });

  @override
  State<KeyIconPicker> createState() => _KeyIconPickerState();
}

class _KeyIconPickerState extends State<KeyIconPicker> {
  late String _imagePath;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.keyData.imagePath;
  }

  @override
  void didUpdateWidget(covariant KeyIconPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.keyData.imagePath != widget.keyData.imagePath) {
      _imagePath = widget.keyData.imagePath;
    }
  }

  Future<void> _pickImage() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final imagePath = await FilePickerHelper.pickImage();
      if (imagePath != null) {
        setState(() {
          _imagePath = imagePath;
          widget.keyData.imagePath = imagePath;
        });
        widget.onSaved?.call();
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
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Key Icon',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        InkWell(
          onTap: _pickImage,
          child: SizedBox(
            width: 80,
            height: 80,
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(8),
              color: SColors.of(context).onSurface,
              dashPattern: const [5, 5],
              child: Center(
                child: _imagePath.isEmpty
                    ? const Text(
                        'Upload your image',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      )
                    : ImagePreview(imagePath: _imagePath),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
