import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streamkeys/common/widgets/tabs/page_tab.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/obs/bloc/connection/obs_connection_bloc.dart';
import 'package:streamkeys/desktop/features/obs/bloc/settings/obs_settings_bloc.dart';
import 'package:streamkeys/desktop/features/obs/presentations/widgets/obs_settings_form.dart';
import 'package:streamkeys/service_locator.dart';

class ObsSettingsScreen extends StatelessWidget with PageTab {
  const ObsSettingsScreen({super.key});

  @override
  Widget get pageView => this;

  @override
  String get label => 'OBS Studio';

  @override
  Widget get icon {
    return SizedBox(
      width: 18,
      height: 18,
      child: SvgPicture.asset(
        'assets/action_icons/obs.svg',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            margin: const EdgeInsets.symmetric(vertical: Spacing.xs),
            child: BlocBuilder<ObsConnectionBloc, ObsConnectionState>(
                builder: (context, connectionState) {
              return BlocProvider(
                create: (_) => ObsSettingsBloc(
                  ObsSettingsRepository(sl<ObsSecureStorage>()),
                )..add(ObsSettingsLoad()),
                child: BlocBuilder<ObsSettingsBloc, ObsSettingsState>(
                  builder: (context, state) {
                    if (state is ObsSettingsLoaded) {
                      return ObsSettingsForm(
                        initialData: state.data,
                        onUpdated: (updatedData) async {
                          context
                              .read<ObsSettingsBloc>()
                              .add(ObsSettingsSave(updatedData));
                        },
                        onConnect: (data) {
                          sl<ObsService>().connect(data: data);
                        },
                        onReconnect: (data) {
                          sl<ObsService>().reconnect(data: data, force: true);
                        },
                        onDisconnect: () {
                          sl<ObsService>().disconnect();
                        },
                        status: connectionState.status,
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
