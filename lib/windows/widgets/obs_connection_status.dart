import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/windows/providers/server_provider.dart';

class OBSConnectionStatus extends StatelessWidget {
  final ServerProvider provider;

  const OBSConnectionStatus({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    String tooltipMessage = 'Not connected';
    if (provider.isConnecting) {
      tooltipMessage = 'Сonnecting...';
    } else if (provider.isOBSConnected) {
      tooltipMessage = 'Connected';
    }

    return Tooltip(
      message: tooltipMessage,
      child: Material(
        child: InkWell(
          onTap: provider.reconnect,
          child: Container(
            color: SColors.of(context).background,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Row(
              children: [
                Text(
                  'OBS',
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
                    color: provider.isOBSConnected ? Colors.green : Colors.red,
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
