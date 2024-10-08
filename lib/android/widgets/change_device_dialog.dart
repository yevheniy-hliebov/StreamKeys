import 'package:flutter/material.dart';
import 'package:streamkeys/android/providers/actions_provider.dart';

class ChangeDeviceDialog extends StatelessWidget {
  final ActionsProvider actionsProvider;
  final void Function(int index)? onTapDevice;

  const ChangeDeviceDialog({
    super.key,
    required this.actionsProvider,
    this.onTapDevice,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Device'),
      content: SingleChildScrollView(
        child: FutureBuilder(
          future: actionsProvider.getDevices(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingIndicator();
            } else if (snapshot.hasError) {
              return _buildErrorMessage(snapshot.error.toString());
            } else if (snapshot.hasData) {
              final result = snapshot.data!;
              return _buildDeviceList(
                context,
                result['devices'],
                result['currentHostIp'],
              );
            } else {
              return const Text('No device found');
            }
          },
        ),
      ),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(child: LinearProgressIndicator());
  }

  Widget _buildErrorMessage(String message) {
    return Center(child: Text('Error: $message'));
  }

  Widget _buildDeviceList(
    BuildContext context,
    List devices,
    String currentHostIp,
  ) {
    return Column(
      children: List.generate(devices.length, (index) {
        return ListTile(
          title: Text(devices[index].name),
          subtitle: Text(devices[index].ip),
          selected: currentHostIp == devices[index].ip,
          onTap: () => _onDeviceTap(context, devices[index].ip),
        );
      }),
    );
  }

  Future<void> _onDeviceTap(BuildContext context, String ip) async {
    await actionsProvider.updateHostIp(ip);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
