import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/android/providers/actions_provider.dart';
import 'package:streamkeys/android/widgets/action_button.dart';
import 'package:streamkeys/android/widgets/refresh_button.dart';
import 'package:streamkeys/common/widgets/settings_button.dart';

class AndroidHomePage extends StatelessWidget {
  const AndroidHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ActionsProvider(context),
      child: Consumer<ActionsProvider>(
        builder: (context, value, child) {
          final orientation = MediaQuery.of(context).orientation;
          return Scaffold(
            appBar: _HomeAppBar(orientation: orientation),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: _ActionButtonsGrid(
                      buttonSize: calculateButtonSize(
                        constraints,
                        orientation,
                      ),
                      orientation: orientation,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  static double calculateButtonSize(
    BoxConstraints constraints,
    Orientation orientation,
  ) {
    const padding = 10;
    const gap = 10;

    final countInRow = orientation == Orientation.portrait ? 4 : 7;
    final countInColumn = orientation == Orientation.portrait ? 7 : 4;

    final availableWidth = constraints.maxWidth - (padding * 2);
    final availableHeight = constraints.maxHeight - (padding * 2);

    final widthButton = (availableWidth - gap * countInRow) / countInRow;
    final heightButton =
        (availableHeight - gap * countInColumn) / countInColumn;

    return min(widthButton, heightButton);
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Orientation orientation;

  const _HomeAppBar({required this.orientation});

  @override
  Widget build(BuildContext context) {
    final actionProvider = Provider.of<ActionsProvider>(context);

    if (orientation == Orientation.portrait) {
      return AppBar(
        leading: RefreshButton(
          isLoading: actionProvider.isLoading,
          onPressed: actionProvider.getActions,
        ),
        title: const Text('StreamKeys'),
        centerTitle: true,
        actions: [
          SettingsButton(
            actionsProvider: actionProvider,
          ),
        ],
      );
    }
    return const SizedBox();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ActionButtonsGrid extends StatelessWidget {
  final double buttonSize;
  final Orientation orientation;

  const _ActionButtonsGrid({
    required this.buttonSize,
    required this.orientation,
  });

  @override
  Widget build(BuildContext context) {
    final actionProvider = Provider.of<ActionsProvider>(context);
    final countInRow = orientation == Orientation.portrait ? 4 : 7;
    final countInColumn = orientation == Orientation.portrait ? 7 : 4;

    return Column(
      mainAxisAlignment: orientation == Orientation.portrait
          ? MainAxisAlignment.start
          : MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 0; i < countInColumn; i++) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _buildButtonRow(actionProvider, i, countInRow),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  List<Widget> _buildButtonRow(
    ActionsProvider actionProvider,
    int rowIndex,
    int countInRow,
  ) {
    return [
      for (int j = 0; j < countInRow; j++) ...[
        if (rowIndex * countInRow + j < actionProvider.actions.length)
          ActionButton(
            action: actionProvider.actions[rowIndex * countInRow + j],
            buttonSize: buttonSize,
          ),
        const SizedBox(width: 10),
      ],
    ];
  }
}
