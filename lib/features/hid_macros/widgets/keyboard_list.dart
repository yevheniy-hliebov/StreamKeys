import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/common/widgets/for.dart';
import 'package:streamkeys/features/hid_macros/bloc/hid_macros_bloc.dart';
import 'package:streamkeys/features/keyboards_deck/models/keyboard_type.dart';

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
        return Column(
          spacing: 24,
          children: [
            Column(
              spacing: 16,
              children: [
                const Text(
                  'Select a keyboard',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: SColors.of(context).surface,
                    border: Border.all(
                      width: 1,
                      color: SColors.of(context).onSurface,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: For.generateWidgets(
                      state.keyboards.length,
                      generator: (index) {
                        bool isSelected = state.keyboards[index].systemId ==
                            state.selectedKeyboardSystemId;
                        return [
                          Material(
                            color: Colors.transparent,
                            child: Tooltip(
                              message: state.keyboards[index].systemId,
                              waitDuration: const Duration(seconds: 2),
                              child: ListTile(
                                tileColor: isSelected
                                    ? SColors.primary
                                    : SColors.of(context).surface,
                                onTap: () {
                                  context.read<HidMacrosBloc>().add(
                                        HidMacrosSelectKeyboardEvent(
                                            state.keyboards[index].systemId),
                                      );
                                },
                                title: Text(state.keyboards[index].name),
                              ),
                            ),
                          )
                        ];
                      },
                    ),
                  ),
                ),
              ],
            ),
            Column(
              spacing: 16,
              children: [
                const Text(
                  'Select a keyboard type',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: SColors.of(context).surface,
                    border: Border.all(
                      width: 1,
                      color: SColors.of(context).onSurface,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: For.generateWidgets(
                      KeyboardType.values.length,
                      generator: (index) {
                        bool isSelected = KeyboardType.values[index] ==
                            state.selectedKeyboardType;
                        return [
                          Material(
                            color: Colors.transparent,
                            child: ListTile(
                              tileColor: isSelected
                                  ? SColors.primary
                                  : SColors.of(context).surface,
                              onTap: () {
                                context.read<HidMacrosBloc>().add(
                                      HidMacrosSelectKeyboardTypeEvent(
                                        KeyboardType.values[index],
                                      ),
                                    );
                              },
                              title: Text(KeyboardType.values[index].name),
                            ),
                          )
                        ];
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      } else if (state is HidMacrosLoading) {
        return const Text('Loading...');
      } else {
        return const SizedBox();
      }
    });
  }
}
