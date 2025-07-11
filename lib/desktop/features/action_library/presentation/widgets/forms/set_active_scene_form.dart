import 'package:flutter/material.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:streamkeys/common/widgets/buttons/custom_dropdown_button.dart';
import 'package:streamkeys/common/widgets/forms/field_label.dart';
import 'package:streamkeys/core/constants/spacing.dart';

class SetActiveSceneForm extends StatefulWidget {
  final String? initialSceneName;
  final void Function(Scene scene)? onSceneChanged;
  final Future<List<Scene>?> Function() getSceneList;

  const SetActiveSceneForm({
    super.key,
    this.initialSceneName,
    this.onSceneChanged,
    required this.getSceneList,
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
    final loadedScenes = await widget.getSceneList();

    if (loadedScenes == null) {
      obsNotConnected = true;
      isLoading = false;
      if (mounted) setState(() {});
      return;
    }

    scenes = loadedScenes.reversed.toList();
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
      return _buildCenteredMessage(const CircularProgressIndicator());
    }

    if (obsNotConnected) {
      return _buildCenteredMessage(const Text('Not connected to OBS'));
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
