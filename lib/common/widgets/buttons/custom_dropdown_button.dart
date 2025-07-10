import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/spacing.dart';

class CustomDropdownButton extends StatelessWidget {
  final BoxConstraints? constraints;
  final int? index;
  final int itemCount;
  final Widget Function(int index) itemBuilder;
  final void Function(int? newIndex)? onChanged;

  const CustomDropdownButton({
    super.key,
    this.constraints,
    this.index,
    required this.itemCount,
    required this.itemBuilder,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      constraints: constraints ??
          const BoxConstraints(
            maxWidth: 200,
            minWidth: 200,
          ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<int>(
          isExpanded: true,
          value: index,
          items: List.generate(itemCount, (index) {
            return DropdownMenuItem(
              value: index,
              child: itemBuilder(index),
            );
          }),
          onChanged: onChanged,
          buttonStyleData: _getButtonStyle(context),
        ),
      ),
    );
  }

  ButtonStyleData _getButtonStyle(BuildContext context) {
    return ButtonStyleData(
      height: 50,
      width: 160,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: AppColors.of(context).outline,
        ),
        color: AppColors.of(context).surface,
      ),
      elevation: 2,
    );
  }
}
