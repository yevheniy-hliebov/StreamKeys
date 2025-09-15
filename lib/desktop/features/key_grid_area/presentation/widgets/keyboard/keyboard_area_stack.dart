import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/widgets/buttons/custom_dropdown_button.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/hidmacros/bloc/hidmacros_bloc.dart';
import 'package:streamkeys/desktop/features/hidmacros/presentation/widgets/select_keyboard.dart';
import 'package:streamkeys/desktop/features/hidmacros/presentation/widgets/select_keyboard_type.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/key_grid_area.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keyboard/keyboard_area_wrapper.dart';

class KeyboardAreaStack extends StatelessWidget {
  const KeyboardAreaStack({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HidMacrosBloc, HidMacrosState>(
      builder: (context, state) {
        if (state.selectedKeyboard == null) {
          return _CenteredConstrained(
            child: SelectKeyboard(
              keyboards: state.keyboards,
              selectedKeyboard: state.selectedKeyboard,
              onTap: (keyboard) {
                context.read<HidMacrosBloc>().add(
                  HidMacrosSelectKeyboardEvent(keyboard),
                );
              },
            ),
          );
        } else if (state.selectedKeyboardType == null) {
          return _CenteredConstrained(
            child: SelectKeyboardType(
              selectedType: state.selectedKeyboardType,
              onTap: (type) {
                context.read<HidMacrosBloc>().add(
                  HidMacrosSelectKeyboardTypeAndSaveEvent(type),
                );
              },
            ),
          );
        } else {
          return Stack(
            children: [
              KeyGridArea(
                child: KeyboardAreaWrapper(
                  keyboardType: state.selectedKeyboardType!,
                ),
              ),
              Positioned(
                top: Spacing.md,
                left: Spacing.md,
                child: CustomDropdownButton(
                  index: KeyboardType.values.indexOf(
                    state.selectedKeyboardType!,
                  ),
                  itemCount: KeyboardType.values.length,
                  itemBuilder: (index) {
                    return Text(KeyboardType.values[index].name);
                  },
                  onChanged: (int? newIndex) {
                    if (newIndex == null) return;
                    final keyboardType = KeyboardType.values[newIndex];
                    context.read<HidMacrosBloc>().add(
                      HidMacrosSelectKeyboardTypeAndSaveEvent(keyboardType),
                    );
                  },
                ),
              ),
            ],
          );
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
