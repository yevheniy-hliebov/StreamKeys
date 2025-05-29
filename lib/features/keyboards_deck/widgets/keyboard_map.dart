import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';

class KeyboardMap extends StatelessWidget {
  const KeyboardMap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SColors.of(context).background,
      child: const Center(
        child: Text('Select a keyboard'),
      ),
    );
  }
}
