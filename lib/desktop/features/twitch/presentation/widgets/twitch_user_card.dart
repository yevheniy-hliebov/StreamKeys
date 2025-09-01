import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/twitch/bloc/twitch_bloc.dart';

class TwitchUserCard extends StatelessWidget {
  final bool isBot;

  const TwitchUserCard({super.key, this.isBot = false});

  String get roleName => isBot ? 'Bot' : 'Broadcaster';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: AppColors.of(context).surface,
        border: Border.all(color: AppColors.of(context).surface),
        borderRadius: BorderRadius.circular(Spacing.xs),
      ),
      child: BlocBuilder<TwitchBloc, TwitchState>(
        builder: (context, state) {
          final userInfo = isBot ? state.bot : state.broadcaster;

          if (userInfo == null) {
            return _buildLogin(context);
          } else {
            return Column(
              spacing: Spacing.xs,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  spacing: Spacing.xs,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(999),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.network(
                          userInfo.avatarUrl,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xFF6441A5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 32,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (userInfo.displayName).characters.join('\u200B'),
                            style: TextTheme.of(context).bodyLarge,
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            roleName,
                            style: TextTheme.of(context).bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                FilledButton(
                  onPressed: () {
                    context.read<TwitchBloc>().add(TwitchLogout(isBot: isBot));
                  },
                  child: const Text('Logout'),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Column _buildLogin(BuildContext context) {
    return Column(
      spacing: Spacing.xs,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(roleName, style: TextTheme.of(context).bodyMedium),
        FilledButton(
          onPressed: () {
            context.read<TwitchBloc>().add(TwitchLogin(isBot: isBot));
          },
          child: const Text('Login via twitch'),
        ),
      ],
    );
  }
}
