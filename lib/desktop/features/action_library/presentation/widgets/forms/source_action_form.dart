import 'package:flutter/material.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:streamkeys/common/widgets/buttons/custom_dropdown_button.dart';
import 'package:streamkeys/common/widgets/forms/field_label.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/action_state_enum.dart'
    show ActionStateEnum;
import 'package:streamkeys/desktop/features/obs/data/services/obs_data_manager.dart';

class SourceActionForm<T extends ActionStateEnum> extends StatefulWidget {
  final ObsWebSocket? obs;
  final String initialSceneName;
  final String initialSourceName;
  final T initialState;
  final List<T> stateValues;
  final bool includeGroupNamesInSources;
  final BindingAction Function(String sceneName, String sourceName, T state)
  createAction;
  final void Function(BindingAction updatedAction)? onUpdated;

  const SourceActionForm({
    super.key,
    this.obs,
    required this.initialSceneName,
    required this.initialSourceName,
    required this.initialState,
    required this.stateValues,
    this.includeGroupNamesInSources = false,
    required this.createAction,
    this.onUpdated,
  });

  @override
  State<SourceActionForm<T>> createState() => _SourceActionFormState<T>();
}

class _SourceActionFormState<T extends ActionStateEnum>
    extends State<SourceActionForm<T>> {
  int? selectedSceneIndex;
  int? selectedSourceIndex;
  int? selectedStateIndex;

  List<Scene> scenes = [];
  List<String> sources = [];

  bool isLoading = true;
  bool obsNotConnected = false;

  late ObsDataManager? _dataManager;

  @override
  void initState() {
    super.initState();

    if (widget.obs != null) {
      _dataManager = ObsDataManager(widget.obs!);
    } else {
      _dataManager = null;
    }

    _loadAndInitSelected();
  }

  Future<void> _loadAndInitSelected() async {
    if (_dataManager == null) {
      obsNotConnected = true;
      isLoading = false;
      if (mounted) setState(() {});
      return;
    }

    try {
      scenes = await _dataManager!.getScenes();

      final sceneIndex = scenes.indexWhere(
        (s) => s.sceneName == widget.initialSceneName,
      );
      selectedSceneIndex = sceneIndex >= 0 ? sceneIndex : 0;

      final sceneName = scenes.isEmpty
          ? ''
          : scenes[selectedSceneIndex ?? 0].sceneName;
      sources = await _dataManager!.getSourcesInScene(
        sceneName,
        includeGroupNames: widget.includeGroupNamesInSources,
      );

      final sourceIndex = sources.indexWhere(
        (src) => src == widget.initialSourceName,
      );
      selectedSourceIndex = sourceIndex >= 0 ? sourceIndex : 0;

      selectedStateIndex = widget.stateValues.indexOf(widget.initialState);
    } catch (_) {
      obsNotConnected = true;
    }

    isLoading = false;
    if (mounted) setState(() {});
    _notifyChanged();
  }

  void _notifyChanged() {
    final sceneName = scenes.isEmpty
        ? ''
        : scenes[selectedSceneIndex ?? 0].sceneName;
    final sourceName = sources.isEmpty ? '' : sources[selectedSourceIndex ?? 0];
    final state = widget.stateValues[selectedStateIndex ?? 0];

    widget.onUpdated?.call(widget.createAction(sceneName, sourceName, state));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (obsNotConnected) {
      return const Center(child: Text('Not connected to OBS'));
    }

    return Column(
      spacing: Spacing.xs,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const FieldLabel('Scene'),
        if (scenes.isEmpty)
          const Text('No scenes found')
        else
          CustomDropdownButton(
            itemCount: scenes.length,
            index: selectedSceneIndex,
            itemBuilder: (index) => Text(scenes[index].sceneName),
            constraints: const BoxConstraints(),
            onChanged: (newIndex) async {
              if (newIndex == null || newIndex == selectedSceneIndex) return;

              setState(() {
                selectedSceneIndex = newIndex;
                isLoading = true;
              });

              final sceneName = scenes[newIndex].sceneName;
              sources = await _dataManager!.getSourcesInScene(
                sceneName,
                includeGroupNames: widget.includeGroupNamesInSources,
              );
              selectedSourceIndex = sources.isNotEmpty ? 0 : null;

              isLoading = false;
              if (mounted) setState(() {});
              _notifyChanged();
            },
          ),
        const FieldLabel('Source'),
        if (sources.isEmpty)
          const Text('No sources found')
        else
          CustomDropdownButton(
            itemCount: sources.length,
            index: selectedSourceIndex,
            itemBuilder: (index) => Text(sources[index]),
            constraints: const BoxConstraints(),
            onChanged: (newIndex) {
              if (newIndex == null || newIndex == selectedSourceIndex) return;

              setState(() {
                selectedSourceIndex = newIndex;
              });
              _notifyChanged();
            },
          ),
        const FieldLabel('State'),
        CustomDropdownButton(
          itemCount: widget.stateValues.length,
          index: selectedStateIndex,
          itemBuilder: (index) => Text(widget.stateValues[index].nameString),
          constraints: const BoxConstraints(),
          onChanged: (newIndex) {
            if (newIndex == null || newIndex == selectedStateIndex) return;

            setState(() {
              selectedStateIndex = newIndex;
            });
            _notifyChanged();
          },
        ),
      ],
    );
  }
}
