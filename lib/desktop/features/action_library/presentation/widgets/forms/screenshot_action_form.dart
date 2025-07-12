import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streamkeys/common/widgets/buttons/small_icon_button.dart';
import 'package:streamkeys/common/widgets/buttons/square_icon_button.dart';
import 'package:streamkeys/common/widgets/forms/field_label.dart';
import 'package:streamkeys/common/widgets/tiles/checkbox_tile.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/screenshot_action.dart';
import 'package:streamkeys/desktop/utils/file_manager.dart';

class ScreenshotActionForm extends StatefulWidget {
  final ScreenshotAction initialAction;
  final void Function(ScreenshotAction newValue)? onUpdated;
  final FileManager fileManager;

  const ScreenshotActionForm({
    super.key,
    required this.initialAction,
    this.onUpdated,
    required this.fileManager,
  });

  @override
  State<ScreenshotActionForm> createState() => _ScreenshotActionFormState();
}

class _ScreenshotActionFormState extends State<ScreenshotActionForm> {
  late TextEditingController recordingPathController;
  late TextEditingController delayController;
  late bool playSound;

  @override
  void initState() {
    super.initState();
    recordingPathController = TextEditingController(
      text: widget.initialAction.recordingPath,
    );
    delayController = TextEditingController(
      text: widget.initialAction.delay.toSecondsString(),
    );
    playSound = widget.initialAction.playSound;
  }

  void changeDelay(int delta) {
    final seconds = double.parse(delayController.text);
    final newValue = seconds + delta;
    if (newValue > 0) {
      delayController.text = (seconds + delta).toString();
    }
    _onUpdate();
  }

  @override
  void dispose() {
    delayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Spacing.xs,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('Delay in seconds'),
        TextFormField(
          controller: recordingPathController,
          onChanged: (value) => _onUpdate(),
          decoration: InputDecoration(
            suffixIcon: SmallIconButton(
              onPressed: _pickDirectory,
              icon: Icons.folder_open,
            ),
          ),
        ),
        const FieldLabel('Delay in seconds'),
        Row(
          spacing: Spacing.xs,
          children: [
            SquareIconButton(
              icon: Icons.remove,
              onPressed: () => changeDelay(-1),
            ),
            SizedBox(
              width: 50,
              height: 40,
              child: TextFormField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(Spacing.sm),
                ),
                controller: delayController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
                ],
                onChanged: (value) => _onUpdate(),
              ),
            ),
            SquareIconButton(
              icon: Icons.add,
              onPressed: () => changeDelay(1),
            ),
          ],
        ),
        CheckboxTile(
          label: 'Play countdown and shutter sounds',
          value: playSound,
          onChanged: (value) {
            setState(() => playSound = value);
            _onUpdate();
          },
        ),
      ],
    );
  }

  void _onUpdate() {
    final seconds = double.parse(delayController.text);
    widget.onUpdated?.call(
      ScreenshotAction(
        recordingPath: recordingPathController.text,
        delay: DurationExtensions.getDelayFromDouble(seconds),
        playSound: playSound,
      ),
    );
  }

  Future<void> _pickDirectory() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final directoryPath = await widget.fileManager.pickDirectory();
      if (directoryPath != null) {
        recordingPathController.text = directoryPath;
        _onUpdate();
      }
    } finally {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }
}
