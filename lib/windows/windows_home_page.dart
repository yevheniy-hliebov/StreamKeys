import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/action_button.dart';
import 'package:streamkeys/windows/models/action.dart';
import 'package:streamkeys/windows/server.dart';
import 'package:streamkeys/windows/services/action_json_handler.dart';
import 'package:streamkeys/windows/setting_action.dart';

class WindowsHomePage extends StatefulWidget {
  const WindowsHomePage({super.key});

  @override
  State<WindowsHomePage> createState() => _WindowsHomePageState();
}

class _WindowsHomePageState extends State<WindowsHomePage> {
  final double widthPage = 380;
  final double heightPage = 252;
  String ipv4 = '';
  int actionsCount = 28;

  List<ButtonAction> actions = [];

  double get actionButtonSize {
    final width = (widthPage - ((7 + 2) * 10)) / 7;
    final height = (heightPage - 16 - ((4 + 2) * 10)) / 4;
    return width > height ? height : width;
  }

  @override
  void initState() {
    super.initState();
    Server.getIPv4().then((ip) {
      setState(() {
        ipv4 = ip;
      });
    });
    readActionsAndSet();
  }
  
  Future<void> readActionsAndSet() async {
    ButtonActionJsonHandler.readActions().then((list) {
      setState(() {
        actions = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("IPv4 - $ipv4"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (var i = 0; i < actions.length; i++) ...[
                  ActionButton(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingActionPage(
                            action: actions[i],
                          ),
                        ),
                      );
                      if (result != null && result == 'Updated') {
                        readActionsAndSet();
                      }
                    },
                    size: actionButtonSize,
                    child: _buildButtonActionContent(actions[i]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonActionContent(ButtonAction action) {
    if (action.imagePath == '') {
      return const Icon(Icons.add);
    }
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.file(action.getImageFile()),
    );
  }
}
