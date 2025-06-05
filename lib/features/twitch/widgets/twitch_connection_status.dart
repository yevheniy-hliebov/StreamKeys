import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/widgets/connection_status_indicator.dart';
import 'package:streamkeys/features/twitch/bloc/connection/twitch_connection_bloc.dart';
import 'package:streamkeys/features/twitch/bloc/connection/twitch_connection_state.dart';

class TwitchConnectionStatus extends StatelessWidget {
  const TwitchConnectionStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TwitchConnectionBloc, TwitchConnectionState>(
      builder: (context, state) {
        return Row(
          spacing: 12,
          children: [
            ConnectionStatusIndicator(
              label: 'Twitch Broadcaster',
              status: state.broadcaster,
            ),
            ConnectionStatusIndicator(
              label: 'Twitch Bot',
              status: state.bot,
            ),
          ],
        );
      },
    );
  }
}
