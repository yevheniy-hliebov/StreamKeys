import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:streamkeys/common/models/typedef.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/forms/set_active_scene_form.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:uuid/uuid.dart';

class SetActiveScene extends BindingAction {
  final String sceneName;

  SetActiveScene({String? id, this.sceneName = ''})
      : super(
          id: id ?? const Uuid().v4(),
          type: ActionTypes.setActiveScene,
          name: 'Set Active Scene',
        );

  @override
  String get dialogTitle => 'Enter the website URL';

  @override
  String get label {
    if (sceneName.isEmpty) {
      return name;
    } else {
      return '$name ($sceneName)';
    }
  }

  @override
  Widget getIcon(BuildContext context) {
    return BindingActionIcons.of(context).setActiveScene;
  }

  @override
  Json toJson() {
    return {
      'type': type,
      'scene_name': sceneName,
    };
  }

  factory SetActiveScene.fromJson(Json json) {
    return SetActiveScene(
      sceneName: json['scene_name'] as String,
    );
  }

  @override
  BindingAction copy() {
    return SetActiveScene(sceneName: sceneName);
  }

  @override
  Future<void> execute({Object? data}) async {
    if (sceneName.isNotEmpty) {
      final obs = sl<ObsService>().obs;
      await obs?.scenes.setCurrentProgramScene(sceneName);
    }
  }

  @override
  Widget? form(
    BuildContext context, {
    void Function(BindingAction updatedAction)? onUpdate,
  }) {
    return SetActiveSceneForm(
      initialSceneName: sceneName,
      getSceneList: _loadScenes,
      onSceneChanged: (scene) {
        onUpdate?.call(SetActiveScene(
          sceneName: scene.sceneName,
        ));
      },
    );
  }

  Future<List<Scene>?> _loadScenes() async {
    final obs = sl<ObsService>().obs;
    if (obs == null) {
      return null;
    }
    final scenes = await obs.scenes.getSceneList();
    return scenes.scenes;
  }

  @override
  List<Object?> get props => [id, type, name, sceneName];
}
