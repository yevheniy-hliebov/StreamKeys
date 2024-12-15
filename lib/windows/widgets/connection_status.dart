import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';

class ConnectionStatus extends StatelessWidget {
  final bool isConnected;

  const ConnectionStatus({super.key, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SColors.of(context).background,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: isConnected ? 'Connected' : 'Not connected',
            child: Text(
              'OBS',
              style: TextStyle(
                fontSize: 12,
                color: SColors.of(context).onBackground,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isConnected ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
