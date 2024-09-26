import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shelf/shelf.dart';
import 'base_controller.dart';

class ServerController extends BaseController {
  static Future<Response> getDeviceName(Request request) async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;

      return Response.ok(windowsInfo.computerName);
    } catch (e) {
      return BaseController.handleError(e);
    }
  }
}
