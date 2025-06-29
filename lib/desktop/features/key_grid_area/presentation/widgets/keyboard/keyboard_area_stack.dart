import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/custom_dropdown_button.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/key_grid_area.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_area_wrapper.dart';
import 'package:streamkeys/service_locator.dart';

class KeyboardAreaStack extends StatefulWidget {
  const KeyboardAreaStack({super.key});

  @override
  State<KeyboardAreaStack> createState() => _KeyboardAreaStackState();
}

class _KeyboardAreaStackState extends State<KeyboardAreaStack> {
  late KeyboardType selectedKeyboardType;

  @override
  void initState() {
    super.initState();
    selectedKeyboardType = KeyboardType.full;
    _loadTemplate();
  }

  void _loadTemplate() {
    final prefs = sl<SharedPreferences>();
    final keyboardTypeName = prefs.getString('selected_keyboard_type');

    KeyboardType keyboardType = KeyboardType.full;
    if (keyboardTypeName == KeyboardType.numpad.name) {
      keyboardType = KeyboardType.numpad;
    } else if (keyboardTypeName == KeyboardType.compact.name) {
      keyboardType = KeyboardType.compact;
    }

    setState(() {
      selectedKeyboardType = keyboardType;
    });
  }

  Future<void> _saveTemplate(int index) async {
    final prefs = sl<SharedPreferences>();
    await prefs.setString(
        'selected_keyboard_type', KeyboardType.values[index].name);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        KeyGridArea(
          child: KeyboardAreaWrapper(keyboardType: selectedKeyboardType),
        ),
        Positioned(
          top: Spacing.md,
          left: Spacing.md,
          child: CustomDropdownButton(
            index: KeyboardType.values.indexOf(selectedKeyboardType),
            itemCount: KeyboardType.values.length,
            itemBuilder: (index) {
              return Text(KeyboardType.values[index].name);
            },
            onChanged: (int? newIndex) {
              if (newIndex == null) return;
              setState(() {
                selectedKeyboardType = KeyboardType.values[newIndex];
              });
              _saveTemplate(newIndex);
            },
          ),
        ),
      ],
    );
  }
}
