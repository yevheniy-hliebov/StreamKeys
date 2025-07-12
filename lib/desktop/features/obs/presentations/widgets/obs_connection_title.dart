import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/core/constants/colors.dart';

class ObsConnectionTitle extends StatelessWidget {
  final ConnectionStatus status;

  const ObsConnectionTitle({
    super.key,
    this.status = ConnectionStatus.notConnected,
  });

  @override
  Widget build(BuildContext context) {
    String connectionStatus = 'Not connected';
    Color statusColor = AppColors.of(context).danger;

    if (status == ConnectionStatus.connected) {
      connectionStatus = 'Connected';
      statusColor = AppColors.of(context).success;
    } else if (status == ConnectionStatus.connecting) {
      connectionStatus = 'Connecting...';
      statusColor = AppColors.of(context).warning;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'OBS Connection',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            connectionStatus,
            style: TextStyle(
              fontSize: 14,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
