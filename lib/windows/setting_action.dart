import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/theme.dart';
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
    final isLight = STheme.isLight(context);

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
                  Tooltip(
                    message:
                        widget.action.imagePath != '' ? 'Change image' : '',
                    child: _selectImage(),
                  ),
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
                      Tooltip(
                        message: 'Browse',
                        child: InkWell(
                          onTap: () async {
                            await widget.action.pickFile();
                            setState(() {
                              filePathController.text = widget.action.filePath;
                            });
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color:
                                  isLight ? Colors.grey[50] : Colors.grey[800],
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: isLight
                                    ? const Color(0xFF424242)
                                    : const Color(0xFFFAFAFA),
                                width: 1,
                              ),
                            ),
                            child:
                                const Icon(Icons.drive_folder_upload_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
          Icon(
            Icons.drive_folder_upload_outlined,
            size: 22,
          ),
          Text(
            'Image',
            style: TextStyle(fontSize: 12),
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
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: Builder(builder: (context) {
        final isLight = STheme.isLight(context);
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isLight ? Colors.grey[50] : Colors.grey[800],
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color:
                  isLight ? const Color(0xFF424242) : const Color(0xFFFAFAFA),
              width: 1,
            ),
          ),
          child: child,
        );
      }),
    );
  }
}
