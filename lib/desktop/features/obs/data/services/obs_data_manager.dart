import 'package:obs_websocket/obs_websocket.dart';

class ObsDataManager {
  final ObsWebSocket obs;

  ObsDataManager(this.obs);

  Future<List<Scene>> getScenes() async {
    final sceneListResponse = await obs.scenes.getSceneList();
    return sceneListResponse.scenes.reversed.toList();
  }

  Future<List<String>> getSourcesInScene(String sceneName,
      {bool includeGroupNames = false}) async {
    final result = <String>[];
    final sceneItems = await obs.sceneItems.getSceneItemList(sceneName);

    for (final item in sceneItems) {
      if (item.isGroup ?? false) {
        if (includeGroupNames) {
          result.add(item.sourceName);
        }
        
        final groupItems = await obs.sceneItems.getGroupSceneItemList(
          item.sourceName,
        );
        for (final groupItem in groupItems) {
          result.add(groupItem.sourceName);
        }
      } else {
        result.add(item.sourceName);
      }
    }

    return result;
  }
}
