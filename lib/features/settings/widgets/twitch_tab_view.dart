import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/features/twitch/bloc/auth/twitch_auth_bloc.dart';
import 'package:streamkeys/features/twitch/widgets/accounts_row.dart';
import 'package:streamkeys/features/twitch/widgets/useful_info_section.dart';

class TwitchTabView extends StatelessWidget {
  static const String tabName = 'Twitch';

  const TwitchTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TwitchAuthBloc, TwitchAuthState>(
      builder: (context, state) {
        if (state is! TwitchAuthLoaded) return const SizedBox();

        return SingleChildScrollView(
          child: Column(
            spacing: 24,
            children: [
              AccountsRow(
                broadcasterAccount: state.broadcaster,
                isSavingBroadcaster: state.isSavingBroadcaster,
                botAccount: state.bot,
                isSavingBot: state.isSavingBot,
              ),
              const UsefulInfoSection(),
            ],
          ),
        );
      },
    );
  }
}
