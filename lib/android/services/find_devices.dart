import 'package:flutter/foundation.dart';
import 'package:network_discovery/network_discovery.dart';
import 'package:streamkeys/android/models/device_info.dart';
import 'package:streamkeys/android/services/button_request_service.dart';
import 'package:streamkeys/windows/server/server.dart';

Future<List<DeviceInfo>> findDevices() async {
  const port = Server.port;
  int found = 0;
  List<DeviceInfo> devices = [];

  await for (final NetworkAddress addr
      in NetworkDiscovery.discover('192.168.1', port)) {
    found++;
    final deviceInfo = await ButtonRequestService.getDeviceName(addr.ip, port);
    devices.add(deviceInfo);
  }

  if (kDebugMode) {
    print('Finish. Found $found device(s)');
  }

  return devices;
}
