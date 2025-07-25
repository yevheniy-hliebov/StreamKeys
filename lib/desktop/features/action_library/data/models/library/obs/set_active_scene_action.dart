import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:streamkeys/common/models/typedef.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/forms/set_active_scene_form.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:uuid/uuid.dart';

class SetActiveSceneAction extends BindingAction {
  final String sceneName;

  SetActiveSceneAction({String? id, this.sceneName = ''})
    : super(
        id: id ?? const Uuid().v4(),
        type: ActionTypes.setActiveScene,
        name: 'Set Active Scene',
      );

  @override
  String get dialogTitle => 'Set a scene name';

  @override
  String get label {
    if (sceneName.isEmpty) {
      return 'OBS | $name';
    } else {
      return 'OBS | $name ($sceneName)';
    }
  }

  @override
  Widget getIcon(BuildContext context) {
    return BindingActionIcons.of(context).setActiveScene;
  }

  @override
  Json toJson() {
    return {'type': type, 'scene_name': sceneName};
  }

  factory SetActiveSceneAction.fromJson(Json json) {
    return SetActiveSceneAction(sceneName: json['scene_name'] as String);
  }

  @override
  BindingAction copy() {
    return SetActiveSceneAction(sceneName: sceneName);
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
    void Function(BindingAction updatedAction)? onUpdated,
  }) {
    final obs = sl<ObsService>().obs;
    return SetActiveSceneForm(
      obs: obs,
      initialSceneName: sceneName,
      onSceneChanged: (scene) {
        onUpdated?.call(SetActiveSceneAction(sceneName: scene.sceneName));
      },
    );
  }

  @override
  List<Object?> get props => [id, type, name, sceneName];
}
