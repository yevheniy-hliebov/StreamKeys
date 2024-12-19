import 'package:flutter/material.dart';
import 'package:streamkeys/android/providers/buttons_provider.dart';

class DeviceSelectionTile extends StatefulWidget {
  final ButtonsProvider? actionsProvider;

  const DeviceSelectionTile({super.key, this.actionsProvider});

  @override
  State<DeviceSelectionTile> createState() => _DeviceSelectionTileState();
}

class _DeviceSelectionTileState extends State<DeviceSelectionTile> {
  String currentDevice = 'No device connected';

  @override
  void initState() {
    super.initState();
    widget.actionsProvider?.getCurrentConnectedDevice().then(
          (value) => setState(() => currentDevice = value),
        );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        'Select Device',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(currentDevice),
      onTap: () => widget.actionsProvider?.showMyDialog(context),
    );
  }
}
