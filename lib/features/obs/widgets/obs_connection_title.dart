import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/features/obs/bloc/obs_connection_bloc.dart';

class ObsConnectionTitle extends StatelessWidget {
  const ObsConnectionTitle({super.key});

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
      },
    );
  }
}
