import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/widgets/tabs/page_tab.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/streamerbot/bloc/connection/streamerbot_connection_bloc.dart';
import 'package:streamkeys/desktop/features/streamerbot/bloc/settings/streamerbot_settings_bloc.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/repositories/streamerbot_repository.dart';
import 'package:streamkeys/desktop/features/streamerbot/presentation/widgets/streamerbot_settings_form.dart';
import 'package:streamkeys/service_locator.dart';

class StreamerBotSettingsScreen extends StatelessWidget with PageTab {
  const StreamerBotSettingsScreen({super.key});

  @override
  Widget get pageView => this;

  @override
  String get label => 'Streamer.bot';

  @override
  Widget get icon {
    return SizedBox(
      width: 18,
      height: 18,
      child: Image.asset(
        'assets/action_icons/streamerbot.png',
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
            child: BlocBuilder<StreamerBotConnectionBloc,
                StreamerBotConnectionState>(
              builder: (context, connectionState) {
                return BlocProvider(
                  create: (_) => StreamerBotSettingsBloc(
                    StreamerBotSettingsRepository(
                      sl<StreamerBotSecureStorage>(),
                    ),
                  )..add(StreamerBotSettingsLoad()),
                  child: BlocBuilder<StreamerBotSettingsBloc,
                      StreamerBotSettingsState>(
                    builder: (context, state) {
                      if (state is StreamerBotSettingsLoaded) {
                        return StreamBotSettingsForm(
                          initialData: state.data,
                          onUpdated: (updatedData) async {
                            context
                                .read<StreamerBotSettingsBloc>()
                                .add(StreamerBotSettingsSave(updatedData));
                          },
                          onConnect: (data) {
                            sl<StreamerBotService>().connect(data: data);
                          },
                          onReconnect: (data) {
                            sl<StreamerBotService>().reconnect(data: data, force: true);
                          },
                          onDisconnect: () {
                            sl<StreamerBotService>().disconnect();
                          },
                          status: connectionState.status,
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
