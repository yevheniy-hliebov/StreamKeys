import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/windows/models/base_action.dart';
import 'package:streamkeys/windows/providers/browse_provider.dart';
import 'package:streamkeys/windows/services/file_execution_service.dart';
import 'package:streamkeys/windows/services/file_picker_service.dart';

class OpenAppAndFile extends BaseAction {
  String filePath;
  final TextEditingController filePathController = TextEditingController();

  static const String actionTypeName = 'Open app/file';

  OpenAppAndFile({this.filePath = ''}) : super(actionType: actionTypeName) {
    filePathController.text = filePath;
  }

  Future<void> pickFile() async {
    final path = await FilePickerService.pickFile();
    if (path != null) {
      filePath = path;
      filePathController.text = path;
    }
  }

  @override
  FutureVoid execute() async {
    try {
      await FileExecutionService.runFile(filePath);
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

  factory OpenAppAndFile.fromJson(Json json) {
    return OpenAppAndFile(
      filePath: json['file_path'] as String,
    );
  }

  @override
  List<Widget> formFields(BuildContext context) {
    final browseProvider = Provider.of<BrowseProvider>(context);
    return [
      TextFormField(
        controller: filePathController,
        decoration: InputDecoration(
            labelText: 'File Path',
            suffixIcon: Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () {
                  browseProvider.openBrowse(pickFile);
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
