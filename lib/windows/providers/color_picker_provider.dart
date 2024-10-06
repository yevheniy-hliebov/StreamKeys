import 'package:flutter/material.dart';
import 'package:streamkeys/windows/utils/color_helper.dart';

class ColorPickerProvider extends ChangeNotifier {
  late Color pickerColor;
  late TextEditingController hexTextController;
  late TextEditingController opacityPercentController;

  ColorPickerProvider(Color startColor) {
    pickerColor = startColor;
    hexTextController = TextEditingController(
      text: ColorHelper.getHexString(pickerColor),
    );
    opacityPercentController = TextEditingController(
      text: ColorHelper.getOpacityPercentageString(pickerColor),
    );
    notifyListeners();
  }

  HSVColor get hsvColor => HSVColor.fromColor(pickerColor);

  void changeColor(dynamic color) {
    if (color is Color) {
      pickerColor = color;
    } else if (color is HSVColor) {
      pickerColor = color.toColor();
    } else {
      throw ArgumentError('Invalid color type: ${color.runtimeType}');
    }

    hexTextController.text = ColorHelper.getHexString(pickerColor);
    opacityPercentController.text =
        ColorHelper.getOpacityPercentageString(pickerColor);
    notifyListeners();
  }

  void changeInputs(Color color) {
    hexTextController.text = ColorHelper.getHexString(pickerColor);
    opacityPercentController.text =
        ColorHelper.getOpacityPercentageString(pickerColor);
  }

  void changeColorByFormField(String hex) {
    final color = ColorHelper.hexToColor(hex);
    pickerColor = color;
    opacityPercentController.text =
        ColorHelper.getOpacityPercentageString(pickerColor);
    notifyListeners();
  }

  void changeOpacityByFormField(String opacityPercentString) {
    final color = ColorHelper.setOpacity(
      pickerColor,
      double.parse(opacityPercentString),
    );
    pickerColor = color;
    hexTextController.text = ColorHelper.getHexString(pickerColor);
    notifyListeners();
  }
}
