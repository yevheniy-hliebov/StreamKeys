import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/windows/widgets/setting_button_frame.dart';
import 'package:streamkeys/windows/widgets/touch_button_map.dart';

class TouchMapSetting extends StatelessWidget {
  const TouchMapSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const TouchButtonMap(),
          Divider(
            thickness: 4,
            color: SColors.of(context).outlineVariant,
            height: 0,
          ),
          const SettingButtonFrame(),
        ],
      ),
    );
  }
}
