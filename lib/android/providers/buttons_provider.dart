import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/android/models/action_button_info.dart';
import 'package:streamkeys/android/models/page_data.dart';
import 'package:streamkeys/android/providers/loading_provider.dart';
import 'package:streamkeys/android/services/button_request_service.dart';
import 'package:streamkeys/android/services/find_devices.dart';
import 'package:streamkeys/android/widgets/change_device_dialog.dart';
import 'package:streamkeys/windows/models/grid_template.dart';

class ButtonsProvider extends LoadingProvider {
  ButtonRequestService buttonRequestService = ButtonRequestService();
  PageData? pageData;

  List<ActionButtonInfo> get buttons => pageData == null ? [] : pageData!.actionButtonInfos;
  int get buttonsLength => buttons.length;
  GridTemplate get grid => pageData == null ? GridTemplate(3,2) : pageData!.grid;

  ButtonsProvider(BuildContext context) {
    init(context);
  }

  Future<void> init(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hostIp = prefs.getString('hostIp');

    if ((hostIp == null || hostIp == '') && context.mounted) {
      await showMyDialog(context);
    } else {
      if (hostIp != null && hostIp != '') {
        buttonRequestService.host = hostIp;
      }
      await getButtons();
    }
  }

  Future<void> getButtons() async {
    startLoading();
      pageData = await buttonRequestService.getButtons();
    try {
    } catch (e) {
      pageData = null;
    }
    stopLoading();
  }

  Future<void> clickButton(int index) async {
    HapticFeedback.vibrate();
    await buttonRequestService.clickButton(index);
  }

  String getImageUrl(int index) {
    return "${buttonRequestService.url}/$index/image";
  }

  Future<String> getCurrentConnectedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final hostIp = prefs.getString('hostIp');

    if (hostIp != null) {
      final deviceInfo = await ButtonRequestService.getDeviceName(
        hostIp,
        ButtonRequestService.port,
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
    buttonRequestService.host = hostIp;
    await getButtons();
  }

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ChangeDeviceDialog(buttonsProvider: this);
      },
    );
  }
}
