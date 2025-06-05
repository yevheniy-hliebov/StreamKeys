import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/common/widgets/connection_status_indicator.dart';
import 'package:streamkeys/features/obs/bloc/obs_connection_bloc.dart';

class ObsConnectionStatus extends StatelessWidget {
  const ObsConnectionStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObsConnectionBloc, ObsConnectionState>(
      builder: (context, state) {
        ConnectionStatus status = ConnectionStatus.notConnected;

        if (state is ObsConnectionConnected) {
          status = ConnectionStatus.connected;
        } else if (state is ObsConnectionLoading) {
          status = ConnectionStatus.connecting;
        }

        return ConnectionStatusIndicator(
          label: 'OBS',
          status: status,
          onReconnect: () => context.read<ObsConnectionBloc>().add(
                const ObsConnectionReconnectEvent(),
              ),
        );
      },
    );
  }
}
