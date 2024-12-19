import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/windows/models/base_action.dart';
import 'package:streamkeys/windows/models/keyboard/keyboard_key.dart';
import 'package:streamkeys/windows/providers/hidmacros_integration_provider.dart';
import 'package:streamkeys/windows/providers/keyboard_deck_provider.dart';
import 'package:streamkeys/windows/widgets/for_loop.dart';
import 'package:streamkeys/windows/widgets/keyboard/keyboard_button.dart';

class KeyboardButtonMap extends StatelessWidget {
  const KeyboardButtonMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 398,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SColors.of(context).surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: SColors.of(context).outline,
        ),
      ),
      child: _buidKeyboardMap(context),
    );
  }

  Widget _buidKeyboardMap(BuildContext context) {
    final provider = Provider.of<KeyboardDeckProvider>(context);
    final hidmacrosIntegrationProvider =
        Provider.of<HidmacrosIntegrationProvider>(context);
    final type = hidmacrosIntegrationProvider.selectedKeyboardType;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (type == 'full' || type == 'compact') ...[
          const CompactBlock(),
        ],
        if (type == 'full') ...[
          const SizedBox(width: 25),
        ],
        if (type == 'full' || type == 'numpad') ...[
          Numpad(numpad: provider.numpad),
        ],
      ],
    );
  }
}

class CompactBlock extends StatelessWidget {
  const CompactBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<KeyboardDeckProvider>(context);
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FunctuionBlock(),
            const SizedBox(height: 16),
            MainBlock(mainBlock: provider.mainBlock),
          ],
        ),
        const SizedBox(width: 25),
        NavigationBlock(navigationBlock: provider.navigationBlock),
      ],
    );
  }
}

class FunctuionBlock extends StatelessWidget {
  const FunctuionBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<KeyboardDeckProvider>(context);
    return Row(
      children: For.generateWidgets(
        provider.functionRow.length,
        generator: (i) {
          final indexsAfterSpace = [1, 5, 9];
          return [
            if (indexsAfterSpace.contains(i)) ...[
              const SizedBox(width: 54),
            ] else if (i != 0) ...[
              const SizedBox(width: 12),
            ],
            buildKeyboardButton(
              provider,
              area: 'functionRow',
              row: null,
              index: i,
              key: provider.functionRow[i],
            ),
          ];
        },
      ),
    );
  }
}

class MainBlock extends StatelessWidget {
  final List<List<KeyboardKey>> mainBlock;
  const MainBlock({
    super.key,
    required this.mainBlock,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<KeyboardDeckProvider>(context);
    return SizedBox(
      width: 920,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: For.generateWidgets(
          mainBlock.length,
          generator: (i) {
            final row = mainBlock[i];
            return [
              if (i != 0) ...[
                const SizedBox(height: 12),
              ],
              Row(
                children: For.generateWidgets(
                  row.length,
                  generator: (j) {
                    return [
                      if (j != 0) ...[
                        const SizedBox(width: 12),
                      ],
                      if (i == mainBlock.length - 1 && j == 3) ...[
                        Expanded(
                          child: buildKeyboardButton(
                            provider,
                            area: 'mainBlock',
                            row: i,
                            index: j,
                            key: row[j],
                          ),
                        ),
                      ] else if (i != mainBlock.length - 1 &&
                          (j == row.length - 1 || (i != 0 && j == 0))) ...[
                        Expanded(
                          child: buildKeyboardButton(
                            provider,
                            area: 'mainBlock',
                            row: i,
                            index: j,
                            key: row[j],
                          ),
                        ),
                      ] else ...[
                        buildKeyboardButton(
                          provider,
                          area: 'mainBlock',
                          row: i,
                          index: j,
                          key: row[j],
                        ),
                      ],
                    ];
                  },
                ),
              )
            ];
          },
        ),
      ),
    );
  }
}

class NavigationBlock extends StatelessWidget {
  final List<List<KeyboardKey>> navigationBlock;
  const NavigationBlock({
    super.key,
    required this.navigationBlock,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<KeyboardDeckProvider>(context);
    return SizedBox(
      height: 364,
      child: Column(
        children: For.generateWidgets(
          navigationBlock.length,
          generator: (i) {
            final row = navigationBlock[i];
            return [
              if (i == 1) ...[
                const SizedBox(height: 16),
              ] else if (i == 3) ...[
                const Spacer(),
              ] else if (i != 0) ...[
                const SizedBox(height: 12),
              ],
              Row(
                children: For.generateWidgets(
                  row.length,
                  generator: (j) => [
                    if (j != 0) ...[
                      const SizedBox(width: 12),
                    ],
                    buildKeyboardButton(
                      provider,
                      area: 'navigationBlock',
                      row: i,
                      index: j,
                      key: row[j],
                    ),
                  ],
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}

class Numpad extends StatelessWidget {
  final List<List<KeyboardKey>> numpad;
  const Numpad({
    super.key,
    required this.numpad,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<KeyboardDeckProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 174,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: For.generateWidgets(
              numpad.length,
              generator: (i) {
                final row = numpad[i];
                if (i == numpad.length - 1) {
                  return [const SizedBox()];
                }
                return [
                  if (i == 0) ...[
                    const SizedBox(height: 66),
                  ] else ...[
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: For.generateWidgets(
                      row.length,
                      generator: (j) => [
                        if (j != 0) ...[
                          const SizedBox(width: 12),
                        ],
                        if (j == 0) ...[
                          Expanded(
                            child: buildKeyboardButton(
                              provider,
                              area: 'numpad',
                              row: i,
                              index: j,
                              key: row[j],
                            ),
                          ),
                        ] else ...[
                          buildKeyboardButton(
                            provider,
                            area: 'numpad',
                            row: i,
                            index: j,
                            key: row[j],
                          ),
                        ]
                      ],
                    ),
                  ),
                ];
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Builder(
          builder: (context) {
            if (numpad.isEmpty) {
              return const SizedBox();
            }
            final column = numpad.last;
            return Container(
              height: 298,
              margin: const EdgeInsets.only(top: 66),
              child: Column(
                children: For.generateWidgets(
                  column.length,
                  generator: (i) {
                    return [
                      if (i != 0) ...[
                        const SizedBox(height: 12),
                      ],
                      if (i != 0) ...[
                        Expanded(
                          child: buildKeyboardButton(
                            provider,
                            area: 'numpad',
                            row: numpad.length - 1,
                            index: i,
                            key: column[i],
                          ),
                        ),
                      ] else ...[
                        buildKeyboardButton(
                          provider,
                          area: 'numpad',
                          row: numpad.length - 1,
                          index: i,
                          key: column[i],
                        ),
                      ]
                    ];
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

Widget buildKeyboardButton(
  KeyboardDeckProvider provider, {
  required String area,
  int? row,
  required int index,
  required KeyboardKey key,
}) {
  return DragTarget<BaseAction>(
    onAcceptWithDetails: (details) {
      final action = details.data;
      provider.setAction(action, keyCode: key.code);
    },
    builder: (context, _, __) {
      return KeyboardButton(
        info: provider.getActionInfo(key.code),
        keyboardKey: key,
        isSelected: provider.isSelected(area: area, row: row, index: index),
        onTap: () {
          provider.selectKey(
            area: area,
            row: row,
            index: index,
            keyCode: key.code,
          );
        },
        size: 50,
      );
    },
  );
}
