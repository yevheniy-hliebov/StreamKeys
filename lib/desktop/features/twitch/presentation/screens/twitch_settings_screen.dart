import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streamkeys/common/widgets/tabs/page_tab.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/twitch/presentation/widgets/twitch_user_card.dart';

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
            child: Text(
              'Connect your Twitch account separately for Broadcaster and Bot. '
              'Broadcaster login allows you to manage your stream: change title, category, make announcements, and clear chat. '
              'Bot login is optional - it allows sending messages or making announcements in chat on behalf of the bot.',
              style: TextTheme.of(context).bodySmall,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
