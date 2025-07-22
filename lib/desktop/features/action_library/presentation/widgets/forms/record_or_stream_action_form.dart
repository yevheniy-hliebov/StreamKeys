import 'package:flutter/cupertino.dart';
import 'package:streamkeys/common/widgets/buttons/custom_dropdown_button.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/action_state_enum.dart';

class RecordOrStreamActionForm extends StatefulWidget {
  final ProcessState initialState;
  final void Function(ProcessState updated)? onUpdated;

  const RecordOrStreamActionForm({
    super.key,
    required this.initialState,
    this.onUpdated,
  });

  @override
  State<RecordOrStreamActionForm> createState() =>
      _RecordOrStreamActionFormState();
}

class _RecordOrStreamActionFormState extends State<RecordOrStreamActionForm> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = ProcessState.values.indexOf(widget.initialState);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Spacing.xs,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomDropdownButton(
          itemCount: ProcessState.values.length,
          index: selectedIndex,
          itemBuilder: (index) => Text(ProcessState.values[index].nameString),
          constraints: const BoxConstraints(),
          onChanged: (newIndex) {
            if (newIndex == null || newIndex == selectedIndex) return;

            setState(() {
              selectedIndex = newIndex;
            });
            widget.onUpdated?.call(ProcessState.values[newIndex]);
          },
        ),
      ],
    );
  }
}
