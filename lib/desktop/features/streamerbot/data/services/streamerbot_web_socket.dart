import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/models/do_action_response.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/models/get_actions_response.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/models/streamerbot_action.dart';

typedef EventHandler = void Function(Object event);

class StreamerBotWebSocket {
  WebSocket? _socket;
  StreamSubscription? _subscription;

  String get generatedId => DateTime.now().millisecondsSinceEpoch.toString();
  final _pendingResponses = <String, Completer<Map<String, dynamic>>>{};

  Future<void> connect(
    String url, {
    String? password,
    EventHandler? fallbackEventHandler,
  }) async {
    _socket = await WebSocket.connect(url);

    _log('Connected to $url');

    _subscription = _socket?.listen(
      (data) async {
        final event = jsonDecode(data);

        if (event is Map<String, dynamic> && event.containsKey('id')) {
          final id = event['id'];
          if (_pendingResponses.containsKey(id)) {
            _pendingResponses.remove(id)?.complete(event);
            return;
          }
        }

        if (event['authentication'] != null && password != null) {
          final salt = event['authentication']['salt'];
          final challenge = event['authentication']['challenge'];
          await _authenticate(salt, challenge, password);
        }

        fallbackEventHandler?.call(event);
      },
      onDone: () {
        _log(
          'Socket closed, code: ${_socket?.closeCode}, reason: ${_socket?.closeReason}',
        );
      },
      onError: (error) {
        _log('Socket error: $error');
      },
      cancelOnError: true,
    );
  }

  Future<void> close() async {
    await _subscription?.cancel();
    await _socket?.close();
    _socket = null;
    _log('Socket closed manually');
  }

  Future<void> _authenticate(
    String salt,
    String challenge,
    String password,
  ) async {
    final hash1 = sha256.convert(utf8.encode(password + salt));
    final hash2 = sha256.convert(
      utf8.encode(base64.encode(hash1.bytes) + challenge),
    );
    final authPayload = base64.encode(hash2.bytes);

    final request = jsonEncode({
      'id': generatedId,
      'request': 'Authenticate',
      'authentication': authPayload,
    });

    _socket?.add(request);
    _log('Sent authentication request');
  }

  Future<GetActionsResponse> getActions() async {
    final id = generatedId;
    final completer = Completer<Map<String, dynamic>>();
    _pendingResponses[id] = completer;

    final request = jsonEncode({
      'request': 'GetActions',
      'id': id,
    });

    _socket?.add(request);
    _log('Sent GetActions request');

    final json = await completer.future;
    return GetActionsResponse.fromJson(json);
  }

  Future<StreamerBotAction?> getAction(String id) async {
    final response = await getActions();

    try {
      return response.actions.firstWhere((action) => action.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<DoActionResponse> doAction({
    required String id,
    required String name,
    Map<String, dynamic>? args,
  }) async {
    final requestId = generatedId;
    final completer = Completer<Map<String, dynamic>>();
    _pendingResponses[requestId] = completer;

    final request = jsonEncode({
      'request': 'DoAction',
      'action': {'id': id, 'name': name},
      'args': args ?? {},
      'id': requestId,
    });

    _socket?.add(request);
    _log('Sent DoAction request');

    final json = await completer.future;
    return DoActionResponse.fromJson(json);
  }

  void _log(String message) {
    if (kDebugMode) {
      print('StreamerBotWebSocket: $message');
    }
  }
}
