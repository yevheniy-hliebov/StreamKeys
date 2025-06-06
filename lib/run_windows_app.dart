import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/features/deck_pages/bloc/deck_pages_bloc.dart';
import 'package:streamkeys/features/obs/bloc/obs_connection_bloc.dart';
import 'package:streamkeys/features/obs/data/repositories/obs_connection_repository.dart';
import 'package:streamkeys/features/server/server.dart';
import 'package:streamkeys/features/twitch/bloc/auth/twitch_auth_bloc.dart';
import 'package:streamkeys/features/twitch/bloc/connection/twitch_connection_bloc.dart';
import 'package:streamkeys/features/twitch/data/repositories/twitch_connection_service.dart';
import 'package:streamkeys/utils/hid_macros_helper.dart';
import 'package:streamkeys/windows_app.dart';

late final Server server;

Future<void> runWindowsApp() async {
  await HidMacrosHelper.start();

  final twitchRepository = TwitchRepository();
  final obsRepository = ObsConnectionRepository();
  final keyboardDeckPagesBloc = KeyboardDeckPagesBloc();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ObsConnectionBloc(obsRepository),
        ),
        BlocProvider(create: (_) => GridDeckPagesBloc()),
        BlocProvider(create: (_) => keyboardDeckPagesBloc),
        BlocProvider(
          create: (_) => TwitchAuthBloc(twitchRepository),
        ),
        BlocProvider(
          create: (_) => TwitchConnectionBloc(
            twitchRepository,
            TwitchConnectionService(),
          ),
        ),
      ],
      child: const WindowsApp(),
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  server = Server(
    obsConnectionRepository: obsRepository,
    keyboardDeckPagesBloc: keyboardDeckPagesBloc,
    twitchRepository: twitchRepository,
  );

  server.init().then((_) => server.start());
}
