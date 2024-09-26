import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/windows/models/action.dart';
import 'package:streamkeys/windows/providers/setting_action_provider.dart';
import 'package:streamkeys/windows/widgets/action_form_field.dart';

class SettingActionPage extends StatelessWidget {
  final ButtonAction action;

  const SettingActionPage({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingActionProvider(action: action),
      child: Scaffold(
        appBar: SettingActionAppBar(action: action),
        body: const Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              ActionFormFields(),
              SizedBox(height: 10),
              ButtonRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingActionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final ButtonAction action;

  const SettingActionAppBar({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop('Not updated'),
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text(
        'Action ${action.id}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingActionProvider>(
      builder: (context, provider, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () => provider.clearAction,
              child: const Icon(Icons.delete_forever),
            ),
            OutlinedButton(
              onPressed: () async {
                await provider.updateAction();
                if (context.mounted) {
                  Navigator.of(context).pop('Updated');
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
