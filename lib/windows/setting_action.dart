import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/action.dart';
import 'package:streamkeys/windows/widgets/file_picker.dart';

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
  String imagePath = '';
  late TextEditingController nameController;
  late TextEditingController filePathController;

  @override
  void initState() {
    super.initState();
    setState(() {
      imagePath = widget.action.imagePath;
    });
    nameController = TextEditingController(text: widget.action.name);
    filePathController = TextEditingController(text: widget.action.filePath);
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
        title: Text(
          'Action ${widget.action.id}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FilePicker(
                    toolTipMessage: 'Image',
                    onTap: () async {
                      await widget.action.pickImage();
                      setState(() {
                        imagePath = widget.action.imagePath;
                      });
                    },
                    child: _imagePreview(),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter the name...',
                      ),
                      controller: nameController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'File Path',
                            hintText: 'Enter the file path...',
                          ),
                          controller: filePathController,
                        ),
                      ),
                      const SizedBox(width: 5),
                      FilePicker(
                        toolTipMessage: 'Browse',
                        onTap: () async {
                          await widget.action.pickFile();
                          setState(() {
                            filePathController.text = widget.action.filePath;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          ButtonAction clearAction = ButtonAction(
                            id: widget.action.id,
                            name: '',
                            imagePath: '',
                            filePath: '',
                          );
                          setState(() {
                            imagePath = '';
                            nameController.text = '';
                            filePathController.text = '';
                          });
                          await clearAction.update();
                        },
                        child: const Icon(Icons.delete_forever),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          ButtonAction updatedAction = ButtonAction(
                            id: widget.action.id,
                            name: nameController.text,
                            imagePath: imagePath,
                            filePath: filePathController.text,
                          );
                          await updatedAction.update();
                          if (context.mounted) {
                            Navigator.of(context).pop('Updated');
                          }
                        },
                        child: const Text('Update'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _imagePreview() {
    if (imagePath.isNotEmpty) {
      final imageFile = widget.action.getImageFile();
      return Image.file(
        imageFile,
        fit: BoxFit.cover,
      );
    }
    return null;
  }
}
