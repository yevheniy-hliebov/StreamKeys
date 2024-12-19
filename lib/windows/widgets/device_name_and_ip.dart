import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:streamkeys/windows/server/server.dart';

class DeviceNameAndIp extends StatefulWidget {
  const DeviceNameAndIp({super.key});

  @override
  State<DeviceNameAndIp> createState() => _DeviceNameAndIpState();
}

class _DeviceNameAndIpState extends State<DeviceNameAndIp> {
  String _host = '';
  String _computerName = '';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    final computerName = await getComputerName();
    final host = await Server.getHost();
    setState(() {
      _computerName = computerName;
      _host = host;
    });
  }

  Future<String> getComputerName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
    return windowsInfo.computerName;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Device name: $_computerName    Device IPv4: $_host',
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }
}
