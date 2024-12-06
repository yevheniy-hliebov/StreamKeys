import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/android/providers/buttons_provider.dart';
import 'package:streamkeys/android/widgets/action_button.dart';
import 'package:streamkeys/android/widgets/refresh_button.dart';
import 'package:streamkeys/common/widgets/settings_button.dart';

class AndroidHomePage extends StatelessWidget {
  const AndroidHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ButtonsProvider(context),
      child: Consumer<ButtonsProvider>(
        builder: (context, provider, child) {
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
                        provider.grid.numberOfRows,
                        provider.grid.numberOfColumns,
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
    int numOfRows,
    int numOfColumns,
  ) {
    const padding = 10;
    const gap = 10;

    final rows = orientation == Orientation.portrait ? numOfRows : numOfColumns;
    final columns =
        orientation == Orientation.portrait ? numOfColumns : numOfRows;

    final availableWidth = constraints.maxWidth - (padding * 2);
    final availableHeight = constraints.maxHeight - (padding * 2);

    final widthButton = (availableWidth - gap * rows) / rows;
    final heightButton = (availableHeight - gap * columns) / columns;

    return min(widthButton, heightButton);
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Orientation orientation;

  const _HomeAppBar({required this.orientation});

  @override
  Widget build(BuildContext context) {
    final actionProvider = Provider.of<ButtonsProvider>(context);

    if (orientation == Orientation.portrait) {
      return AppBar(
        leading: RefreshButton(
          isLoading: actionProvider.isLoading,
          onPressed: actionProvider.getButtons,
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
    final actionProvider = Provider.of<ButtonsProvider>(context);
    final numberOfRows = orientation == Orientation.portrait
        ? actionProvider.grid.numberOfRows
        : actionProvider.grid.numberOfColumns;
    final numberOfColumns = orientation == Orientation.portrait
        ? actionProvider.grid.numberOfColumns
        : actionProvider.grid.numberOfRows;

    return Column(
      mainAxisAlignment: orientation == Orientation.portrait
          ? MainAxisAlignment.start
          : MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 0; i < numberOfColumns; i++) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _buildButtonRow(actionProvider, i, numberOfRows),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  List<Widget> _buildButtonRow(
    ButtonsProvider actionProvider,
    int rowIndex,
    int rows,
  ) {
    return [
      for (int j = 0; j < rows; j++) ...[
        if (rowIndex * rows + j <
            actionProvider.buttons.length)
          ActionButton(
            buttonInfo: actionProvider
                .buttons[rowIndex * rows + j],
            buttonIndex: rowIndex * rows + j,
            buttonSize: buttonSize,
          ),
        const SizedBox(width: 10),
      ],
    ];
  }
}
