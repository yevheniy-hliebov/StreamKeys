import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/key_labels.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keybutton/key_positioned_label.dart';

class KeyButtonLabels extends StatelessWidget {
  final String keyName;
  final KeyLabels keyLabels;

  const KeyButtonLabels({
    super.key,
    this.keyName = '',
    required this.keyLabels,
  });

  static Map<String, IconData> iconButons = <String, IconData>{
    'up': Icons.arrow_upward,
    'down': Icons.arrow_downward,
    'left': Icons.arrow_back,
    'right': Icons.arrow_forward,
    'backspace': Icons.arrow_back,
  };

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        KeyPositionedLabel(
          position: LabelPosition.topLeft,
          text: keyLabels.topLeft,
        ),
        KeyPositionedLabel(
          position: LabelPosition.topRight,
          text: keyLabels.topRight,
        ),
        KeyPositionedLabel(
          position: LabelPosition.center,
          text: keyLabels.center,
          iconData: iconButons[keyName],
          fontSize: 9,
        ),
        KeyPositionedLabel(
          position: LabelPosition.bottomLeft,
          text: keyLabels.bottomLeft,
        ),
        KeyPositionedLabel(
          position: LabelPosition.bottomRight,
          text: keyLabels.bottomRight,
        ),
      ],
    );
  }
}
