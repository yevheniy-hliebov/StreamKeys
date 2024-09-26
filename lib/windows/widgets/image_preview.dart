import 'package:flutter/material.dart';
import 'package:streamkeys/windows/providers/setting_action_provider.dart';

class ImagePreview extends StatelessWidget {
  final SettingActionProvider provider;

  const ImagePreview({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.imagePath.isNotEmpty) {
      final imageFile = provider.action.getImageFile();
      return Image.file(
        imageFile,
        fit: BoxFit.cover,
      );
    }
    return const SizedBox.shrink();
  }
}
