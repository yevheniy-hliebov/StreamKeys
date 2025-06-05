import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/dashboard/widgets/deck_button.dart';
import 'package:streamkeys/features/deck_pages/bloc/deck_pages_bloc.dart';
import 'package:streamkeys/features/keyboards_deck/keyboard_deck_page.dart';
import 'package:streamkeys/features/obs/bloc/obs_connection_bloc.dart';
import 'package:streamkeys/features/server/server.dart';
import 'package:streamkeys/features/settings/widgets/setting_button.dart';
import 'package:streamkeys/features/twitch/bloc/auth/twitch_auth_bloc.dart';
import 'package:streamkeys/utils/navigate_to_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startServer();
    });
  }

  FutureVoid startServer() async {
    final obsConnectionRepository =
        context.read<ObsConnectionBloc>().repository;
    final keyboardDeckPagesBloc = context.read<KeyboardDeckPagesBloc>();
    final twitchRepository = context.read<TwitchAuthBloc>().repository;

    final server = Server(
      obsConnectionRepository: obsConnectionRepository,
      keyboardDeckPagesBloc: keyboardDeckPagesBloc,
      twitchRepository: twitchRepository,
    );
    await server.init();
    await server.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          SettingButton(),
          SizedBox(width: 4),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const DeckButton(
              text: 'Grid Deck',
            ),
            const SizedBox(width: 16),
            DeckButton(
              text: 'Keyboard Deck',
              onPressed: () => navigateToPage(
                page: const KeyboardDeckPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
