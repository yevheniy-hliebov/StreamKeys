import 'package:flutter/widgets.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/spacing.dart';

class StatusOverlay extends StatelessWidget {
  final List<Widget> children;

  const StatusOverlay({
    super.key,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: _boxDecoration(context),
      child: Row(
        spacing: Spacing.xs,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }

  BoxDecoration _boxDecoration(BuildContext context) {
    return BoxDecoration(
      color: AppColors.of(context).surface,
      border: Border(
        top: BorderSide(
          width: 4,
          color: AppColors.of(context).outlineVariant,
        ),
      ),
    );
  }
}
