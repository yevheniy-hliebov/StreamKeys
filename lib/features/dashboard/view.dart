import 'package:flutter/material.dart';
import 'package:streamkeys/features/dashboard/presentation/widgets/deck_button.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DeckButton(text: 'Mobile Deck'),
            SizedBox(width: 16),
            DeckButton(text: 'Keyboard Deck'),
          ],
        ),
      ),
    );
  }
}
