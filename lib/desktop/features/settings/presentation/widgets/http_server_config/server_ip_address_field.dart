import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/buttons/copy_icon_button.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/utils/helper_functions.dart';

class ServerIPAddressField extends StatelessWidget {
  const ServerIPAddressField({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: HelperFunctions.getLocalIPv4(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading IP...');
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final ip = snapshot.data ?? 'No IP found';
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              SelectableText(ip),
              const SizedBox(width: Spacing.xs),
              CopyIconButton(textToCopy: ip),
            ],
          );
        }
      },
    );
  }
}
