import 'package:flutter/material.dart';

class KeyEditorPlaceholder extends StatelessWidget {
  const KeyEditorPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Select a key button', style: TextTheme.of(context).titleSmall),
    );
  }
}
