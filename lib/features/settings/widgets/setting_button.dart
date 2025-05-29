import 'package:flutter/material.dart';
import 'package:streamkeys/features/settings/setting_page.dart';
import 'package:streamkeys/utils/navigate_to_page.dart';

class SettingButton extends StatelessWidget {
  const SettingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => navigateToPage(
        context,
        page: const SettingPage(),
      ),
      icon: const Icon(Icons.settings),
    );
  }
}
