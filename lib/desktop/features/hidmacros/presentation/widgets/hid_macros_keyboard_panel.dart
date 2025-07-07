import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/hidmacros/bloc/hidmacros_bloc.dart';
import 'package:streamkeys/desktop/features/hidmacros/presentation/widgets/select_keyboard.dart';
import 'package:streamkeys/desktop/features/hidmacros/presentation/widgets/select_keyboard_type.dart';

class HidMacrosKeyboardPanel extends StatelessWidget {
  const HidMacrosKeyboardPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HidMacrosBloc, HidMacrosState>(
      builder: (context, state) {
        if (state is HidMacrosLoaded) {
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(Spacing.md),
              constraints: const BoxConstraints(maxWidth: 400),
              child: const Column(
                spacing: Spacing.lg,
                children: [
                  SelectKeyboard(),
                  SelectKeyboardType(),
                ],
              ),
            ),
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
