part of 'key_bindings_bloc.dart';

mixin KeyBindingsUtils {
  late KeyBindingPagesMap map;
  late String currentPageId;

  KeyBindingMap get pageMap {
    return Map.from(map[currentPageId] ?? <String, KeyBindingData>{});
  }

  KeyBindingMap getOrCreatePageKeyMap() {
    return map.putIfAbsent(currentPageId, () => <String, KeyBindingData>{});
  }

  KeyBindingData? getKeyBindingData(int? keyCode) {
    final KeyBindingMap currentMap = pageMap;
    return currentMap[keyCode.toString()];
  }
}
