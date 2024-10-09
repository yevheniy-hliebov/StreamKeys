import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/action.dart';
import 'package:streamkeys/windows/server/server.dart';
import 'package:streamkeys/windows/services/action_json_handler.dart';
import 'package:streamkeys/windows/services/tray_manager_service.dart';
import 'package:streamkeys/windows/screens/setting_action.dart';

class WindowsHomePageProvider with ChangeNotifier {
  String _host = '';
  String _computerName = '';
  List<ButtonAction> actions = [];
  final TrayManagerService trayManagerService = TrayManagerService();

  String get nameAndHost => "$_computerName - $_host";

  WindowsHomePageProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await getComputerName();
    _host = await Server.getHost();
    readActionsAndSet();
    await trayManagerService.setupTray();
  }

  Future<void> getComputerName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
    _computerName = windowsInfo.computerName;
    notifyListeners();
  }

  Future<void> readActionsAndSet() async {
    actions = await ButtonActionJsonHandler.readActions();
    notifyListeners();
  }

  Future<void> saveActions() async {
    await ButtonActionJsonHandler.saveActions(actions);
    notifyListeners();
  }

  Future<void> onTapActionButton(BuildContext context, int indexAction) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingActionPage(
          action: actions[indexAction],
        ),
      ),
    );
    if (result != null && result == 'Updated') {
      readActionsAndSet();
    }
  }

  void onReorder(int oldIndex, int newIndex) {
    final action = actions.removeAt(oldIndex);
    actions.insert(newIndex, action);
    saveActions();
  }

  @override
  void dispose() {
    trayManagerService.dispose();
    super.dispose();
  }
}
