import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/windows/models/action_touch_button_info.dart';
import 'package:streamkeys/windows/providers/browse_provider.dart';
import 'package:streamkeys/windows/widgets/color_picker_dialog.dart';
import 'package:streamkeys/windows/widgets/image_preview.dart';
import 'package:streamkeys/windows/widgets/picker.dart';

class SettingTouchButton extends StatefulWidget {
  final ActionTouchButtonInfo buttonInfo;
  final void Function(ActionTouchButtonInfo updatedButtonInfo)? onUpdate;

  const SettingTouchButton({
    super.key,
    required this.buttonInfo,
    this.onUpdate,
  });

  @override
  State<SettingTouchButton> createState() => _SettingTouchButtonState();
}

class _SettingTouchButtonState extends State<SettingTouchButton> {
  late ActionTouchButtonInfo buttonInfo;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    buttonInfo = widget.buttonInfo;
    nameController = TextEditingController(text: widget.buttonInfo.name);
    nameController.addListener(
      () => setState(() {
        buttonInfo.name = nameController.text;
      }),
    );
  }

  @override
  void didUpdateWidget(covariant SettingTouchButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.buttonInfo != oldWidget.buttonInfo) {
      setState(() {
        buttonInfo = widget.buttonInfo;
        nameController.text = buttonInfo.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 552),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        buttonInfo.action!.actionType,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: () {
                        setState(() {
                          buttonInfo.clear();
                          nameController.clear();
                        });
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: SColors.of(context).surface,
                      ),
                      icon: const Icon(Icons.cancel_outlined),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: () {
                        buttonInfo.delete();
                        nameController.clear();
                        widget.onUpdate?.call(buttonInfo.copy());
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: SColors.of(context).surface,
                      ),
                      hoverColor: SColors.danger,
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
                Divider(
                  color: SColors.of(context).outline,
                  height: 24 * 2,
                  thickness: 2,
                ),
                Row(
                  children: [
                    Consumer<BrowseProvider>(
                        builder: (context, browseProvider, child) {
                      return Picker(
                        toolTipMessage: 'Image',
                        backgroundColor: buttonInfo.backgroundColor,
                        onTap: () =>
                            browseProvider.openBrowse(buttonInfo.pickImage),
                        child: buttonInfo.imagePath == ''
                            ? null
                            : ImagePreview(imagePath: buttonInfo.imagePath),
                      );
                    }),
                    const SizedBox(width: 10),
                    Picker(
                      onTap: () => showColorPickerDialog(
                        context,
                        prevColor: buttonInfo.backgroundColor,
                        onSelectColor: (selectedColor) {
                          setState(() {
                            buttonInfo.backgroundColor = selectedColor;
                          });
                        },
                      ),
                      child: const Icon(Icons.palette),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter the name...',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ...buttonInfo.action!.formFields(context),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => widget.onUpdate?.call(buttonInfo.copy()),
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(SColors.of(context).surface),
                        padding:
                            const WidgetStatePropertyAll(EdgeInsets.all(20)),
                      ),
                      child: const Text('Update'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
