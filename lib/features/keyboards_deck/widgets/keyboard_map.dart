import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/keyboards_deck/models/keyboard_type.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/function_block_map.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/main_block_map.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/navigation_block_map.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/numpad_block_map.dart';
import 'package:streamkeys/features/keyboards_deck/models/keyboard_map.dart';
import 'package:streamkeys/utils/json_read_and_save.dart';

class KeyboardMap extends StatefulWidget {
  final KeyboardType keyboardType;

  const KeyboardMap({
    super.key,
    required this.keyboardType,
  });

  @override
  State<KeyboardMap> createState() => _KeyboardMapState();
}

class _KeyboardMapState extends State<KeyboardMap> {
  final jsonHelper = JsonHelper.asset('keyboard_map.json');
  final horizontalScroll = ScrollController();
  final verticalScroll = ScrollController();
  final controller = TransformationController(
    Matrix4.identity()..translate(-235.0, -185.0),
  );

  KeyboardMapData? keyboardMap;

  @override
  void initState() {
    super.initState();

    getKeyMapData();

    // controller.addListener(
    //   () {
    //     print(controller.value);
    //   },
    // );
  }

  FutureVoid getKeyMapData() async {
    final json = await jsonHelper.read();
    setState(() {
      keyboardMap = KeyboardMapData.fromJson(json!);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (keyboardMap == null) {
      return const SizedBox();
    } else {
      return InteractiveViewer(
        scaleEnabled: true,
        constrained: false,
        maxScale: 1.2,
        minScale: 1,
        transformationController: controller,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: SColors.of(context).surface,
              border: Border.all(
                color: SColors.of(context).onSurface,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            height: 398,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 25,
              children: [
                if (widget.keyboardType == KeyboardType.full ||
                    widget.keyboardType == KeyboardType.compact) ...[
                  Column(
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FunctionBlockMap(block: keyboardMap!.functionBlock),
                      MainBlockMap(block: keyboardMap!.mainBlock)
                    ],
                  ),
                  NavigationBlockMap(block: keyboardMap!.navigationBlock),
                ],
                if (widget.keyboardType == KeyboardType.full ||
                    widget.keyboardType == KeyboardType.numpad) ...[
                  NumpadBlockMap(block: keyboardMap!.numpad),
                ],
              ],
            ),
          ),
        ),
      );
    }
  }
}
