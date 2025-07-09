import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/buttons/copy_icon_button.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/server/server.dart';

class ServerPortField extends StatelessWidget {
  const ServerPortField({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        SelectableText(Server.port.toString()),
        const SizedBox(width: Spacing.xs),
        CopyIconButton(textToCopy: Server.port.toString()),
      ],
    );
  }
}
