import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/common/widgets/forms/websocket_settings_form.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/models/streamerbot_connection_data.dart';

class StreamBotSettingsForm extends StatelessWidget {
  final ConnectionStatus status;
  final StreamerBotConnectionData? initialData;
  final Future<void> Function(StreamerBotConnectionData updatedData)? onUpdated;
  final void Function(StreamerBotConnectionData data)? onConnect;
  final void Function(StreamerBotConnectionData data)? onReconnect;
  final void Function()? onDisconnect;

  const StreamBotSettingsForm({
    super.key,
    this.status = ConnectionStatus.notConnected,
    this.initialData,
    this.onUpdated,
    this.onConnect,
    this.onReconnect,
    this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return WebSocketSettingsForm<StreamerBotConnectionData>(
      title: 'Streamer.bot',
      status: status,
      initialData: initialData,
      onUpdated: onUpdated,
      onConnect: onConnect,
      onReconnect: onReconnect,
      onDisconnect: onDisconnect,
      fromInput: ({
        required String ip,
        required String port,
        required String? password,
        required bool autoReconnect,
      }) {
        return StreamerBotConnectionData(
          ip: ip,
          port: port,
          password: password ?? '',
          autoReconnect: autoReconnect,
        );
      },
    );
  }
}
