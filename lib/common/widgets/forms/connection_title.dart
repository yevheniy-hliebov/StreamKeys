import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/core/constants/colors.dart';

class ConnectionTitle extends StatelessWidget {
  final String title;
  final ConnectionStatus status;

  const ConnectionTitle({
    super.key,
    required this.title,
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
          Text(title, style: TextTheme.of(context).bodyLarge),
          Text(
            connectionStatus,
            style: TextTheme.of(context).bodySmall?.copyWith(color: statusColor),
          ),
        ],
      ),
    );
  }
}
