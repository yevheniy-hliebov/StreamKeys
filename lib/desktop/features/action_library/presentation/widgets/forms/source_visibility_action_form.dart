import 'package:flutter/material.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/action_state_enum.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/source_visibility_action.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/forms/source_action_form.dart';

class SourceVisibilityActionForm extends StatelessWidget {
  final ObsWebSocket? obs;
  final SourceVisibilityAction initialAction;
  final void Function(BindingAction updatedAction)? onUpdated;

  const SourceVisibilityActionForm({
    super.key,
    this.obs,
    required this.initialAction,
    this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return SourceActionForm<VisibilityState>(
      obs: obs,
      initialSceneName: initialAction.sceneName,
      initialSourceName: initialAction.sourceName,
      initialState: initialAction.visibility,
      stateValues: VisibilityState.values,
      includeGroupNamesInSources: true,
      createAction: (scene, source, state) => SourceVisibilityAction(
        sceneName: scene,
        sourceName: source,
        visibility: state,
      ),
      onUpdated: onUpdated,
    );
  }
}
