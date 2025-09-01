import 'package:flutter/material.dart';
import 'package:streamkeys/mobile/features/api_connection/data/models/api_connection_data.dart';
import 'package:streamkeys/mobile/features/api_connection/presentation/widgets/api_connection_dialog.dart';

class ApiConnectionTile extends StatelessWidget {
  final ApiConnectionData? initialData;
  final void Function(ApiConnectionData data)? onUpdated;

  const ApiConnectionTile({
    super.key,
    required this.initialData,
    this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('HTTP Server connection'),
      onTap: () async {
        final result = await ApiConnectionDialog.showConfigDialog(
          context,
          initialData: initialData,
        );
        if (result == null) return;
        onUpdated?.call(result);
      },
    );
  }
}
