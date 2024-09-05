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
                  _selectImage(),
                  const SizedBox(width: 10),
                  Flexible(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF2F2F2F),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFF2F2F2F),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            labelText: 'File Path',
                            hintText: 'Enter the file path...',
                          ),
                          controller: filePathController,
                        ),
                      ),
                      const SizedBox(width: 5),
                      IconButton.outlined(
                        onPressed: () async {
                          await widget.action.pickFile();
                          setState(() {
                            filePathController.text = widget.action.filePath;
                          });
                        },
                        icon: const Icon(Icons.drive_folder_upload_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: () async {
                      ButtonAction updatedAction = ButtonAction(
                        id: widget.action.id,
                        name: nameController.text,
                        imagePath: imagePath,
                        filePath: filePathController.text,
                      );
                      await updatedAction.update();
                      Navigator.of(context).pop('Updated');
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectImage() {
    Widget child;
    if (imagePath.isEmpty) {
      child = const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.drive_folder_upload_outlined),
          Text(
            'Image',
            style: TextStyle(),
          ),
        ],
      );
    } else {
      final imageFile = widget.action.getImageFile();
      child = Image.file(
        imageFile,
        fit: BoxFit.contain,
      );
    }

    return InkWell(
      onTap: () async {
        await widget.action.pickImage();
        setState(() {
          imagePath = widget.action.imagePath;
        });
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const Color(0xFF2F2F2F),
            width: 1,
          ),
        ),
        child: child,
      ),
    );
  }
}
