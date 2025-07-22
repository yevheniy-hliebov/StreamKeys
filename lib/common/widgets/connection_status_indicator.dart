import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/core/constants/typography.dart';

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
    Color statusColor = AppColors.of(context).danger;

    switch (status) {
      case ConnectionStatus.connected:
        connectionText = 'Connected';
        statusColor = AppColors.of(context).success;
        break;
      case ConnectionStatus.connecting:
        connectionText = 'Connecting...';
        statusColor = AppColors.of(context).warning;
        break;
      case ConnectionStatus.notConnected:
        connectionText = 'Not connected';
        statusColor = AppColors.of(context).danger;
        break;
    }

    return Tooltip(
      message: connectionText,
      child: InkWell(
        onTap: status == ConnectionStatus.connecting ? null : onReconnect,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.sm,
            vertical: Spacing.xxs,
          ),
          child: Row(
            spacing: Spacing.xs,
            children: [
              Container(
                width: Spacing.sm,
                height: Spacing.sm,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: AppColors.of(context).onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
