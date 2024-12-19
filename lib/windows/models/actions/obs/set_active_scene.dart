import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/base_action.dart';
import 'package:streamkeys/windows/services/obs_websocket_service.dart';

class SetActiveScene extends BaseAction {
  String sceneName;
  final TextEditingController sceneNameController = TextEditingController();

  static const String actionTypeName = 'Set Active Scene';

  SetActiveScene({this.sceneName = ''}) : super(actionType: actionTypeName) {
    sceneNameController.text = sceneName;
  }

  @override
  FutureVoid execute({dynamic data}) async {
    if (sceneName.isNotEmpty) {
      final service = data as ObsWebSocketService;
      await service.obs?.scenes.setCurrentProgramScene(sceneName);
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
}
