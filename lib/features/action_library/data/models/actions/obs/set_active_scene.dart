import 'package:flutter/material.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';

class SetActiveScene extends BaseAction {
  String sceneName;
  final TextEditingController sceneNameController = TextEditingController();

  static const String actionTypeName = 'set_active_scene';

  SetActiveScene({this.sceneName = ''})
      : super(actionType: actionTypeName, dialogTitle: 'Enter a scene name') {
    sceneNameController.text = sceneName;
  }

  @override
  String get actionName {
    final showSceneName = sceneName.isNotEmpty ? '($sceneName)' : '';
    return 'OBS Set Active Scene $showSceneName';
  }

  @override
  FutureVoid execute({dynamic data}) async {
    if (sceneName.isNotEmpty) {
      final obs = data as ObsWebSocket?;
      await obs?.scenes.setCurrentProgramScene(sceneName);
    }
  }

  @override
  Json toJson() {
    return {
      'action_type': actionType,
      'scene_name': sceneName,
    };
  }

  @override
  void clear() {
    sceneName = '';
    sceneNameController.clear();
  }

  @override
  SetActiveScene copy() {
    return SetActiveScene(sceneName: sceneName);
  }

  factory SetActiveScene.fromJson(Json json) {
    return SetActiveScene(
      sceneName: json['scene_name'] as String,
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
    ];
  }

  @override
  void save() {
    sceneName = sceneNameController.text;
  }

  @override
  void cancel() {
    sceneNameController.text = sceneName;
  }
}
