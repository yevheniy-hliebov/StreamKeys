import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/buttons/small_icon_button.dart';
import 'package:streamkeys/common/widgets/forms/field_label.dart';
import 'package:streamkeys/common/widgets/tiles/checkbox_tile.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/system/launch_file_or_app_action.dart';
import 'package:streamkeys/desktop/utils/helper_functions.dart';

class LaunchFileOrAppActionForm extends StatefulWidget {
  final LaunchFileOrAppAction initialAction;
  final void Function(LaunchFileOrAppAction updatedAction)? onUpdate;

  const LaunchFileOrAppActionForm({
    super.key,
    required this.initialAction,
    required this.onUpdate,
  });

  @override
  State<LaunchFileOrAppActionForm> createState() =>
      _LaunchFileOrAppActionFormState();
}

class _LaunchFileOrAppActionFormState extends State<LaunchFileOrAppActionForm> {
  late TextEditingController controller;
  late bool launchAsAdmin;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialAction.filePath);
    launchAsAdmin = widget.initialAction.launchAsAdmin;
  }

  Future<void> _pickImage() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final filePath = await HelperFunctions.pickFile(type: FileType.any);
      if (filePath != null) {
        controller.text = filePath;
        _onUpdate(filePath: filePath);
      }
    } finally {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  void _onUpdate({String? filePath, bool? asAdmin}) {
    final updated = LaunchFileOrAppAction(
      id: widget.initialAction.id,
      filePath: filePath ?? controller.text,
      launchAsAdmin: asAdmin ?? launchAsAdmin,
    );
    widget.onUpdate?.call(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Spacing.xs,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const FieldLabel('File path'),
        TextFormField(
          controller: controller,
          onChanged: (value) => _onUpdate(filePath: value),
          decoration: InputDecoration(
            suffixIcon: SmallIconButton(
              onPressed: _pickImage,
              icon: Icons.folder_open,
            ),
          ),
        ),
        CheckboxTile(
          label: 'run as administrator',
          value: launchAsAdmin,
          onChanged: (value) {
            setState(() {
              launchAsAdmin = value;
            });
            _onUpdate(asAdmin: value);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
