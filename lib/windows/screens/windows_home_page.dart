import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:streamkeys/common/widgets/action_button.dart';
import 'package:streamkeys/windows/models/action.dart';
import 'package:streamkeys/windows/providers/windows_home_page_provider.dart';
import 'package:streamkeys/common/widgets/settings_button.dart';

class WindowsHomePage extends StatelessWidget {
  const WindowsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WindowsHomePageProvider(),
      child: Consumer<WindowsHomePageProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                provider.nameAndHost,
                style: const TextStyle(fontSize: 14),
              ),
              centerTitle: true,
              actions: [
                Transform.scale(
                  scale: 0.8,
                  child: const SettingsButton(),
                ),
              ],
              toolbarHeight: 45,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReorderableWrap(
                spacing: 10,
                runSpacing: 10,
                onReorder: provider.onReorder,
                children: List.generate(provider.actions.length, (i) {
                  return BaseActionButton(
                    key: ValueKey(provider.actions[i]),
                    onTap: () => provider.onTapActionButton(context, i),
                    tooltipMessage: provider.actions[i].name,
                    size: actionButtonSize(provider),
                    backgroundColor: provider.actions[i].backgroundColor,
                    child: _buildButtonActionContent(provider.actions[i]),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }

  double actionButtonSize(WindowsHomePageProvider provider) {
    const width = (380 - ((7 + 2) * 10)) / 7;
    const height = (252 - 16 - ((4 + 2) * 10)) / 4;
    return width > height ? height : width;
  }

  Widget _buildButtonActionContent(ButtonAction action) {
    if (action.imagePath == '' && action.filePath != '') {
      return const Icon(Icons.edit_square);
    } else if (action.imagePath == '') {
      return const Icon(Icons.add);
    } else {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.file(action.getImageFile()),
      );
    }
  }
}
