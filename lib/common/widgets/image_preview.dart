import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final String imagePath;

  const ImagePreview({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    if (imagePath.isNotEmpty) {
      final imageFile = File(imagePath);
      return Image.file(
        imageFile,
        fit: BoxFit.cover,
      );
    }
    return const SizedBox.shrink();
  }
}