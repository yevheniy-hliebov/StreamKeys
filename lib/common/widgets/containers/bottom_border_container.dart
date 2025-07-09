import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';

class BottomBorderContainer extends StatelessWidget {
  final Widget child;

  const BottomBorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _boxDecoration(context),
      child: child,
    );
  }

  BoxDecoration _boxDecoration(BuildContext context) {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 4,
          color: AppColors.of(context).outlineVariant,
        ),
      ),
    );
  }
}
