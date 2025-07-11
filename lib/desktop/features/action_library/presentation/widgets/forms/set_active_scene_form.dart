import 'package:flutter/material.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:streamkeys/common/widgets/buttons/custom_dropdown_button.dart';
import 'package:streamkeys/common/widgets/forms/field_label.dart';
import 'package:streamkeys/common/widgets/placeholders/loader_placeholder.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/obs_not_connected_placeholder.dart';
import 'package:streamkeys/desktop/features/obs/data/services/obs_data_manager.dart';

class SetActiveSceneForm extends StatefulWidget {
  final ObsWebSocket? obs;
  final String? initialSceneName;
  final void Function(Scene scene)? onSceneChanged;

  const SetActiveSceneForm({
    super.key,
    this.obs,
    this.initialSceneName,
    this.onSceneChanged,
  });

  @override
  State<SetActiveSceneForm> createState() => _SetActiveSceneFormState();
}

class _SetActiveSceneFormState extends State<SetActiveSceneForm> {
  int? selectedIndex;
  List<Scene> scenes = [];

  bool isLoading = true;
  bool obsNotConnected = false;

  @override
  void initState() {
    super.initState();
    _loadScenesAndInitSelected();
  }

  Future<void> _loadScenesAndInitSelected() async {
    final obs = widget.obs;

    if (obs == null) {
      obsNotConnected = true;
      isLoading = false;
      if (mounted) setState(() {});
      return;
    }

    final manager = ObsDataManager(obs);

    scenes = await manager.getScenes();
    isLoading = false;

    final initialName = widget.initialSceneName;
    int index = 0;

    if (initialName != null) {
      index = scenes.indexWhere((scene) => scene.sceneName == initialName);
    }

    if (index == -1) {
      selectedIndex = 0;
      if (scenes.isNotEmpty) _notifySceneChanged(scenes[0]);
    } else {
      selectedIndex = index;
      _notifySceneChanged(scenes[index]);
    }

    if (mounted) setState(() {});
  }

  void _notifySceneChanged(Scene scene) {
    widget.onSceneChanged?.call(scene);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildCenteredMessage(const LoaderPlaceholder());
    }

    if (obsNotConnected) {
      return _buildCenteredMessage(const ObsNotConnectedPlaceholder());
    }

    if (scenes.isEmpty) {
      return _buildCenteredMessage(const Text('No scenes found'));
    }

    final currentIndex = selectedIndex ?? 0;

    return Column(
      spacing: Spacing.xs,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const FieldLabel('Scene name'),
        CustomDropdownButton(
          itemCount: scenes.length,
          index: currentIndex,
          itemBuilder: (index) => Text(scenes[index].sceneName),
          constraints: const BoxConstraints(),
          onChanged: (newIndex) {
            if (newIndex == null || newIndex == selectedIndex) return;

            setState(() {
              selectedIndex = newIndex;
            });
            _notifySceneChanged(scenes[newIndex]);
          },
        ),
      ],
    );
  }

  Widget _buildCenteredMessage(Widget child) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [child],
    );
  }
}
