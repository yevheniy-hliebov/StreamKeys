import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/forms/field_label.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/mobile/features/api_connection/data/models/api_connection_data.dart';

class ApiConnectionForm extends StatefulWidget {
  final ApiConnectionData initialData;
  final void Function(ApiConnectionData data)? onUpdated;

  const ApiConnectionForm({
    super.key,
    required this.initialData,
    this.onUpdated,
  });

  @override
  State<ApiConnectionForm> createState() => _ApiConnectionFormState();
}

class _ApiConnectionFormState extends State<ApiConnectionForm> {
  late final TextEditingController _ipController;
  late final TextEditingController _portController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _ipController = TextEditingController(text: widget.initialData.ip);
    _portController = TextEditingController(text: widget.initialData.port);
    _passwordController = TextEditingController(
      text: widget.initialData.password,
    );
    super.initState();
  }

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _save() async {
    final updated = ApiConnectionData(
      ip: _ipController.text,
      port: _portController.text,
      password: _passwordController.text,
    );

    widget.onUpdated?.call(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        spacing: Spacing.xs,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const FieldLabel('IP address'),
          TextFormField(controller: _ipController),
          const FieldLabel('Port'),
          TextFormField(
            controller: _portController,
            keyboardType: TextInputType.number,
          ),
          const FieldLabel('Password'),
          TextFormField(controller: _passwordController, obscureText: true),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: _save,
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.all(Spacing.xs)),
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
