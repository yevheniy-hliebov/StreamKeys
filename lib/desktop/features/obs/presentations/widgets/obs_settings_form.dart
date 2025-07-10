import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/common/widgets/forms/field_label.dart';
import 'package:streamkeys/common/widgets/tiles/checkbox_tile.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/obs/data/models/obs_connection_data.dart';
import 'package:streamkeys/desktop/features/obs/presentations/widgets/obs_connection_controls.dart';
import 'package:streamkeys/desktop/features/obs/presentations/widgets/obs_connection_title.dart';

class ObsSettingsForm extends StatefulWidget {
  final ConnectionStatus status;
  final ObsConnectionData? initialData;
  final Future<void> Function(ObsConnectionData updatedData)? onUpdated;
  final void Function()? onConnect;
  final void Function()? onDisconnect;

  const ObsSettingsForm({
    super.key,
    this.status = ConnectionStatus.notConnected,
    this.initialData,
    this.onUpdated,
    this.onConnect,
    this.onDisconnect,
  });

  @override
  State<ObsSettingsForm> createState() => _ObsSettingsFormState();
}

class _ObsSettingsFormState extends State<ObsSettingsForm> {
  late final TextEditingController _ipController;
  late final TextEditingController _portController;
  late final TextEditingController _passwordController;
  late bool _autoReconnect;

  @override
  void initState() {
    super.initState();
    _ipController = TextEditingController(text: widget.initialData?.ip);
    _portController = TextEditingController(text: widget.initialData?.port);
    _passwordController =
        TextEditingController(text: widget.initialData?.password);
    _autoReconnect = widget.initialData?.autoReconnect ?? false;
  }

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _connect() async {
    await widget.onUpdated?.call(
      ObsConnectionData(
        ip: _ipController.text,
        port: _portController.text,
        password: _passwordController.text,
        autoReconnect: _autoReconnect,
      ),
    );
    widget.onConnect?.call();
  }

  void _disconnect() {
    widget.onDisconnect?.call();
  }

  void _onAutoReconnectChanged(bool? value) {
    if (value == null) return;
    setState(() {
      _autoReconnect = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        spacing: Spacing.xs,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ObsConnectionTitle(status: widget.status),
          const FieldLabel('Server IP'),
          TextFormField(controller: _ipController),
          const FieldLabel('Server port'),
          TextFormField(
            controller: _portController,
            keyboardType: TextInputType.number,
          ),
          const FieldLabel('Password'),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
          ),
          CheckboxTile(
            value: _autoReconnect,
            onChanged: _onAutoReconnectChanged,
            label: 'Auto Reconnect',
          ),
          ObsConnectionControls(
            status: widget.status,
            onConnect: _connect,
            onDisconnect: _disconnect,
          ),
        ],
      ),
    );
  }
}
