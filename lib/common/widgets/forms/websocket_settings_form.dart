import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/base_connection_data.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/common/widgets/forms/connection_controls.dart';
import 'package:streamkeys/common/widgets/forms/connection_title.dart';
import 'package:streamkeys/common/widgets/forms/field_label.dart';
import 'package:streamkeys/common/widgets/tiles/checkbox_tile.dart';
import 'package:streamkeys/core/constants/spacing.dart';

class WebSocketSettingsForm<T extends BaseConnectionData> extends StatefulWidget {
  final ConnectionStatus status;
  final T? initialData;
  final Future<void> Function(T updatedData)? onUpdated;
  final void Function(T data)? onConnect;
  final void Function(T data)? onReconnect;
  final void Function()? onDisconnect;
  final String title;
  final bool passwordOptional;
  final T Function({
    required String ip,
    required String port,
    required String? password,
    required bool autoReconnect,
  }) fromInput;

  const WebSocketSettingsForm({
    super.key,
    required this.title,
    required this.fromInput,
    this.status = ConnectionStatus.notConnected,
    this.initialData,
    this.onUpdated,
    this.onConnect,
    this.onReconnect,
    this.onDisconnect,
    this.passwordOptional = false,
  });

  @override
  State<WebSocketSettingsForm<T>> createState() => _WebSocketSettingsFormState<T>();
}

class _WebSocketSettingsFormState<T extends BaseConnectionData>
    extends State<WebSocketSettingsForm<T>> {
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
        TextEditingController(text: widget.initialData?.password ?? '');
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
    final updated = widget.fromInput(
      ip: _ipController.text,
      port: _portController.text,
      password: _passwordController.text,
      autoReconnect: _autoReconnect,
    );

    await widget.onUpdated?.call(updated);
    if (widget.status == ConnectionStatus.connected) {
      widget.onReconnect?.call(updated);
    } else {
      widget.onConnect?.call(updated);
    }
  }

  void _disconnect() {
    widget.onDisconnect?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        spacing: Spacing.xs,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConnectionTitle(
            title: widget.title,
            status: widget.status,
          ),
          const FieldLabel('Server IP'),
          TextFormField(controller: _ipController),
          const FieldLabel('Server port'),
          TextFormField(
            controller: _portController,
            keyboardType: TextInputType.number,
          ),
          FieldLabel('Password${widget.passwordOptional ? ' (optinal)' : ''}'),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
          ),
          CheckboxTile(
            value: _autoReconnect,
            onChanged: (v) => setState(() => _autoReconnect = v),
            label: 'Auto Reconnect',
          ),
          ConnectionControls(
            status: widget.status,
            onConnect: _connect,
            onDisconnect: _disconnect,
          ),
        ],
      ),
    );
  }
}
