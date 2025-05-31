import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/features/hid_macros/bloc/hid_macros_bloc.dart';

class HidMacrosNotExist extends StatelessWidget {
  const HidMacrosNotExist({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        const Text(
          'hidmacros.xml does not exist\nPlease click the Save configuration button in the open Hid Macros application',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        FilledButton(
          onPressed: () {
            context
                .read<HidMacrosBloc>()
                .add(const HidMacrosLoadKeyboardsEvent());
          },
          child: const Text('Try again'),
        ),
      ],
    );
  }
}
