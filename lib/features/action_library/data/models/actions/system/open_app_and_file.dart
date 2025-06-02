import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';
import 'package:streamkeys/utils/file_execution_helper.dart';
import 'package:streamkeys/utils/file_picker_helper.dart';

class OpenAppAndFile extends BaseAction {
  String filePath;
  final TextEditingController filePathController = TextEditingController();

  static const String actionTypeName = 'open_app_or_file';

  OpenAppAndFile({this.filePath = ''})
      : super(
          actionType: actionTypeName,
          dialogTitle: 'Enter file path',
        ) {
    filePathController.text = filePath;
  }

  @override
  String actionLabel = 'Open app/file';

  @override
  String get actionName {
    if (filePath.isEmpty) {
      return actionLabel;
    } else {
      return '$actionLabel ($filePath)';
    }
  }

  Future<void> pickFile() async {
    final path = await FilePickerHelper.pickFile();
    if (path != null) {
      filePath = path;
      filePathController.text = path;
    }
  }

  @override
  FutureVoid execute({dynamic data}) async {
    try {
      await FileExecutionHelper.runFile(filePath);
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Json toJson() {
    return {
      'action_type': actionType,
      'file_path': filePathController.text,
    };
  }

  @override
  void clear() {
    filePath = '';
    filePathController.clear();
  }

  @override
  OpenAppAndFile copy() {
    return OpenAppAndFile(filePath: filePath);
  }

  factory OpenAppAndFile.fromJson(Json json) {
    return OpenAppAndFile(
      filePath: json['file_path'] as String,
    );
  }

  @override
  List<Widget> formFields(BuildContext context) {
    return [
      TextFormField(
        controller: filePathController,
        decoration: InputDecoration(
            labelText: 'File Path',
            suffixIcon: Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                  );

                  try {
                    await pickFile();
                  } finally {
                    if (context.mounted) {
                      Navigator.of(context, rootNavigator: true)
                          .pop();
                    }
                  }
                },
                icon: const Icon(Icons.folder),
              ),
            )),
        onChanged: (value) {
          filePath = value;
        },
      ),
    ];
  }
}
