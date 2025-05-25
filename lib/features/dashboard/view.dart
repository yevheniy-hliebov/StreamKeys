import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FilledButton(
            onPressed: () {
              // перехід на KeyboardDeckPage
            },
            child: const Text('Keyboard Deck'),
          ),
          FilledButton(
            onPressed: () {
              // перехід на MobileDeckPage
            },
            child: const Text('Mobile Deck'),
          ),
        ],
      ),
    );
  }
}
