import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';
import 'package:streamkeys/features/twitch/bloc/auth/twitch_auth_bloc.dart';
import 'package:streamkeys/features/twitch/data/models/twich_account.dart';

class SendMessageToBroadcasterChannel extends BaseAction {
  bool isSendUsingBot;
  bool _isSendUsingBotTemporary = false;
  String message;
  final TextEditingController messageController = TextEditingController();

  static const String actionTypeName =
      'twitch_send_message_to_broadcaster_channel';

  SendMessageToBroadcasterChannel(
      {this.message = '', this.isSendUsingBot = false})
      : super(
          actionType: actionTypeName,
          dialogTitle: 'Enter a message',
        ) {
    messageController.text = message;
    _isSendUsingBotTemporary = isSendUsingBot;
  }

  @override
  String actionLabel = 'Chat message';

  @override
  String get actionName {
    String viaBot = isSendUsingBot ? '[bot]' : '';
    if (message.isEmpty) {
      return 'Twitch $actionLabel';
    } else {
      return 'Twitch $actionLabel $viaBot ($message)';
    }
  }

  @override
  FutureVoid execute({dynamic data}) async {
    if (message.isEmpty) return;

    final twitchRepository = data as TwitchRepository;

    try {
      final broadcastAccount = twitchRepository.broadcasterAccount;

      if (broadcastAccount == null &&
          broadcastAccount!.username.isEmpty &&
          broadcastAccount.userId.isEmpty) {
        debugPrint('Twitch account not available for sending message');
        return;
      }

      TwitchAccount senderAccount = broadcastAccount;
      if (isSendUsingBot) {
        final botAccount = twitchRepository.botAccount;
        if (botAccount == null) return;
        senderAccount = botAccount;
      }
      await twitchRepository.sendChatMessage(
        broadcasterId: broadcastAccount.userId,
        senderAccount: senderAccount,
        message: message,
      );
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  }

  @override
  Json toJson() {
    return {
      'action_type': actionType,
      'message': message,
      'is_send_using_bot': isSendUsingBot,
    };
  }

  @override
  SendMessageToBroadcasterChannel copy() {
    return SendMessageToBroadcasterChannel(
      message: message,
      isSendUsingBot: isSendUsingBot,
    );
  }

  factory SendMessageToBroadcasterChannel.fromJson(Json json) {
    return SendMessageToBroadcasterChannel(
      message: json['message'] as String,
      isSendUsingBot: json['is_send_using_bot'] as bool,
    );
  }

  @override
  Widget? form(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: messageController,
          decoration: const InputDecoration(
            labelText: 'Message',
          ),
        ),
        Row(
          children: [
            InitialCheckbox(
              initialValue: isSendUsingBot,
              onChanged: (value) {
                _isSendUsingBotTemporary = value;
              },
            ),
            const Text('Send using bot account'),
          ],
        ),
      ],
    );
  }

  @override
  void save() {
    message = messageController.text;
    isSendUsingBot = _isSendUsingBotTemporary;
  }

  @override
  void cancel() {
    messageController.text = message;
    _isSendUsingBotTemporary = isSendUsingBot;
  }
}

class InitialCheckbox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const InitialCheckbox({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<InitialCheckbox> createState() => _InitialCheckboxState();
}

class _InitialCheckboxState extends State<InitialCheckbox> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: (newValue) {
        if (newValue == null) return;
        setState(() {
          value = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }
}
