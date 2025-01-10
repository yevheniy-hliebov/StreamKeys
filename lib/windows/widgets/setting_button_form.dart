import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/windows/models/touch/action_touch_button_info.dart';
import 'package:streamkeys/windows/models/keyboard/keyboard_action_button_info.dart';
import 'package:streamkeys/windows/providers/browse_provider.dart';
import 'package:streamkeys/windows/providers/keyboard_deck_provider.dart';
import 'package:streamkeys/windows/providers/setting_key_button_provider.dart';
import 'package:streamkeys/windows/providers/touch_deck_provider.dart';
import 'package:streamkeys/windows/widgets/color_picker_dialog.dart';
import 'package:streamkeys/windows/widgets/for_loop.dart';
import 'package:streamkeys/windows/widgets/image_preview.dart';
import 'package:streamkeys/windows/widgets/picker.dart';

class SettingButtonForm extends StatelessWidget {
  final ActionButtonInfo buttonInfo;
  final String deckType;

  const SettingButtonForm({
    super.key,
    required this.deckType,
    required this.buttonInfo,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingButtonProvider(buttonInfo.copy(), deckType),
      child:
          Consumer<SettingButtonProvider>(builder: (context, provider, child) {
        return Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 552),
                child: Column(
                  children: [
                    _buildTopBar(context, provider),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        _buildImagePickerButton(context, provider),
                        const SizedBox(width: 10),
                        _buildColorPickerButton(context, provider),
                        const SizedBox(width: 10),
                        _buildNameField(provider),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildRowActions(context, provider),
                    const SizedBox(height: 34),
                    const Row(
                      children: [
                        Text(
                          'Actions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    divider(context),
                    if (provider.buttonInfo.actions.isEmpty) ...[
                      _buildMessage(
                        'Drag an action from right, place it on the button',
                      ),
                    ] else
                      ...For.generateWidgets(
                        buttonInfo.actions.length,
                        generator: (index) {
                          final action = buttonInfo.actions[index];
                          return [
                            _buildTitleAction(context, provider, index),
                            const SizedBox(height: 24),
                            ...action.formFields(context),
                            if (index != buttonInfo.actions.length - 1)
                              divider(context),
                          ];
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMessage(String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          style: const TextStyle(fontSize: 24),
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context, SettingButtonProvider provider) {
    return Row(
      children: [
        _buildTitle(context, 'Setting Button'),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: () {
            provider.clear();
            updateButtonInfo(context, provider.buttonInfo);
          },
          style: FilledButton.styleFrom(
            backgroundColor: SColors.of(context).surface,
          ),
          icon: const Icon(Icons.cancel_outlined),
        ),
      ],
    );
  }

  Widget _buildTitleAction(
      BuildContext context, SettingButtonProvider provider, int index) {
    final action = provider.buttonInfo.actions[index];
    return Row(
      children: [
        _buildTitle(context, action.actionType),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: () {
            provider.clearAction(index);
            updateButtonInfo(context, provider.buttonInfo);
          },
          style: FilledButton.styleFrom(
            backgroundColor: SColors.of(context).surface,
          ),
          icon: const Icon(Icons.cancel_outlined),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: () {
            provider.deleteAction(index);
            updateButtonInfo(context, provider.buttonInfo);
          },
          style: FilledButton.styleFrom(
            backgroundColor: SColors.of(context).surface,
          ),
          hoverColor: SColors.danger,
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, String text) {
    return Expanded(
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Divider divider(BuildContext context) {
    return Divider(
      color: SColors.of(context).outline,
      height: 24 * 2,
      thickness: 2,
    );
  }

  Widget _buildImagePickerButton(
    BuildContext context,
    SettingButtonProvider provider,
  ) {
    return Consumer<BrowseProvider>(
      builder: (context, browseProvider, child) {
        return Picker(
          toolTipMessage: 'Image',
          backgroundColor: provider.buttonInfo.backgroundColor,
          onTap: () => browseProvider.openBrowse(() async {
            await provider.pickImage();
          }),
          child: provider.buttonInfo.imagePath == ''
              ? null
              : ImagePreview(imagePath: provider.buttonInfo.imagePath),
        );
      },
    );
  }

  Widget _buildColorPickerButton(
    BuildContext context,
    SettingButtonProvider provider,
  ) {
    return Picker(
      toolTipMessage: 'Background Color',
      onTap: () => showColorPickerDialog(
        context,
        prevColor: provider.buttonInfo.backgroundColor,
        onSelectColor: (selectedColor) {
          provider.changeColor(selectedColor);
        },
      ),
      iconData: Icons.palette,
    );
  }

  Widget _buildNameField(SettingButtonProvider provider) {
    return Flexible(
      child: TextFormField(
        controller: provider.nameController,
        decoration: const InputDecoration(
          labelText: 'Name',
          hintText: 'Enter the name...',
        ),
      ),
    );
  }

  Widget _buildRowActions(
    BuildContext context,
    SettingButtonProvider provider,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        OutlinedButton(
          onPressed: () {
            provider.updateButtonInfo();
            updateButtonInfo(context, provider.buttonInfo);
          },
          style: ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(SColors.of(context).surface),
            padding: const WidgetStatePropertyAll(EdgeInsets.all(20)),
          ),
          child: const Text('Update'),
        )
      ],
    );
  }

  void updateButtonInfo(
    BuildContext context,
    ActionButtonInfo updatedButtonInfo,
  ) {
    if (deckType == 'touch') {
      final provider = Provider.of<TouchDeckProvider>(context, listen: false);
      provider.updateSelectedButtonInfo(updatedButtonInfo);
    } else {
      final provider =
          Provider.of<KeyboardDeckProvider>(context, listen: false);
      provider.updateSelectedButtonInfo(
        updatedButtonInfo as KeyboardActionButtonInfo,
      );
    }
  }
}
