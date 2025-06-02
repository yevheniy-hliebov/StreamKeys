import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/deck_pages/bloc/deck_pages_bloc.dart';
import 'package:streamkeys/features/obs/data/repositories/obs_connection_repository.dart';
import 'package:streamkeys/features/server/server_router.dart';

class Server {
  final ObsConnectionRepository obsConnectionRepository;
  final KeyboardDeckPagesBloc keyboardDeckPagesBloc;
  final int port = 13560;
  late String ip;

  HttpServer? _server;

  Server({
    required this.obsConnectionRepository,
    required this.keyboardDeckPagesBloc,
  });

  FutureVoid init() async {
    ip = await getLocalIPv4();
  }

  FutureVoid start() async {
    final router = ServerRouter(
      obsConnectionRepository: obsConnectionRepository,
      keyboardDeckPagesBloc: keyboardDeckPagesBloc,
    );

    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(router.routerCall);

    _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);

    if (kDebugMode) {
      print('Server started on http://$ip:$port');
    }
  }

  FutureVoid stop() async {
    await _server?.close(force: true);
    if (kDebugMode) {
      print('Server stopped');
    }
  }

  static Future<String> getLocalIPv4() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 &&
            !addr.isLoopback &&
            !addr.address.startsWith('192.168.56.')) {
          return addr.address;
        }
      }
    }
    return '127.0.0.1';
  }
}
