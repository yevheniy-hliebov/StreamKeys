import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/android/models/action.dart';
import 'package:streamkeys/android/providers/loading_provider.dart';
import 'package:streamkeys/android/services/action_request_service.dart';
import 'package:streamkeys/android/services/find_devices.dart';
import 'package:streamkeys/android/widgets/change_device_dialog.dart';

class ActionsProvider extends LoadingProvider {
  ActionRequestService actionRequestService = ActionRequestService();
  List<ButtonAction> actions = [];

  int get actionsLength => actions.length;

  ActionsProvider(BuildContext context) {
    init(context);
  }

  Future<void> init(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hostIp = prefs.getString('hostIp');

    if ((hostIp == null || hostIp == '') && context.mounted) {
      await showMyDialog(context);
    } else {
      if (hostIp != null && hostIp != '') {
        actionRequestService.host = hostIp;
      }
      await getActions();
    }
  }

  Future<void> getActions() async {
    startLoading();
    try {
      actions = await actionRequestService.getActions();
    } catch (e) {
      actions = [];
    }
    stopLoading();
  }

  Future<void> clickAction(int id) async {
    HapticFeedback.vibrate();
    await actionRequestService.clickAction(id);
  }

  String getImageUrl(int id) {
    return "${actionRequestService.url}/$id/image";
  }

  Future<String> getCurrentConnectedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final hostIp = prefs.getString('hostIp');

    if (hostIp != null) {
      final deviceInfo = await ActionRequestService.getDeviceName(
        hostIp,
        ActionRequestService.port,
      );

      return deviceInfo.nameAndHost;
    }

    return 'No device connected';
  }

  Future<Map<String, dynamic>> getDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final hostIp = prefs.getString('hostIp');

    final devices = await findDevices();

    return {
      'currentHostIp': hostIp,
      'devices': devices,
    };
  }

  Future<void> updateHostIp(String hostIp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hostIp', hostIp);
    actionRequestService.host = hostIp;
    await getActions();
  }

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ChangeDeviceDialog(actionsProvider: this);
      },
    );
  }
}
