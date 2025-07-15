import 'package:flutter/material.dart';
import 'package:streamkeys/mobile/features/api_connection/data/models/api_connection_data.dart';
import 'package:streamkeys/mobile/features/api_connection/presentation/widgets/api_connection_form.dart';

class ApiConnectionDialog extends StatelessWidget {
  final ApiConnectionData initialData;

  const ApiConnectionDialog({
    super.key,
    required this.initialData,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('HTTP Server'),
      content: ApiConnectionForm(
        initialData: initialData,
        onUpdated: (data) {
          Navigator.of(context).pop<ApiConnectionData>(data);
        },
      ),
    );
  }

  static Future<ApiConnectionData?> showConfigDialog(
    BuildContext context, {
    required ApiConnectionData initialData,
  }) async {
    return await showDialog<ApiConnectionData>(
      context: context,
      builder: (context) => ApiConnectionDialog(initialData: initialData),
    );
  }
}
