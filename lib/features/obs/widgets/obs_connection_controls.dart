import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/features/obs/bloc/obs_connection_bloc.dart';

class ObsConnectionControls extends StatelessWidget {
  final void Function()? onConnect;
  final void Function()? onDisconnect;

  const ObsConnectionControls({
    super.key,
    this.onConnect,
    this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObsConnectionBloc, ObsConnectionState>(
      builder: (context, state) {
        String buttonText = 'Connect';
        bool isLoading = false;
        bool isConnected = false;

        if (state is ObsConnectionConnected) {
          buttonText = 'Reconnect';
          isConnected = true;
        } else if (state is ObsConnectionLoading) {
          buttonText = 'Connecting...';
          isLoading = true;
        }

        return Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: isLoading ? null : onConnect,
                child: Text(buttonText),
              ),
            ),
            if (isConnected) ...[
              const SizedBox(width: 8),
              FilledButton(
                onPressed: onDisconnect,
                style: FilledButton.styleFrom(
                  backgroundColor: SColors.danger,
                  foregroundColor: SColors.onBackgroundDark,
                ),
                child: const Text('Disconnect'),
              )
            ],
          ],
        );
      },
    );
  }
}
