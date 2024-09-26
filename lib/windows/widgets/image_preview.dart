import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/action.dart';

class ImagePreview extends StatelessWidget {
  final ButtonAction action;

  const ImagePreview({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    if (action.imagePath.isNotEmpty) {
      final imageFile = action.getImageFile();
      return Image.file(
        imageFile,
        fit: BoxFit.cover,
      );
    }
    return const SizedBox.shrink();
  }
}
