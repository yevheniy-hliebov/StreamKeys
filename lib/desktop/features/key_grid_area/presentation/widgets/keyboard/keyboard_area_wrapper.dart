import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/desktop/features/key_bindings/bloc/key_bindings_bloc.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/repositories/keyboard_map_repository.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_area.dart';

class KeyboardAreaWrapper extends StatefulWidget {
  final KeyboardType keyboardType;

  const KeyboardAreaWrapper({
    super.key,
    this.keyboardType = KeyboardType.full,
  });

  @override
  State<KeyboardAreaWrapper> createState() => _KeyboardAreaWrapperState();
}

class _KeyboardAreaWrapperState extends State<KeyboardAreaWrapper> {
  KeyboardMapRepository repository = KeyboardMapRepository();
  Map<String, KeyboardKeyBlock> keyMap = <String, KeyboardKeyBlock>{};

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final Map<String, KeyboardKeyBlock> loadedMap =
        await repository.loadKeyboardMap();

    setState(() {
      keyMap = loadedMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KeyboardKeyBindingsBloc, KeyBindingsState>(
      builder: (context, state) {
        final currentKeyCode =
            state is KeyBindingsLoaded ? state.currentKeyCode : null;
        return KeyboardArea(
          keyboardType: widget.keyboardType,
          keyMap: keyMap,
          buttonSize: 50,
          pageMap: state is KeyBindingsLoaded ? state.map : {},
          currentKeyCode: currentKeyCode,
          onPressedButton: (keyCode) {
            if (keyCode != currentKeyCode) {
              context
                  .read<KeyboardKeyBindingsBloc>()
                  .add(KeyBindingsSelectKey(keyCode));
            }
          },
        );
      },
    );
  }
}
