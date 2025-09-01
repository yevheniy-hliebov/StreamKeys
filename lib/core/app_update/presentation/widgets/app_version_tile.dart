import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/version.dart';

class AppVersionTile extends StatelessWidget {
  final void Function()? onTap;

  const AppVersionTile({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: const Text('Check For Update'),
      trailing: Text(
        AppVersion.appVersion,
        style: TextTheme.of(context).bodyMedium?.copyWith(
          color: AppColors.of(context).onSurface,
        ),
      ),
    );
  }
}
