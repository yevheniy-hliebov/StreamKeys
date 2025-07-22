import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/mobile/features/buttons/data/models/button_data.dart';

class DeckButton extends StatelessWidget {
  final String keyCode;
  final ButtonData? buttonData;
  final void Function(String keyCode)? onTap;
  final Size size;
  final Future<Uint8List?> Function(String keyCode) getImage;

  const DeckButton({
    super.key,
    required this.keyCode,
    required this.getImage,
    this.buttonData,
    this.onTap,
    this.size = const Size(50, 50),
  });

  @override
  Widget build(BuildContext context) {
    String label = keyCode;
    if (buttonData != null && buttonData!.name.isNotEmpty) {
      label = buttonData!.name;
    }

    return Tooltip(
      message: label,
      child: InkWell(
        onTap: () {
          onTap?.call(keyCode);
        },
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: buttonData?.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.of(context).outline, width: 1),
          ),
          child: _buildImage(),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (buttonData == null || buttonData!.keyCode.isEmpty) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<Uint8List?>(
      future: getImage(buttonData!.keyCode),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final bytes = snapshot.data!;
        return Image.memory(bytes, fit: BoxFit.cover);
      },
    );
  }
}
