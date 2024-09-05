import 'package:flutter/material.dart';
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
  String ipv4 = '';
  int actionsCount = 28;

  List<ButtonAction> actions = [];

  @override
  void initState() {
    super.initState();
    Server.getIPv4().then((ip) {
      setState(() {
        ipv4 = ip;
      });
    });
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
                  InkWell(
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
                        ButtonActionJsonHandler.readActions().then((list) {
                          setState(() {
                            actions = list;
                          });
                        });
                      }
                    },
                    child: Tooltip(
                      message: actions[i].name,
                      child: Container(
                        width: 41.5,
                        height: 41.5,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: _buildButtonActionContent(i),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonActionContent(int index) {
    if (actions[index].imagePath == '') {
      return const Icon(Icons.add);
    }
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.file(actions[index].getImageFile()),
    );
  }
}
