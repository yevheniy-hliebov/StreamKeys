import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';

class KeyButtonContainer extends StatelessWidget {
  final bool isSelected;
  final double size;
  final Color? backgroundColor;
  final Widget? child;

  const KeyButtonContainer({
    super.key,
    this.isSelected = false,
    this.size = 50,
    this.backgroundColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.of(context).background,
        border: Border.all(
          color: isSelected
              ? AppColors.of(context).primary
              : AppColors.of(context).outline,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.5),
        child: child,
      ),
    );
  }
}
