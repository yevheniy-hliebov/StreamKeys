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
      title: Text('Check For Update', style: TextTheme.of(context).labelSmall),
      trailing: Text(
        AppVersion.appVersion,
        style: TextTheme.of(context).labelSmall?.copyWith(
          color: AppColors.of(context).onSurface,
        ),
      ),
    );
  }
}
