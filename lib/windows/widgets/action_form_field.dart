import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/windows/providers/setting_action_provider.dart';
import 'package:streamkeys/windows/screens/color_picker_screen.dart';
import 'package:streamkeys/windows/widgets/file_picker.dart';
import 'package:streamkeys/windows/widgets/image_preview.dart';

class ActionFormFields extends StatelessWidget {
  const ActionFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingActionProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Picker(
                  toolTipMessage: 'Image',
                  onTap: provider.pickImage,
                  child: provider.action.imagePath != ''
                      ? ImagePreview(action: provider.action)
                      : null,
                ),
                const SizedBox(width: 10),
                Picker(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ColorPickerScreen(
                            actionColor: Colors.transparent),
                      ),
                    );
                  },
                  child: const Icon(Icons.palette),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter the name...',
                    ),
                    controller: provider.nameController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'File Path',
                      hintText: 'Enter the file path...',
                    ),
                    controller: provider.filePathController,
                  ),
                ),
                const SizedBox(width: 5),
                Picker(
                  toolTipMessage: 'Browse',
                  onTap: provider.pickFile,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
