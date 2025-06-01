import 'package:flutter/material.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';

class VisibleSource extends BaseAction {
  String sceneName;
  String sourceName;

  final TextEditingController sceneNameController = TextEditingController();
  final TextEditingController sourceNameController = TextEditingController();

  static const String actionTypeName = 'visible_source';

  VisibleSource({this.sceneName = '', this.sourceName = ''})
      : super(
          actionType: actionTypeName,
          dialogTitle: 'Enter scene and source',
        ) {
    sourceNameController.text = sourceName;
  }

  @override
  String get actionName {
    if (sceneName.isEmpty && sourceName.isEmpty) {
      return 'OBS Visible Source';
    } else {
      return 'OBS Visible Source ($sceneName:$sourceName)';
    }
  }

  @override
  FutureVoid execute({dynamic data}) async {
    if (sourceName.isNotEmpty) {
      final obs = data as ObsWebSocket?;
      final sceneItemList = await obs?.sceneItems.getSceneItemList(
        sceneName,
      );

      int? itemId;
      String? groupName;

      if (sceneItemList != null) {
        for (var sceneItem in sceneItemList) {
          if (sceneItem.sourceName == sourceName) {
            itemId = sceneItem.sceneItemId;
            break;
          } else if (sceneItem.isGroup ?? false) {
            final groupItemList = await obs?.sceneItems
                .getGroupSceneItemList(sceneItem.sourceName);
            if (groupItemList != null) {
              for (var groupItem in groupItemList) {
                if (groupItem.sourceName == sourceName) {
                  itemId = groupItem.sceneItemId;
                  groupName = sceneItem.sourceName;
                  break;
                }
              }
            }
          }
        }
      }

      if (itemId != null) {
        await obs?.sceneItems.setSceneItemEnabled(
          SceneItemEnableStateChanged(
            sceneName: groupName ?? sceneName,
            sceneItemId: itemId,
            sceneItemEnabled: true,
          ),
        );
      }
    }
  }

  @override
  Json toJson() {
    return {
      'action_type': actionType,
      'scene_name': sceneName,
      'source_name': sourceName,
    };
  }

  @override
  void clear() {
    sourceName = '';
    sceneName = '';
    sourceNameController.clear();
  }

  @override
  VisibleSource copy() {
    return VisibleSource(sceneName: sceneName, sourceName: sourceName);
  }

  factory VisibleSource.fromJson(Json json) {
    return VisibleSource(
      sceneName: json['scene_name'] as String,
      sourceName: json['source_name'] as String,
    );
  }

  @override
  List<Widget> formFields(BuildContext context) {
    return [
      TextFormField(
        controller: sceneNameController,
        decoration: const InputDecoration(
          labelText: 'Scene Name',
        ),
        onChanged: (value) {
          sceneName = value;
        },
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: sourceNameController,
        decoration: const InputDecoration(
          labelText: 'Source Name',
        ),
        onChanged: (value) {
          sourceName = value;
        },
      ),
    ];
  }

  @override
  void save() {
    sceneName = sceneNameController.text;
    sourceName = sourceNameController.text;
  }

  @override
  void cancel() {
    sceneNameController.text = sceneName;
    sourceNameController.text = sourceName;
  }
}
