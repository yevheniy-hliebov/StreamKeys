import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/features/obs/bloc/obs_connection_bloc.dart';
import 'package:streamkeys/features/obs/data/models/obs_connection_data.dart';
import 'package:streamkeys/features/obs/widgets/obs_connection_controls.dart';
import 'package:streamkeys/features/obs/widgets/obs_connection_title.dart';

class ObsConnectionForm extends StatefulWidget {
  const ObsConnectionForm({super.key});

  @override
  State<ObsConnectionForm> createState() => _ObsConnectionFormState();
}

class _ObsConnectionFormState extends State<ObsConnectionForm> {
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _autoReconnect = false;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<ObsConnectionBloc>();
    _autoReconnect = bloc.autoReconnect;
  }

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _connect() {
    final ip = _ipController.text.trim();
    final port = _portController.text.trim();
    final password = _passwordController.text.trim();

    if (ip.isEmpty || port.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('IP and port must be filled in')),
      );
      return;
    }

    final connectionData = ObsConnectionData(
      ip: ip,
      port: port,
      password: password,
    );

    final bloc = context.read<ObsConnectionBloc>();

    final currentState = bloc.state;
    if (currentState is ObsConnectionConnected) {
      bloc.add(ObsConnectionReconnectEvent(connectionData));
    } else {
      bloc.add(ObsConnectionConnectEvent(connectionData));
    }
  }

  void _disconnect() {
    final bloc = context.read<ObsConnectionBloc>();
    bloc.add(ObsConnectionDisconnectEvent());
  }

  void _onAutoReconnectChanged(bool? value) {
    if (value == null) return;
    setState(() {
      _autoReconnect = value;
    });
    final bloc = context.read<ObsConnectionBloc>();
    bloc.add(ObsConnectionToggleAutoReconnectEvent(value));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObsConnectionBloc, ObsConnectionState>(
      builder: (context, state) {
        if (state is ObsConnectionError) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          });
        }

        if (state.data != null) {
          _ipController.text = state.data!.ip;
          _portController.text = state.data!.port;
          _passwordController.text = state.data!.password;
        }

        if (state is ObsConnectionInitial || state is ObsConnectionConnected) {
          final autoReconnect = (state as dynamic).autoReconnect as bool?;
          if (autoReconnect != null && autoReconnect != _autoReconnect) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _autoReconnect = autoReconnect;
              });
            });
          }
        }

        return Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const ObsConnectionTitle(),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ipController,
                decoration: const InputDecoration(
                  labelText: 'Server IP',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _portController,
                decoration: const InputDecoration(
                  labelText: 'Server port',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _autoReconnect,
                    onChanged: _onAutoReconnectChanged,
                  ),
                  const Text('Auto Reconnect'),
                ],
              ),
              const SizedBox(height: 24),
              ObsConnectionControls(
                onConnect: _connect,
                onDisconnect: _disconnect,
              ),
            ],
          ),
        );
      },
    );
  }
}
