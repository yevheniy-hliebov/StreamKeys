import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/field_label.dart';
import 'package:streamkeys/common/widgets/page_tab.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/settings/presentation/widgets/http_server_config/server_ip_address_field.dart';
import 'package:streamkeys/desktop/features/settings/presentation/widgets/http_server_config/server_password_field.dart';
import 'package:streamkeys/desktop/features/settings/presentation/widgets/http_server_config/server_port_field.dart';

class HttpServerConfigScreen extends StatelessWidget with PageTab {
  const HttpServerConfigScreen({super.key});

  @override
  Widget get pageView => this;

  @override
  String get label => 'HTTP Server';

  @override
  Widget get icon => const Icon(Icons.public);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(Spacing.md),
        constraints: const BoxConstraints(maxWidth: 400),
        child: const Column(
          spacing: Spacing.xs,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ConfigRow(label: 'Server IP:', child: ServerIPAddressField()),
            _ConfigRow(label: 'Port:', child: ServerPortField()),
            _ConfigRow(label: 'Password:', child: ServerPasswordField()),
          ],
        ),
      ),
    );
  }
}

class _ConfigRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _ConfigRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Spacing.xs,
      children: [
        FieldLabel(label),
        Expanded(child: child),
      ],
    );
  }
}
