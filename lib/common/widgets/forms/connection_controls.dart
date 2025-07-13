import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/core/constants/colors.dart';

class ConnectionControls extends StatelessWidget {
  final ConnectionStatus status;
  final void Function()? onConnect;
  final void Function()? onDisconnect;

  const ConnectionControls({
    super.key,
    this.status = ConnectionStatus.notConnected,
    this.onConnect,
    this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    String buttonText = 'Connect';
    bool isLoading = false;
    bool isConnected = false;

    if (status == ConnectionStatus.connected) {
      buttonText = 'Reconnect';
      isConnected = true;
    } else if (status == ConnectionStatus.connecting) {
      buttonText = 'Connecting...';
      isLoading = true;
    }

    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: FilledButton(
            onPressed: isLoading ? null : onConnect,
            child: Text(buttonText),
          ),
        ),
        if (isConnected) ...[
          FilledButton(
            onPressed: onDisconnect,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.of(context).danger,
              foregroundColor: AppColors.of(context).onBackground,
            ),
            child: const Text('Disconnect'),
          )
        ],
      ],
    );
  }
}
