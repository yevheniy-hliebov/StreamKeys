import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/typedef.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/forms/streamerbot_doaction_form.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/models/streamerbot_action.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:uuid/uuid.dart';

class StreamerBotDoAction extends BindingAction {
  final StreamerBotAction? action;

  StreamerBotDoAction({
    String? id,
    this.action,
  }) : super(
          id: id ?? const Uuid().v4(),
          type: ActionTypes.streamerBotDoAction,
          name: 'Do Action',
        );

  @override
  String get dialogTitle => 'Select action';

  @override
  String get label {
    if (action == null) {
      return 'Streamer.bot | $name';
    } else {
      return 'Streamer.bot | $name (${action!.name})';
    }
  }

  @override
  Widget getIcon(BuildContext context) {
    return BindingActionIcons.of(context).streamerbot;
  }

  @override
  Json toJson() {
    return {
      'type': type,
      'action': action?.toJson(),
    };
  }

  factory StreamerBotDoAction.fromJson(Json json) {
    return StreamerBotDoAction(
      action: json['action'] == null
          ? null
          : StreamerBotAction.fromJson(json['action']),
    );
  }

  @override
  BindingAction copy() {
    return StreamerBotDoAction(action: action);
  }

  @override
  Future<void> execute({Object? data}) async {
    if (action == null) return;

    final webSocket = sl<StreamerBotService>().webSocket;
    await webSocket.doAction(id: action!.id, name: name);
  }

  @override
  Widget? form(
    BuildContext context, {
    void Function(BindingAction updatedAction)? onUpdated,
  }) {
    final webSocket = sl<StreamerBotService>().webSocket;

    return StreamerBotDoactionForm(
      webSocket: webSocket,
      initialAction: action,
      onUpdated: (updated) {
        onUpdated?.call(StreamerBotDoAction(action: updated));
      },
    );
  }

  @override
  List<Object?> get props => [id, type, name, action];
}
