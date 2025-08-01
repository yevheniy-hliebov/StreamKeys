import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/color_picker/custom_color_picker.dart';
import 'package:streamkeys/core/constants/colors.dart';

class ColorIndicator extends StatelessWidget {
  final ColorPickerController controller;
  final bool withButtonToOpenPickerDialog;
  final double width;
  final double height;

  const ColorIndicator({
    super.key,
    required this.controller,
    this.withButtonToOpenPickerDialog = false,
    this.width = 30,
    this.height = 30,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.of(context).surface,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 1,
              color: AppColors.of(context).onSurface,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: _buildIndicatorWithButton(context),
          ),
        );
      },
    );
  }

  Widget get _indicator {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: controller.pickerColor),
    );
  }

  Widget _buildIndicatorWithButton(BuildContext context) {
    if (!withButtonToOpenPickerDialog) return _indicator;
    return Row(
      children: [
        _indicator,
        VerticalDivider(
          width: 1,
          thickness: 1,
          color: AppColors.of(context).onSurface,
        ),
        SizedBox(
          width: width,
          height: height,
          child: InkWell(
            onTap: () => ColorPickerDialog.showColorPickerDialog(
              context,
              color: controller.pickerColor,
              onSelectColor: controller.onColorChanged,
            ),
            child: Center(child: Icon(Icons.colorize, size: width / 2)),
          ),
        ),
      ],
    );
  }
}
