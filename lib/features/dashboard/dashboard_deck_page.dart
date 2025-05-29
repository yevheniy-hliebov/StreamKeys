import 'package:flutter/material.dart';
import 'package:streamkeys/features/dashboard/widgets/deck_button.dart';
import 'package:streamkeys/features/keyboards_deck/keyboard_deck_page.dart';
import 'package:streamkeys/features/settings/widgets/setting_button.dart';
import 'package:streamkeys/utils/navigate_to_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          SettingButton(),
          SizedBox(width: 4),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const DeckButton(
              text: 'Mobile Deck',
            ),
            const SizedBox(width: 16),
            DeckButton(
              text: 'Keyboard Deck',
              onPressed: () => navigateToPage(
                page: const KeyboardDeckPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
