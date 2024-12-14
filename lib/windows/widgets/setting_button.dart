import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/windows/models/action_touch_button_info.dart';
import 'package:streamkeys/windows/models/keyboard/keyboard_action_button_info.dart';
import 'package:streamkeys/windows/providers/browse_provider.dart';
import 'package:streamkeys/windows/providers/keyboard_deck_provider.dart';
import 'package:streamkeys/windows/providers/setting_key_button_provider.dart';
import 'package:streamkeys/windows/providers/touch_deck_provider.dart';
import 'package:streamkeys/windows/widgets/color_picker_dialog.dart';
import 'package:streamkeys/windows/widgets/image_preview.dart';
import 'package:streamkeys/windows/widgets/picker.dart';

class SettingButton extends StatelessWidget {
  final ActionButtonInfo buttonInfo;
  final String deckType;

  const SettingButton({
    super.key,
    required this.deckType,
    required this.buttonInfo,
  });

  @override
  Widget build(BuildContext context) {
    if (buttonInfo.action == null) {
      return const SizedBox();
    }

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
                    divider(context),
                    Row(
                      children: [
                        _buildImagePickerButton(context, provider),
                        const SizedBox(width: 10),
                        _buildColorPickerButton(context, provider),
                        const SizedBox(width: 10),
                        _buildNameField(provider),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ...buttonInfo.action!.formFields(context),
                    const SizedBox(height: 24),
                    _buildRowActions(context, provider),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTopBar(BuildContext context, SettingButtonProvider provider) {
    if (provider.buttonInfo.action == null) {
      return const SizedBox();
    }
    return Row(
      children: [
        _buildTitle(context, provider.buttonInfo.action!.actionType),
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
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: () {
            provider.delete();
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
      onTap: () => showColorPickerDialog(
        context,
        prevColor: provider.buttonInfo.backgroundColor,
        onSelectColor: (selectedColor) {
          provider.changeColor(selectedColor);
        },
      ),
      child: const Icon(Icons.palette),
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
      mainAxisAlignment: MainAxisAlignment.end,
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
