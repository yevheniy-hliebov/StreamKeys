import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/android/providers/actions_provider.dart';
import 'package:streamkeys/common/widgets/action_button.dart';

class AndroidHomePage extends StatelessWidget {
  const AndroidHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ActionsProvider(context),
      child: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPortrait(Orientation orientation) =>
      orientation == Orientation.portrait;

  int calculateCountInRow(Orientation orientation) =>
      isPortrait(orientation) ? 4 : 7;

  int calculateCountInColumn(Orientation orientation) =>
      isPortrait(orientation) ? 7 : 4;

  @override
  Widget build(BuildContext context) {
    final actionProvider = Provider.of<ActionsProvider>(context);
    final orientation = MediaQuery.of(context).orientation;
    final countInRow = calculateCountInRow(orientation);
    final countInColumn = calculateCountInColumn(orientation);

    return Scaffold(
      appBar: _buildAppBar(actionProvider, orientation),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final buttonSize = _calculateButtonSize(
              constraints,
              countInRow,
              countInColumn,
            );

            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: isPortrait(orientation)
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _buildButtonRows(
                  actionProvider,
                  countInRow,
                  countInColumn,
                  buttonSize,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar? _buildAppBar(
      ActionsProvider actionProvider, Orientation orientation) {
    if (isPortrait(orientation)) {
      return AppBar(
        title: const Text('StreamKeys'),
        centerTitle: true,
        leading: _buildRefreshButton(
          isLoading: actionProvider.isLoading,
          onPressed: actionProvider.getActions,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await actionProvider.updateDevice(context);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      );
    }
    return null;
  }

  Widget _buildRefreshButton({
    required void Function()? onPressed,
    bool isLoading = false,
  }) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.refresh),
    );
  }

  double _calculateButtonSize(
    BoxConstraints constraints,
    int countInRow,
    int countInColumn,
  ) {
    const padding = 10;
    const gap = 10;

    var availableWidth = constraints.maxWidth - (padding * 2);
    var availableHeight = constraints.maxHeight - (padding * 2);

    var widthButton = (availableWidth - gap * countInRow) / countInRow;
    var heightButton = (availableHeight - gap * countInColumn) / countInColumn;
    return min(widthButton, heightButton);
  }

  List<Widget> _buildButtonRows(
    ActionsProvider actionProvider,
    int countInRow,
    int countInColumn,
    double buttonSize,
  ) {
    return [
      for (int i = 0; i < countInColumn; i++) ...[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildButtonRow(actionProvider, i, countInRow, buttonSize),
        ),
        const SizedBox(height: 10),
      ],
    ];
  }

  List<Widget> _buildButtonRow(
    ActionsProvider actionProvider,
    int rowIndex,
    int countInRow,
    double buttonSize,
  ) {
    return [
      for (int j = 0; j < countInRow; j++) ...[
        if (rowIndex * countInRow + j < actionProvider.actions.length)
          _buildActionButton(
            actionProvider,
            rowIndex * countInRow + j,
            buttonSize,
          ),
        const SizedBox(width: 10),
      ],
    ];
  }

  Widget _buildActionButton(
    ActionsProvider actionProvider,
    int index,
    double sizeButton,
  ) {
    final action = actionProvider.actions[index];

    Widget? child;
    if (action.hasImage && !action.disabled) {
      child = Image.network(
        actionProvider.getImageUrl(action.id),
        fit: BoxFit.cover,
      );
    }

    return IgnorePointer(
      ignoring: action.disabled,
      child: ActionButton(
        onTap: () => actionProvider.clickAction(action.id),
        tooltipMessage: action.name,
        size: sizeButton,
        child: child ?? const Icon(Icons.lock),
      ),
    );
  }
}
