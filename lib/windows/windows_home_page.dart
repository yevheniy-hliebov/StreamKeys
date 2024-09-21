import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:streamkeys/common/widgets/action_button.dart';
import 'package:streamkeys/windows/models/action.dart';
import 'package:streamkeys/windows/server.dart';
import 'package:streamkeys/windows/services/action_json_handler.dart';
import 'package:streamkeys/windows/setting_action.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class WindowsHomePage extends StatefulWidget {
  const WindowsHomePage({super.key});

  @override
  State<WindowsHomePage> createState() => _WindowsHomePageState();
}

class _WindowsHomePageState extends State<WindowsHomePage> with TrayListener {
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
    _setupTray();
    trayManager.addListener(this);
    readActionsAndSet();
  }

  Future<void> _setupTray() async {
    final directory = await getApplicationSupportDirectory();
    String iconPath =
        '${directory.path}/app_icon.ico';

    if (!File(iconPath).existsSync()) {
      final appIcon = File('lib/windows/app_icon.ico');
      await appIcon.copy(iconPath);
    }

    await trayManager.setIcon(iconPath);
    
    Menu menu = Menu(
      items: [
        MenuItem(
          key: 'show',
          label: 'Show',
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'exit',
          label: 'Exit',
        ),
      ],
    );
    await trayManager.setContextMenu(menu);
  }

  @override
  void onTrayIconMouseDown() {
    super.onTrayIconMouseDown();
    windowManager.show();
  }
  
  @override
  void onTrayIconRightMouseDown() {
    super.onTrayIconRightMouseDown();
    trayManager.popUpContextMenu();
  }
  
  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    super.onTrayMenuItemClick(menuItem);

    if (menuItem.key == 'show') {
      windowManager.show();
    } else if (menuItem.key == 'exit') {
      windowManager.close();
    }
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