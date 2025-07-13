import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/widgets/connection_status_indicator.dart';
import 'package:streamkeys/desktop/features/streamerbot/bloc/connection/streamerbot_connection_bloc.dart';
import 'package:streamkeys/service_locator.dart';

class StreamerBotConnectionStatusIndicator extends StatelessWidget {
  const StreamerBotConnectionStatusIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StreamerBotConnectionBloc, StreamerBotConnectionState>(
      builder: (context, state) {
        return ConnectionStatusIndicator(
          label: 'Streamer.bot',
          status: state.status,
          onReconnect: sl<StreamerBotService>().reconnect,
        );
      },
    );
  }
}
