import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:streamkeys/windows/server/router.dart';

class Server {
  static int port = 8080;

  static Future<void> start() async {
    ServerRouter.routerHandler();

    var handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(ServerRouter.routerCall);

    var server = await io.serve(handler, InternetAddress.anyIPv4, port);
    if (kDebugMode) {
      print('Сервер запущено: http://${server.address.host}:${server.port}');
    }
  }

  static Future<String> getHost() async {
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
}