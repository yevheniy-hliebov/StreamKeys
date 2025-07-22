import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/widgets/connection_status_indicator.dart';
import 'package:streamkeys/desktop/features/obs/bloc/connection/obs_connection_bloc.dart';
import 'package:streamkeys/service_locator.dart';

class ObsConnectionStatusIndicator extends StatelessWidget {
  const ObsConnectionStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObsConnectionBloc, ObsConnectionState>(
      builder: (context, state) {
        return ConnectionStatusIndicator(
          label: 'OBS',
          status: state.status,
          onReconnect: sl<ObsService>().reconnect,
        );
      },
    );
  }
}
