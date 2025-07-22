import 'package:flutter/cupertino.dart';
import 'package:obs_websocket/event.dart';
import 'package:streamkeys/common/models/typedef.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/action_state_enum.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/forms/source_visibility_action_form.dart';
import 'package:streamkeys/desktop/features/obs/data/services/obs_data_manager.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:uuid/uuid.dart';

class SourceVisibilityAction extends BindingAction {
  final String sceneName;
  final String sourceName;
  final VisibilityState visibility;

  SourceVisibilityAction({
    String? id,
    this.sceneName = '',
    this.sourceName = '',
    this.visibility = VisibilityState.toggle,
  }) : super(
         id: id ?? const Uuid().v4(),
         type: ActionTypes.sourceVisibility,
         name: 'Source Visibility',
       );

  @override
  String get dialogTitle => 'Set Source Visibility State';

  @override
  String get label {
    if (sceneName.isEmpty) {
      return 'OBS | $name';
    } else {
      final state = visibility.nameString;
      return 'OBS | $name ($state, Scene: $sceneName, source: $sourceName)';
    }
  }

  @override
  Widget getIcon(BuildContext context) {
    return BindingActionIcons.of(context).sourceVisibility;
  }

  @override
  Json toJson() {
    return {
      'type': type,
      'scene_name': sceneName,
      'source_name': sourceName,
      'visibility': visibility.name,
    };
  }

  factory SourceVisibilityAction.fromJson(Json json) {
    return SourceVisibilityAction(
      sceneName: json['scene_name'] as String,
      sourceName: json['source_name'] as String,
      visibility: VisibilityState.fromString(json['visibility'] as String),
    );
  }

  @override
  BindingAction copy() {
    return SourceVisibilityAction(
      sceneName: sceneName,
      sourceName: sourceName,
      visibility: visibility,
    );
  }

  @override
  Future<void> execute({Object? data}) async {
    if (sourceName.isEmpty) return;

    final obs = sl<ObsService>().obs;
    if (obs == null) return;

    final manager = ObsDataManager(obs);
    final result = await manager.findSceneItemId(sceneName, sourceName);
    if (result == null) return;

    final itemId = result.itemId;
    final targetScene = result.groupName ?? sceneName;

    if (visibility.isToggle) {
      final enabled = await obs.sceneItems.getEnabled(
        sceneName: targetScene,
        sceneItemId: itemId,
      );
      await obs.sceneItems.setSceneItemEnabled(
        SceneItemEnableStateChanged(
          sceneName: targetScene,
          sceneItemId: itemId,
          sceneItemEnabled: !enabled,
        ),
      );
    } else {
      final shouldEnable = visibility.isVisible;
      await obs.sceneItems.setSceneItemEnabled(
        SceneItemEnableStateChanged(
          sceneName: targetScene,
          sceneItemId: itemId,
          sceneItemEnabled: shouldEnable,
        ),
      );
    }
  }

  @override
  Widget? form(
    BuildContext context, {
    void Function(BindingAction updatedAction)? onUpdated,
  }) {
    final obs = sl<ObsService>().obs;

    return SourceVisibilityActionForm(
      obs: obs,
      initialAction: this,
      onUpdated: onUpdated,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    name,
    sceneName,
    sourceName,
    visibility,
  ];
}
