import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/typedef.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/action_state_enum.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/forms/source_mute_action_form.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:uuid/uuid.dart';

class SourceMuteAction extends BindingAction {
  final String sceneName;
  final String sourceName;
  final MuteState muteState;

  SourceMuteAction({
    String? id,
    this.sceneName = '',
    this.sourceName = '',
    this.muteState = MuteState.toggle,
  }) : super(
          id: id ?? const Uuid().v4(),
          type: ActionTypes.sourceMute,
          name: 'Source Mute',
        );

  @override
  String get dialogTitle => 'Set Source Mute State';

  @override
  String get label {
    if (sceneName.isEmpty) {
      return 'OBS | $name';
    } else {
      final state = muteState.nameString;
      return 'OBS | $name ($state, Scene: $sceneName, source: $sourceName)';
    }
  }

  @override
  Widget getIcon(BuildContext context) {
    return BindingActionIcons.of(context).sourceMute;
  }

  @override
  Json toJson() {
    return {
      'type': type,
      'scene_name': sceneName,
      'source_name': sourceName,
      'mute_state': muteState.name,
    };
  }

  factory SourceMuteAction.fromJson(Json json) {
    return SourceMuteAction(
      sceneName: json['scene_name'] as String,
      sourceName: json['source_name'] as String,
      muteState: MuteState.fromString(json['mute_state'] as String),
    );
  }

  @override
  BindingAction copy() {
    return SourceMuteAction(
      sceneName: sceneName,
      sourceName: sourceName,
      muteState: muteState,
    );
  }

  @override
  Future<void> execute({Object? data}) async {
    if (sourceName.isNotEmpty) {
      final obs = sl<ObsService>().obs;
      if (muteState.isToggle) {
        await obs?.inputs.toggleInputMute(
          inputName: sourceName,
        );
      } else {
        await obs?.inputs.setInputMute(
          inputName: sourceName,
          inputMuted: muteState.isMute,
        );
      }
    }
  }

  @override
  Widget? form(
    BuildContext context, {
    void Function(BindingAction updatedAction)? onUpdated,
  }) {
    final obs = sl<ObsService>().obs;

    return SourceMuteActionForm(
      obs: obs,
      initialAction: this,
      onUpdated: onUpdated,
    );
  }

  @override
  List<Object?> get props => [id, type, name, sceneName, sourceName, muteState];
}
