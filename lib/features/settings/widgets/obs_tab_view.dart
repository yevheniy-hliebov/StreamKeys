import 'package:flutter/material.dart';
import 'package:streamkeys/features/obs/widgets/obs_connetion_form.dart';

class ObsTabView extends StatelessWidget {
  const ObsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: const ObsConnectionForm(),
      ),
    );
  }
}
