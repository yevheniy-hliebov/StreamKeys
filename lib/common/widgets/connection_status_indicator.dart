import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/common/models/connection_status.dart';

class ConnectionStatusIndicator extends StatelessWidget {
  final String label;
  final ConnectionStatus status;
  final VoidCallback? onReconnect;

  const ConnectionStatusIndicator({
    super.key,
    required this.label,
    required this.status,
    this.onReconnect,
  });

  @override
  Widget build(BuildContext context) {
    String connectionText = 'Not connected';
    Color statusColor = SColors.danger;

    switch (status) {
      case ConnectionStatus.connected:
        connectionText = 'Connected';
        statusColor = SColors.success;
        break;
      case ConnectionStatus.connecting:
        connectionText = 'Connecting...';
        statusColor = SColors.warning;
        break;
      case ConnectionStatus.notConnected:
        connectionText = 'Not connected';
        statusColor = SColors.danger;
        break;
    }

    return Tooltip(
      message: connectionText,
      child: Material(
        child: InkWell(
          onTap: status == ConnectionStatus.connecting ? null : onReconnect,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: SColors.of(context).onBackground,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
