import 'package:flutter/material.dart';

class LoaderPlaceholder extends StatelessWidget {
  const LoaderPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
