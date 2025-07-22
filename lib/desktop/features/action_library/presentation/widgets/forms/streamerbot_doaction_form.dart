import 'package:flutter/cupertino.dart';
import 'package:streamkeys/common/widgets/buttons/custom_dropdown_button.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/models/streamerbot_action.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/services/streamerbot_web_socket.dart';

class StreamerBotDoactionForm extends StatefulWidget {
  final StreamerBotWebSocket webSocket;
  final StreamerBotAction? initialAction;
  final void Function(StreamerBotAction updated)? onUpdated;

  const StreamerBotDoactionForm({
    super.key,
    required this.webSocket,
    required this.initialAction,
    this.onUpdated,
  });

  @override
  State<StreamerBotDoactionForm> createState() =>
      _StreamerBotDoactionFormState();
}

class _StreamerBotDoactionFormState extends State<StreamerBotDoactionForm> {
  int selectedIndex = 0;
  List<StreamerBotAction> actions = [];

  @override
  void initState() {
    super.initState();
    loadAction();
  }

  void loadAction() async {
    final response = await widget.webSocket.getActions();
    actions = response.actions;

    if (widget.initialAction != null) {
      selectedIndex = actions.indexWhere(
        (a) => a.id == widget.initialAction!.id,
      );
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Spacing.xs,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomDropdownButton(
          itemCount: actions.length,
          index: selectedIndex,
          itemBuilder: (index) {
            final action = actions[index];
            if (action.id == widget.initialAction?.id &&
                action.name != widget.initialAction?.name) {
              return Text(
                '${actions[index].name} (old name: ${widget.initialAction?.name})',
              );
            }
            return Text(actions[index].name);
          },
          constraints: const BoxConstraints(),
          onChanged: (newIndex) {
            if (newIndex == null || newIndex == selectedIndex) return;

            setState(() {
              selectedIndex = newIndex;
            });
            widget.onUpdated?.call(actions[newIndex]);
          },
        ),
      ],
    );
  }
}
