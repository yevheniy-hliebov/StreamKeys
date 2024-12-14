import 'package:flutter/material.dart';
import 'package:streamkeys/windows/utils/startup_helpers.dart';

class StartupSettingTile extends StatefulWidget {
  const StartupSettingTile({super.key});

  @override
  State<StartupSettingTile> createState() => _StartupSettingTileState();
}

class _StartupSettingTileState extends State<StartupSettingTile> {
  bool isStartup = false;

  @override
  void initState() {
    super.initState();
    checkIsAppInStartup();
  }

  Future<void> checkIsAppInStartup() async {
    final isAppInStartup = await StartupHelper.doesShortcutExistInStartup();
    setState(() => isStartup = isAppInStartup);
  }

  Future<void> onChanged(bool newValue) async {
    setState(() {
      isStartup = newValue;
    });
    if (newValue == true) {
      await StartupHelper.createStartupShortcut();
    } else {
      await StartupHelper.removeStartupShortcut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        'Run at startup',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Transform.translate(
        offset: const Offset(14, 0),
        child: Transform.scale(
          scale: 0.8,
          child: Switch(
            value: isStartup,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
