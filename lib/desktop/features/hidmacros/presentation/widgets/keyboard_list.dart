import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/hidmacros/bloc/hidmacros_bloc.dart';
import 'package:streamkeys/desktop/features/hidmacros/presentation/widgets/select_keyboard.dart';
import 'package:streamkeys/desktop/features/hidmacros/presentation/widgets/select_keyboard_type.dart';

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
            spacing: Spacing.lg,
            children: [
              SelectKeyboard(),
              SelectKeyboardType(),
            ],
          );
        } else if (state is HidMacrosLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Text(state.runtimeType.toString());
        }
      },
    );
  }
}
