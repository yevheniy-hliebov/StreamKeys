import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/common/widgets/forms/websocket_settings_form.dart';
import 'package:streamkeys/desktop/features/obs/data/models/obs_connection_data.dart';

class ObsSettingsForm extends StatelessWidget {
  final ConnectionStatus status;
  final ObsConnectionData? initialData;
  final Future<void> Function(ObsConnectionData updatedData)? onUpdated;
  final void Function(ObsConnectionData data)? onConnect;
  final void Function(ObsConnectionData data)? onReconnect;
  final void Function()? onDisconnect;

  const ObsSettingsForm({
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
    return WebSocketSettingsForm<ObsConnectionData>(
      title: 'OBS Settings',
      status: status,
      initialData: initialData,
      onUpdated: onUpdated,
      onConnect: onConnect,
      onReconnect: onReconnect,
      onDisconnect: onDisconnect,
      fromInput:
          ({
            required String ip,
            required String port,
            required String? password,
            required bool autoReconnect,
          }) {
            return ObsConnectionData(
              ip: ip,
              port: port,
              password: password ?? '',
              autoReconnect: autoReconnect,
            );
          },
    );
  }
}
