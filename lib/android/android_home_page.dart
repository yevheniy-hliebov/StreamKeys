import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streamkeys/android/last_octet_page.dart';
import 'package:streamkeys/android/models/action.dart';
import 'package:streamkeys/android/services/action_request_service.dart';
import 'package:streamkeys/common/widgets/action_button.dart';

class AndroidHomePage extends StatefulWidget {
  final int lastOctet;

  const AndroidHomePage({
    super.key,
    required this.lastOctet,
  });

  @override
  State<AndroidHomePage> createState() => _AndroidHomePageState();
}

class _AndroidHomePageState extends State<AndroidHomePage> {
  late ActionRequestService actionRequestService;
  List<ButtonAction> actions = [];

  @override
  void initState() {
    super.initState();
    actionRequestService = ActionRequestService(lastOctet: widget.lastOctet);
    getActions();
  }

  Future<void> getActions() async {
    actionRequestService.getActions().then(
      (list) {
        setState(() {
          actions = list;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold(
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
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return IgnorePointer(
              ignoring: action.disabled,
              child: ActionButton(
                onTap: () {
                  HapticFeedback.vibrate();
                  actionRequestService.clickAction(action.id);
                },
                tooltipMessage: action.name,
                size: buttonSize,
                child: Builder(
                  builder: (context) {
                    if (action.hasImage) {
                      return Image.network(
                        "${actionRequestService.url}/${action.id}/image",
                        fit: BoxFit.contain,
                      );
                    } else {
                      return const SizedBox();
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

  Widget buildScaffold({required Widget body}) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('StreamKeys'),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  getActions();
                },
                icon: const Icon(Icons.refresh),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    final lastOctet = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LastOctetPage(
                          isFirstPage: false,
                          lastOctet: actionRequestService.lastOctet,
                        ),
                      ),
                    );
                    setState(() {
                      actionRequestService.lastOctet = int.parse(lastOctet);
                    });
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
