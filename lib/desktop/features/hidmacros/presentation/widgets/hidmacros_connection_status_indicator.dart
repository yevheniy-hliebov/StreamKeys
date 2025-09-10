import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/widgets/connection_status_indicator.dart';
import 'package:streamkeys/desktop/features/connection/bloc/integration_connection_bloc.dart';
import 'package:streamkeys/desktop/features/hidmacros/bloc/connection/hidmacros_connection_bloc.dart';

class HidMacrosStatusIndicator extends StatelessWidget {
  const HidMacrosStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HidMacrosConnectionBloc, IntegrationConnectionState>(
      builder: (context, state) {
        return ConnectionStatusIndicator(
          label: 'HID Macros',
          status: state.status,
          onReconnect: () {
            context.read<HidMacrosConnectionBloc>().add(IntegrationConnectionCheck());
          },
        );
      },
    );
  }
}
