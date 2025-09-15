import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/app.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/core/cursor_status/widgets/cursor_status.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';
import 'package:streamkeys/core/app_update/presentation/widgets/app_version_status.dart';
import 'package:streamkeys/core/app_update/presentation/widgets/update_dialog.dart';
import 'package:streamkeys/desktop/features/connection/bloc/integration_connection_bloc.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:streamkeys/common/widgets/tabs/page_tab.dart';
import 'package:streamkeys/desktop/features/deck/presentation/screens/grid_deck_screen.dart';
import 'package:streamkeys/desktop/features/deck/presentation/screens/keyboard_deck_screen.dart';
import 'package:streamkeys/desktop/features/deck_page_list/bloc/deck_page_list_bloc.dart';
import 'package:streamkeys/desktop/features/hidmacros/bloc/connection/hidmacros_connection_bloc.dart';
import 'package:streamkeys/desktop/features/hidmacros/bloc/hidmacros_bloc.dart';
import 'package:streamkeys/desktop/features/hidmacros/presentation/widgets/hidmacros_connection_status_indicator.dart';
import 'package:streamkeys/desktop/features/obs/bloc/connection/obs_connection_bloc.dart';
import 'package:streamkeys/desktop/features/obs/presentations/screen/obs_settings_screen.dart';
import 'package:streamkeys/desktop/features/obs/presentations/widgets/obs_connection_status_indicator.dart';
import 'package:streamkeys/desktop/features/settings/presentation/screens/general_settings_screen.dart';
import 'package:streamkeys/desktop/features/hidmacros/presentation/screens/hidmacros_settings_screen.dart';
import 'package:streamkeys/desktop/features/settings/presentation/screens/settings_screen.dart';
import 'package:streamkeys/desktop/features/settings/presentation/screens/http_server_config_screen.dart';
import 'package:streamkeys/desktop/features/twitch/presentation/screens/twitch_settings_screen.dart';
import 'package:streamkeys/desktop/features/streamerbot/bloc/connection/streamerbot_connection_bloc.dart';
import 'package:streamkeys/desktop/features/streamerbot/presentation/screens/streamerbot_settings_screen.dart';
import 'package:streamkeys/desktop/features/streamerbot/presentation/widgets/streamerbot_connection_status_indicator.dart';
import 'package:streamkeys/desktop/features/twitch/bloc/twitch_bloc.dart';
import 'package:streamkeys/desktop/features/twitch/data/services/twitch_auth_service.dart';
import 'package:streamkeys/desktop/features/twitch/presentation/widgets/twitch_connection_status_indicator.dart';
import 'package:streamkeys/desktop/server/server.dart';
import 'package:streamkeys/service_locator.dart';

void desktopMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();

  registerBindingActions();

  final server = Server();
  await server.init();
  server.start();

  final hidmacros = sl<HidMacrosService>();
  await hidmacros.ensureConfigAndStart();

  final gridDeckBloc = GridDeckPageListBloc();
  final keyboardDeckBloc = KeyboardDeckPageListBloc();
  final hidmacrosBloc = HidMacrosBloc(repo: HidMacrosRepository(hidmacros));

  gridDeckBloc.add(DeckPageListInit());
  keyboardDeckBloc.add(DeckPageListInit());
  hidmacrosBloc.add(HidMacrosLoadEvent());

  final obs = sl<ObsService>();
  obs.autoConnect();

  final streamerBot = sl<StreamerBotService>();
  streamerBot.autoConnect();

  Future<void> checkUpdateHandler(BuildContext context) async {
    final appUpdateService = sl<AppUpdateService>();
    final updateVersion = await appUpdateService.checkForUpdate();

    if (updateVersion?.tagName == appUpdateService.getIgnoredVersion()) {
      return;
    }

    if (updateVersion?.tagName == appUpdateService.getCurrentVersion()) {
      return;
    }

    if (updateVersion != null && context.mounted) {
      await UpdateDialog.showUpdateDialog(context, updateVersion);
    }
  }

  final twitchTokenService = sl<TwitchTokenService>();
  final twitchBloc = TwitchBloc(
    TwitchAuthService(twitchTokenService),
    sl<TwitchAuthChecker>(),
  );

  twitchBloc.add(TwitchStartChecking());

  runApp(
    App(
      providersBuilder: (context) => [
        BlocProvider<GridDeckPageListBloc>(create: (_) => gridDeckBloc),
        BlocProvider<KeyboardDeckPageListBloc>(create: (_) => keyboardDeckBloc),
        BlocProvider<HidMacrosBloc>(create: (context) => hidmacrosBloc),
        BlocProvider<HidMacrosConnectionBloc>(
          create: (context) => HidMacrosConnectionBloc(
            subcription: hidmacros.statusMonitor.status,
            check: hidmacros.statusMonitor.checkStatus,
          )..add(IntegrationConnectionCheck()),
        ),
        BlocProvider<ObsConnectionBloc>(
          create: (context) => ObsConnectionBloc(obs),
        ),
        BlocProvider<StreamerBotConnectionBloc>(
          create: (context) => StreamerBotConnectionBloc(streamerBot),
        ),
        BlocProvider<TwitchBloc>(create: (context) => twitchBloc),
      ],
      home: CursorStatus(
        child: DashboardScreen(
          onInit: checkUpdateHandler,
          tabs: const <PageTab>[
            GridDeckScreen(),
            KeyboardDeckScreen(),
            SettingsScreen(
              tabs: <PageTab>[
                GeneralSettingsScreen(),
                HttpServerConfigScreen(),
                ObsSettingsScreen(),
                StreamerBotSettingsScreen(),
                TwitchSettingsScreen(),
                HidMacrosSettingsScreen(),
              ],
            ),
          ],
          statusWidgets: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                child: AppVersionStatus(
                  appUpdateService: sl<AppUpdateService>(),
                ),
              ),
            ),
            const HidMacrosStatusIndicator(),
            const TwitchConnectionStatusIndicator(),
            const StreamerBotConnectionStatusIndicator(),
            const ObsConnectionStatusIndicator(),
          ],
        ),
      ),
    ),
  );
}
