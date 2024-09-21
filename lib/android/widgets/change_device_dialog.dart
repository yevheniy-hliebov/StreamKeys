import 'package:flutter/material.dart';
import 'package:streamkeys/android/models/device_info.dart';

class ChangeDeviceDialog extends StatelessWidget {
  final String hostIp;
  final List<DeviceInfo> devices;
  final void Function(int index)? onTapDevice;

  const ChangeDeviceDialog({
    super.key,
    required this.hostIp,
    required this.devices,
    this.onTapDevice,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Device'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < devices.length; i++) ...[
              ListTile(
                title: Text(devices[i].name),
                subtitle: Text(devices[i].ip),
                selected: hostIp == devices[i].ip,
                onTap: () {
                  onTapDevice?.call(i);
                },
              )
            ]
          ],
        ),
      ),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
