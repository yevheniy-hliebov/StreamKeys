import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/features/hid_macros/bloc/hid_macros_bloc.dart';
import 'package:streamkeys/features/hid_macros/widgets/hid_macros_not_exist.dart';
import 'package:streamkeys/features/hid_macros/widgets/select_keyboard.dart';
import 'package:streamkeys/features/hid_macros/widgets/select_keyboard_type.dart';

class KeyboardList extends StatefulWidget {
  const KeyboardList({super.key});

  @override
  State<KeyboardList> createState() => _KeyboardListState();
}

class _KeyboardListState extends State<KeyboardList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HidMacrosBloc, HidMacrosState>(
      builder: (context, state) {
        if (state is HidMacrosLoaded) {
          return const Column(
            spacing: 24,
            children: [
              SelectKeyboard(),
              SelectKeyboardType(),
            ],
          );
        } else if (state is HidMacrosLoading) {
          return const Text('Loading...');
        } else if (state is HidMacrosXmlNotExist) {
          return const HidMacrosNotExist();
        } else {
          return Text(state.runtimeType.toString());
        }
      },
    );
  }
}
