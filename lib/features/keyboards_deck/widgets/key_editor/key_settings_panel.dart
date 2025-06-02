import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/common/widgets/color_picker/custom_color_picker.dart';
import 'package:streamkeys/features/keyboards_deck/bloc/keyboard_map_bloc.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key_data.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/key_editor/key_color_picker.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/key_editor/key_icon_picker.dart';

class KeySettingsPanel extends StatefulWidget {
  final KeyboardKey selectedKey;
  final KeyboardKeyData initialData;

  const KeySettingsPanel({
    super.key,
    required this.selectedKey,
    required this.initialData,
  });

  @override
  State<KeySettingsPanel> createState() => _KeySettingsPanelState();
}

class _KeySettingsPanelState extends State<KeySettingsPanel> {
  late KeyboardKeyData keyData;
  late TextEditingController nameController;
  late ColorPickerController colorController;

  @override
  void initState() {
    super.initState();
    keyData = widget.initialData;
    nameController = TextEditingController(text: keyData.name);
    colorController =
        ColorPickerController(keyData.backgroundColor ?? Colors.transparent);

    nameController.addListener(() {
      keyData.name = nameController.text;
      _saveChanges();
    });
    colorController.addListener(() {
      keyData.backgroundColor = colorController.pickerColor;
      _saveChanges();
    });
  }

  void _saveChanges() {
    context.read<KeyboardMapBloc>().add(KeyboardMapUpdateKeyData(keyData));
  }

  @override
  void dispose() {
    nameController.dispose();
    colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(
            'Bind key: ${widget.selectedKey.name}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Divider(
            height: 2,
            thickness: 2,
            color: SColors.of(context).onSurface,
          ),
          const Text(
            'Name',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 35,
            child: TextFormField(
              controller: nameController,
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(hintText: 'Enter a name'),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KeyIconPicker(keyData: keyData, onSaved: _saveChanges),
              const SizedBox(width: 25),
              KeyColorPicker(controller: colorController),
            ],
          ),
        ],
      ),
    );
  }
}
