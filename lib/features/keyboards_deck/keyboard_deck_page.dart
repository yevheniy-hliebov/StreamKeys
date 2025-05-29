import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/features/settings/widgets/setting_button.dart';

class KeyboardDeckPage extends StatelessWidget {
  const KeyboardDeckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keyboard deck'),
        actions: const [
          SettingButton(),
          SizedBox(width: 4),
        ],
        backgroundColor: SColors.of(context).surface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            height: 4,
            color: SColors.of(context).outlineVariant,
          ),
        ),
      ),
    );
  }
}
