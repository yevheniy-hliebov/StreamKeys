import 'package:obs_websocket/obs_websocket.dart';

// ignore: one_member_abstracts
abstract class ObsWebSocketFactory {
  Future<ObsWebSocket> connect(
    String url, {
    required String password,
    required void Function(Event) fallbackEventHandler,
  });
}

class DefaultObsWebSocketFactory implements ObsWebSocketFactory {
  @override
  Future<ObsWebSocket> connect(
    String url, {
    required String password,
    required void Function(Event) fallbackEventHandler,
  }) {
    return ObsWebSocket.connect(
      url,
      password: password,
      fallbackEventHandler: fallbackEventHandler,
    );
  }
}
