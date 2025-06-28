import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/grid_template.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/grid/grid_area_wrapper.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/key_grid_area.dart';
import 'package:streamkeys/service_locator.dart';

class GridAreaStack extends StatefulWidget {
  const GridAreaStack({super.key});

  @override
  State<GridAreaStack> createState() => _GridAreaStackState();
}

class _GridAreaStackState extends State<GridAreaStack> {
  late GridTemplate selectedTemplate;

  @override
  void initState() {
    super.initState();
    selectedTemplate = GridTemplate.gridTemplates[2];
    _loadTemplate();
  }

  void _loadTemplate() {
    final prefs = sl<SharedPreferences>();
    final index = prefs.getInt('selected_grid_template') ?? 0;
    setState(() {
      selectedTemplate = GridTemplate.gridTemplates[index];
    });
  }

  Future<void> _saveTemplate(int index) async {
    final prefs = sl<SharedPreferences>();
    await prefs.setInt('selected_grid_template', index);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        KeyGridArea(
          child: GridAreaWrapper(gridTemplate: selectedTemplate),
        ),
        Positioned(
          top: Spacing.md,
          left: Spacing.md,
          child: DropdownButton<int>(
            value: GridTemplate.gridTemplates.indexOf(selectedTemplate),
            items: List.generate(GridTemplate.gridTemplates.length, (index) {
              return DropdownMenuItem<int>(
                value: index,
                child: Text(GridTemplate.gridTemplates[index].type),
              );
            }),
            onChanged: (int? newIndex) {
              if (newIndex == null) return;
              setState(() {
                selectedTemplate = GridTemplate.gridTemplates[newIndex];
              });
              _saveTemplate(newIndex);
            },
          ),
        ),
      ],
    );
  }
}
