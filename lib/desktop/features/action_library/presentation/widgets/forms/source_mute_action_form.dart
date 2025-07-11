import 'package:flutter/material.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/action_state_enum.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/source_mute_action.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/forms/source_action_form.dart';

class SourceMuteActionForm extends StatelessWidget {
  final ObsWebSocket? obs;
  final SourceMuteAction initialAction;
  final void Function(BindingAction updatedAction)? onUpdated;

  const SourceMuteActionForm({
    super.key,
    this.obs,
    required this.initialAction,
    this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return SourceActionForm<MuteState>(
      obs: obs,
      initialSceneName: initialAction.sceneName,
      initialSourceName: initialAction.sourceName,
      initialState: initialAction.muteState,
      stateValues: MuteState.values,
      includeGroupNamesInSources: false,
      createAction: (scene, source, state) => SourceMuteAction(
        sceneName: scene,
        sourceName: source,
        muteState: state,
      ),
      onUpdated: onUpdated,
    );
  }
}
