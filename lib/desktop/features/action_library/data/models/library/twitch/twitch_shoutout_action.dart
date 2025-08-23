import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/typedef.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/forms/single_field_binding_action_form.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:uuid/uuid.dart';

class TwitchShoutoutAction extends BindingAction {
  final String text;

  TwitchShoutoutAction({String? id, this.text = ''})
    : super(
        id: id ?? const Uuid().v4(),
        type: ActionTypes.twitchShoutout,
        name: 'Shoutout',
      );

  @override
  String get dialogTitle => 'Send a Shoutout';

  @override
  String get label {
    if (text.isEmpty) {
      return 'Twitch | $name';
    } else {
      return 'Twitch | $name to "$text"';
    }
  }

  @override
  Widget getIcon(BuildContext context) {
    return BindingActionIcons.of(context).twitchShoutout;
  }

  @override
  Json toJson() {
    return {'type': type, 'text': text};
  }

  factory TwitchShoutoutAction.fromJson(Json json) {
    return TwitchShoutoutAction(text: json['text'] as String);
  }

  @override
  BindingAction copy() {
    return TwitchShoutoutAction(text: text);
  }

  @override
  Future<void> execute({Object? data}) async {
    final twitchApi = sl<TwitchApiService>();
    final toId = await twitchApi.getUserIdByLogin(text);
    if (toId != null) {
      await twitchApi.sendShoutout(toId);
    }
  }

  @override
  Widget? form(
    BuildContext context, {
    void Function(BindingAction updatedAction)? onUpdated,
  }) {
    return SingleFieldBindingActionForm(
      label: 'Enter Twitch username',
      initialValue: text,
      onUpdate: (newValue) {
        onUpdated?.call(TwitchShoutoutAction(text: newValue));
      },
    );
  }

  @override
  List<Object?> get props => [id, type, name, text];
}
