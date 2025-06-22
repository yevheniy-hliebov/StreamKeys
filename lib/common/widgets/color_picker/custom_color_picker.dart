import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/utils/color_helper.dart';

export 'package:streamkeys/common/widgets/color_picker/color_picker_controls.dart';
export 'package:streamkeys/common/widgets/color_picker/color_and_input_fields.dart';
export 'package:streamkeys/common/widgets/color_picker/color_sliders.dart';
export 'package:streamkeys/common/widgets/color_picker/color_indicator.dart';
export 'package:streamkeys/common/widgets/color_picker/hex_input_field.dart';
export 'package:streamkeys/common/widgets/color_picker/opacity_input_field.dart';
export 'package:streamkeys/common/widgets/color_picker/color_picker_area_widget.dart';
export 'package:streamkeys/common/widgets/color_picker/color_picker_dialog.dart';

class ColorPickerController extends ChangeNotifier {
  late Color pickerColor;
  late TextEditingController hexTextController;
  late TextEditingController opacityPercentController;

  ColorPickerController(Color initialColor) {
    pickerColor = initialColor;

    hexTextController = TextEditingController(
      text: ColorHelper.getHexString(pickerColor),
    );
    opacityPercentController = TextEditingController(
      text: ColorHelper.getOpacityPercentageString(pickerColor),
    );
  }

  HSVColor get hsvColor => HSVColor.fromColor(pickerColor);

  void onColorChanged(dynamic color) {
    if (color is Color) {
      pickerColor = color;
    } else if (color is HSVColor) {
      pickerColor = color.toColor();
    } else {
      throw ArgumentError('Invalid color type: ${color.runtimeType}');
    }

    final hex = ColorHelper.getHexString(pickerColor);
    final opacity = ColorHelper.getOpacityPercentageString(pickerColor);

    hexTextController.value = TextEditingValue(
      text: hex,
      selection: TextSelection.collapsed(offset: hex.length),
    );

    opacityPercentController.value = TextEditingValue(
      text: opacity,
      selection: TextSelection.collapsed(offset: opacity.length),
    );

    notifyListeners();
  }

  void onHexChanged(String hex) {
    final color = ColorHelper.hexToColor(hex);
    pickerColor = color ?? Colors.transparent;
    opacityPercentController.text =
        ColorHelper.getOpacityPercentageString(pickerColor);

    notifyListeners();
  }

  void onOpacityChanged(String opacityPercentString) {
    final color = ColorHelper.setOpacity(
      pickerColor,
      double.parse(opacityPercentString),
    );
    pickerColor = color;
    hexTextController.text = ColorHelper.getHexString(pickerColor);

    notifyListeners();
  }

  @override
  void dispose() {
    hexTextController.dispose();
    opacityPercentController.dispose();
    super.dispose();
  }
}