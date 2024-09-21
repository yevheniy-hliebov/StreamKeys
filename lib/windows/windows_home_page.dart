import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
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
  String computerName = '';

  List<ButtonAction> actions = [];

  double get actionButtonSize {
    final width = (widthPage - ((7 + 2) * 10)) / 7;
    final height = (heightPage - 16 - ((4 + 2) * 10)) / 4;
    return width > height ? height : width;
  }

  @override
  void initState() {
    super.initState();
    getComputerName();
    Server.getIPv4().then((ip) {
      setState(() {
        ipv4 = ip;
      });
    });
    readActionsAndSet();
  }

  Future<void> getComputerName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
    setState(() {
      computerName = windowsInfo.computerName;
    });
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
          Text("$computerName - $ipv4"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReorderableWrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(actions.length, (i) {
                return ActionButton(
                  key: ValueKey(actions[i]),
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
                  tooltipMessage: actions[i].name,
                  size: actionButtonSize,
                  child: _buildButtonActionContent(actions[i]),
                );
              }),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  final action = actions.removeAt(oldIndex);
                  actions.insert(newIndex, action);
                  ButtonActionJsonHandler.saveActions(actions);
                });
              },
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
