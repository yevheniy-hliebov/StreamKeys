import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/app.dart';
import 'package:streamkeys/mobile/features/api_connection/bloc/api_connection_bloc.dart';
import 'package:streamkeys/mobile/features/app_update/bloc/apk_download_bloc.dart';
import 'package:streamkeys/mobile/features/app_update/presentation/widgets/show_release_dialog.dart';
import 'package:streamkeys/mobile/features/buttons/bloc/buttons_bloc.dart';
import 'package:streamkeys/mobile/features/buttons/data/repositories/buttons_repository.dart';
import 'package:streamkeys/mobile/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:streamkeys/service_locator.dart';

void mobileMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();

  final prefs = sl<SharedPreferences>();
  await prefs.clear();

  final apiConnectionBloc = ApiConnectionBloc(
    ApiConnectionRepository(sl<ApiSecureStorage>()),
  );

  final buttonsBloc = ButtonsBloc(ButtonsRepository(sl<HttpButtonsApi>()));
  final appUpdate = sl<AppUpdateService>();

  apiConnectionBloc.add(ApiConnectionLoad());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => apiConnectionBloc),
        BlocProvider(create: (context) => buttonsBloc),
        BlocProvider(create: (context) => ApkDownloadBloc(appUpdate)),
      ],
      child: const App(
        home: DashboardScreen(
          onInit: showReleaseDialog,
        ),
      ),
    ),
  );
}
