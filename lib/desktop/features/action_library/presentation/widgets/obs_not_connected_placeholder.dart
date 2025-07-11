import 'package:flutter/material.dart';

class ObsNotConnectedPlaceholder extends StatelessWidget {
  final String message;
  const ObsNotConnectedPlaceholder({
    super.key,
    this.message = 'Not connected to OBS',
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
