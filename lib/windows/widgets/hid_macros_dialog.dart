import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/windows/models/keyboard/keyboard_device.dart';
import 'package:streamkeys/windows/providers/browse_provider.dart';
import 'package:streamkeys/windows/providers/hidmacros_integration_provider.dart';

class HidMacrosDialog extends StatelessWidget {
  final BrowseProvider browseProvider;
  final KeyboardDevice selectedKeyboard;

  const HidMacrosDialog({
    super.key,
    required this.browseProvider,
    required this.selectedKeyboard,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HidmacrosIntegrationProvider(),
      child: Consumer<HidmacrosIntegrationProvider>(
          builder: (context, provider, child) {
        return Dialog(
          child: IntrinsicWidth(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select HID macros xml path',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: provider.filePathController,
                    decoration: InputDecoration(
                      labelText: 'HID macros xml file path',
                      suffixIcon: Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          onPressed: () {
                            browseProvider.openBrowse(provider.pickFile);
                          },
                          icon: const Icon(Icons.folder),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          await provider.createKeysHandlerVBS();
                        },
                        child: const Text('Create VBS excute files'),
                      ),
                      const SizedBox(width: 24),
                      OutlinedButton(
                        onPressed: () async {
                          await provider
                              .updateConfigFile(selectedKeyboard.systemId);
                        },
                        child: const Text('ReWrite HID Macros XML file'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

Future<void> showHIDMacrosDialog(
  BuildContext context,
  KeyboardDevice selectedKeyboard,
  BrowseProvider browseProvider,
) async {
  await showDialog<Color>(
    context: context,
    builder: (BuildContext context) {
      return HidMacrosDialog(
        browseProvider: browseProvider,
        selectedKeyboard: selectedKeyboard,
      );
    },
  );
}
