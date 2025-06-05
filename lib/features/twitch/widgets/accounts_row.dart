import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/features/twitch/bloc/auth/twitch_auth_bloc.dart';
import 'package:streamkeys/features/twitch/data/models/twich_account.dart';
import 'package:streamkeys/features/twitch/widgets/twitch_account_form.dart';

class AccountsRow extends StatelessWidget {
  final TwitchAccount? broadcasterAccount;
  final bool isSavingBroadcaster;
  final TwitchAccount? botAccount;
  final bool isSavingBot;

  const AccountsRow({
    super.key,
    required this.broadcasterAccount,
    required this.isSavingBroadcaster,
    required this.botAccount,
    required this.isSavingBot,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        _AccountFormContainer(
          key: const Key('Broadcaster Account'),
          label: 'Broadcaster Account',
          initialAccount: broadcasterAccount,
          isSaving: isSavingBroadcaster,
          onSave: (account) => context
              .read<TwitchAuthBloc>()
              .add(SaveAccount(account, 'broadcaster')),
        ),
        _AccountFormContainer(
          key: const Key('Bot Account'),
          label: 'Bot Account',
          initialAccount: botAccount,
          isSaving: isSavingBot,
          onSave: (account) =>
              context.read<TwitchAuthBloc>().add(SaveAccount(account, 'bot')),
        ),
      ],
    );
  }
}

class _AccountFormContainer extends StatelessWidget {
  final String label;
  final TwitchAccount? initialAccount;
  final bool isSaving;
  final void Function(TwitchAccount) onSave;

  const _AccountFormContainer({
    super.key,
    required this.label,
    required this.initialAccount,
    required this.isSaving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      constraints: const BoxConstraints(maxWidth: 400),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TwitchAccountForm(
        label: label,
        initialAccount: initialAccount,
        isSaving: isSaving,
        onSave: onSave,
      ),
    );
  }
}
