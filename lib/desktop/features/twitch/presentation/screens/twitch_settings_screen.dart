import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streamkeys/common/widgets/tabs/page_tab.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/core/constants/typography.dart';
import 'package:streamkeys/desktop/features/twitch/bloc/twitch_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> twitchLogin(String clientId, String scopes) async {
  const redirectUri = 'http://localhost:13560/api/twitch';
  final authUrl =
      'https://id.twitch.tv/oauth2/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=token&scope=$scopes';

  launchUrl(Uri.parse(authUrl));
}

class TwitchSettingsScreen extends StatelessWidget with PageTab {
  @override
  @override
  Widget get icon {
    return SizedBox(
      width: 18,
      height: 18,
      child: SvgPicture.asset('assets/action_icons/twitch.svg'),
    );
  }

  @override
  String get label => 'Twitch';

  @override
  Widget get pageView => this;

  const TwitchSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        spacing: Spacing.md,
        children: [
          const Row(
            spacing: Spacing.xs,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TwitchUserCard(isBot: false),
              TwitchUserCard(isBot: true),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200 * 2 + Spacing.xs),
            child: const Text(
              'Connect your Twitch account separately for Broadcaster and Bot. '
              'Broadcaster login allows you to manage your stream: change title, category, make announcements, and clear chat. '
              'Bot login is optional - it allows sending messages or making announcements in chat on behalf of the bot.',
              style: AppTypography.caption,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}

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
                            style: AppTypography.bodyStrong,
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(roleName, style: AppTypography.caption),
                        ],
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
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
        Text(roleName, style: AppTypography.body),
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
