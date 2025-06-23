import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';

class KeyButtonContainer extends StatelessWidget {
  final bool isSelected;
  final double width;
  final double height;
  final Color? backgroundColor;
  final Widget? child;

  const KeyButtonContainer({
    super.key,
    this.isSelected = false,
    this.width = 50,
    this.height = 50,
    this.backgroundColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
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
