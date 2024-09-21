import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:streamkeys/windows/models/action.dart';
import 'package:streamkeys/windows/services/action_json_handler.dart';

class Server {
  static final _router = Router();

  static void routerHandler() {
    _router.get('/', _getActions);
    _router.get('/device-name', _getDeviceName);
    _router.get('/<id>/image', _getImage);
    _router.get('/<id>/click', _clickButtonAction);
  }

  static Future<void> start() async {
    var handler =
        const Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

    var server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
    if (kDebugMode) {
      print('Сервер запущено: http://${server.address.host}:${server.port}');
    }
  }

  static Future<String> getIPv4() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 &&
            addr.address.contains('192.168.')) {
          return addr.address;
        }
      }
    }
    return '';
  }

  static Future<Response> _getActions(Request request) async {
    final actions = await ButtonActionJsonHandler.readActions();
    final responseActions = ButtonActionJsonHandler.list2JsonResponse(actions);

    return Response.ok(
      jsonEncode(responseActions),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<Response> _getImage(Request request, String id) async {
    int actionId = int.tryParse(id) ?? -1;
    final actions = await ButtonActionJsonHandler.readActions();
    ButtonAction action = actions.firstWhere((a) => a.id == actionId);

    if (action.imagePath.isNotEmpty) {
      File imageFile = action.getImageFile();
      if (imageFile.existsSync()) {
        return Response.ok(
          action.getImageBytes(),
          headers: {'Content-Type': 'image/jpeg'},
        );
      } else {
        return Response.notFound('Image not found');
      }
    } else {
      return Response.notFound('Image not found');
    }
  }

  static Future<Response> _clickButtonAction(Request request, String id) async {
    int actionId = int.tryParse(id) ?? -1;
    final actions = await ButtonActionJsonHandler.readActions();
    ButtonAction action = actions.firstWhere((a) => a.id == actionId);

    try {
      await action.runFile();
      return Response.ok('Command successfully runned');
    } catch (e) {
      return Response.badRequest(body: e.toString());
    }
  }

  static Future<Response> _getDeviceName(Request request) async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      
      return Response.ok(windowsInfo.computerName);
    } catch (e) {
      return Response.badRequest(body: e.toString());
    }
  }
}
