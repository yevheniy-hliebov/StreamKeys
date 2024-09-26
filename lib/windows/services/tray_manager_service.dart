import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class TrayManagerService with TrayListener {
  Future<void> setupTray() async {
    trayManager.addListener(this);

    final directory = await getApplicationSupportDirectory();
    String iconPath = '${directory.path}/app_icon.ico';

    if (!File(iconPath).existsSync()) {
      final appIcon = File('lib/windows/app_icon.ico');
      await appIcon.copy(iconPath);
    }

    await trayManager.setIcon(iconPath);
    Menu menu = Menu(
      items: [
        MenuItem(key: 'show', label: 'Show'),
        MenuItem.separator(),
        MenuItem(key: 'exit', label: 'Exit'),
      ],
    );
    await trayManager.setContextMenu(menu);
  }

  @override
  void onTrayIconMouseDown() {
    windowManager.show();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'show') {
      windowManager.show();
    } else if (menuItem.key == 'exit') {
      windowManager.close();
    }
  }

  Future<void> dispose() async {
    trayManager.removeListener(this);
  }
}
