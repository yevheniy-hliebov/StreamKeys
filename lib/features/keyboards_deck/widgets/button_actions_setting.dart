import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';

class ButtonActionsSetting extends StatelessWidget {
  const ButtonActionsSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SColors.of(context).surface,
      child: const Center(
        child: Text('Select a button'),
      ),
    );
  }
}
