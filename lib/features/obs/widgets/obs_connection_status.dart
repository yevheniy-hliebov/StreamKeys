import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/features/obs/bloc/obs_connection_bloc.dart';

class ObsConnectionStatus extends StatelessWidget {
  const ObsConnectionStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObsConnectionBloc, ObsConnectionState>(
        builder: (context, state) {
      String connectionStatus = 'Not connected';
      Color statusColor = SColors.danger;

      if (state is ObsConnectionConnected) {
        connectionStatus = 'Connected';
        statusColor = SColors.success;
      } else if (state is ObsConnectionLoading) {
        connectionStatus = 'Connecting...';
        statusColor = SColors.warning;
      }

      void reconnect() {
        final bloc = context.read<ObsConnectionBloc>();
        bloc.add(const ObsConnectionReconnectEvent());
      }

      return Tooltip(
        message: connectionStatus,
        child: Material(
          child: InkWell(
            onTap: () => state is ObsConnectionLoading ? null : reconnect(),
            child: Container(
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
    });
  }
}
