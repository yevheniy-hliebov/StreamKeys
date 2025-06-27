import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:streamkeys/desktop/server/auth_middleware.dart';
import 'package:streamkeys/desktop/server/router.dart';
import 'package:streamkeys/desktop/utils/helper_functions.dart';

class Server {
  final int port = 13560;
  late String ip;
  late HttpServer? _server;

  Future<void> init() async {
    ip = await HelperFunctions.getLocalIPv4();
  }

  Future<void> start() async {
    final router = ServerRouter();

    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(authMiddleware(() => 'password'))
        .addHandler(router.routerCall);

    _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);

    if (kDebugMode) {
      print('Server started on http://$ip:$port');
    }
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    if (kDebugMode) {
      print('Server stopped');
    }
  }
}
