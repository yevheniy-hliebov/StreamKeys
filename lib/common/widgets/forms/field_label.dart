import 'package:flutter/material.dart';

class FieldLabel extends StatelessWidget {
  final String text;

  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextTheme.of(context).bodyLarge);
  }
}
