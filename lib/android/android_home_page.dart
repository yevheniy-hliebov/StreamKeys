import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/android/providers/actions_provider.dart';
import 'package:streamkeys/common/widgets/action_button.dart';

class AndroidHomePage extends StatelessWidget {
  const AndroidHomePage({
    super.key,
  });

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
  @override
  Widget build(BuildContext context) {
    final actionProvider = Provider.of<ActionsProvider>(context);

    return buildScaffold(
      actionProvider: actionProvider,
      body: OrientationBuilder(builder: (context, orientation) {
        // Determine the number of columns and rows based on orientation
        int crossAxisCount;
        int mainAxisCount;

        if (orientation == Orientation.portrait) {
          crossAxisCount = 4; // Number of columns in portrait
          mainAxisCount = 7; // Number of rows in portrait
        } else {
          crossAxisCount = 7; // Number of columns in landscape
          mainAxisCount = 4; // Number of rows in landscape
        }

        // Calculate the size of each button to fit the screen
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;

        final width =
            (screenWidth - ((crossAxisCount + 2) * 10)) / crossAxisCount;
        final height =
            (screenHeight - ((mainAxisCount + 2) * 10)) / mainAxisCount;

        double buttonSize = width > height ? height : width;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: orientation == Orientation.portrait
              ? const EdgeInsets.all(10)
              : const EdgeInsets.symmetric(vertical: 20, horizontal: 75),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: actionProvider.actionsLength,
          itemBuilder: (context, index) {
            final action = actionProvider.actions[index];
            return IgnorePointer(
              ignoring: action.disabled,
              child: ActionButton(
                onTap: () => actionProvider.clickAction(action.id),
                tooltipMessage: action.name,
                size: buttonSize,
                child: Builder(
                  builder: (context) {
                    if (action.hasImage) {
                      return Image.network(
                        actionProvider.getImageUrl(action.id),
                        fit: BoxFit.contain,
                      );
                    } else {
                      return const Icon(Icons.lock);
                    }
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget buildScaffold(
      {required Widget body, required ActionsProvider actionProvider}) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('StreamKeys'),
              centerTitle: true,
              leading: Builder(builder: (context) {
                if (actionProvider.isLoading) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                }
                return IconButton(
                  onPressed: actionProvider.getActions,
                  icon: const Icon(Icons.refresh),
                );
              }),
              actions: [
                IconButton(
                  onPressed: () async {
                    return actionProvider.updateLastOctet(context);
                  },
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
            body: body,
          );
        } else {
          return Scaffold(
            body: body,
          );
        }
      },
    );
  }
}
