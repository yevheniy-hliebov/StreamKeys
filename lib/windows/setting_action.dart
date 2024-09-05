import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/action.dart';

class SettingActionPage extends StatefulWidget {
  final ButtonAction action;

  const SettingActionPage({
    super.key,
    required this.action,
  });

  @override
  State<SettingActionPage> createState() => _SettingActionPageState();
}

class _SettingActionPageState extends State<SettingActionPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController imagePathController = TextEditingController();
  TextEditingController filePathController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.action.name;
    imagePathController.text = widget.action.imagePath;
    filePathController.text = widget.action.filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop('Not updated');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Form(
              child: Column(
                children: [
                  Text('id: ${widget.action.id}'),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter the name...',
                    ),
                    controller: nameController,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Image Path',
                      hintText: 'Enter the image path...',
                    ),
                    controller: imagePathController,
                  ),
                  IconButton.filled(
                    onPressed: () {
                      widget.action.pickImage().then(
                        (_) {
                          imagePathController.text = widget.action.imagePath;
                        },
                      );
                    },
                    icon: const Icon(Icons.drive_folder_upload_outlined),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'File Path',
                      hintText: 'Enter the file path...',
                    ),
                    controller: filePathController,
                  ),
                  IconButton.filled(
                    onPressed: () {
                      widget.action.pickFile().then(
                        (_) {
                          filePathController.text = widget.action.filePath;
                        },
                      );
                    },
                    icon: const Icon(Icons.drive_folder_upload_outlined),
                  ),
                  FilledButton(
                    onPressed: () {
                      ButtonAction action = ButtonAction(
                        id: widget.action.id,
                        name: nameController.text,
                        imagePath: imagePathController.text,
                        filePath: filePathController.text,
                      );
                      action.update().then((_) {
                        Navigator.of(context).pop('Updated');
                      });
                    },
                    child: const Text('Update'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
