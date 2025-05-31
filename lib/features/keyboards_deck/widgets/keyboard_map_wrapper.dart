import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/features/hid_macros/bloc/hid_macros_bloc.dart';
import 'package:streamkeys/features/hid_macros/widgets/hid_macros_not_exist.dart';
import 'package:streamkeys/features/hid_macros/widgets/select_keyboard.dart';
import 'package:streamkeys/features/hid_macros/widgets/select_keyboard_type.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/keyboard_map.dart';

class KeyboardMapWrapper extends StatelessWidget {
  const KeyboardMapWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HidMacrosBloc, HidMacrosState>(
      builder: (context, state) {
        if (state is HidMacrosLoaded) {
          if (state.selectedKeyboard == null) {
            return const _CenteredConstrained(child: SelectKeyboard());
          } else if (state.selectedKeyboardType == null) {
            return const _CenteredConstrained(child: SelectKeyboardType());
          } else {
            return KeyboardMap(
              keyboardType: state.selectedKeyboardType!,
            );
          }
        } else if (state is HidMacrosLoading) {
          return const Center(child: Text('Loading...'));
        } else if (state is HidMacrosXmlNotExist) {
          return const HidMacrosNotExist();
        } else {
          return Center(child: Text(state.runtimeType.toString()));
        }
      },
    );
  }
}

class _CenteredConstrained extends StatelessWidget {
  final Widget child;

  const _CenteredConstrained({required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 400),
        child: child,
      ),
    );
  }
}
