import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/typography.dart';
import 'package:streamkeys/mobile/features/api_connection/presentation/widgets/api_connection_gate.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.refresh),
        ),
        centerTitle: true,
        title: const Text(
          'StreamKeys',
          style: AppTypography.subtitle,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const SafeArea(
        child: ApiConnectionGate(
          child: Text('Buttons'),
        ),
      ),
    );
  }
}
