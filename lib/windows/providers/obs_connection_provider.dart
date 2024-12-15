import 'package:flutter/material.dart';
import 'package:streamkeys/windows/services/obs_websocket_service.dart';

class ObsConnectionProvider extends ChangeNotifier {
  ObsWebSocketService obsService = ObsWebSocketService();
  bool isConnected = false;
  String? errorMessage;

  late OBSConnectionData obsConnectionData;

  final urlController = TextEditingController();
  final passwordController = TextEditingController();

  ObsConnectionProvider() {
    obsService.getData().then((_) async {
      obsConnectionData = obsService.obsConnectionData;
      urlController.text = obsConnectionData.url;
      passwordController.text = obsConnectionData.password;
      urlController.addListener(() {
        obsConnectionData.url = urlController.text;
        notifyListeners();
      });
      passwordController.addListener(() {
        obsConnectionData.password = passwordController.text;
        notifyListeners();
      });

      await connect(obsConnectionData);
    });
  }

  Future<void> connect(OBSConnectionData obsConnection) async {
    try {
      if (obsConnection.url.isEmpty || obsConnection.password.isEmpty) {
        isConnected = false;
      } else {
        await obsService.connect();
        isConnected = true;
        errorMessage = null;
      }
    } catch (e) {
      errorMessage = e.toString();
      isConnected = false;
    }
    notifyListeners();
  }

  Future<void> disconnect() async {
    await obsService.disconnect();
    isConnected = false;
    notifyListeners();
  }
}
