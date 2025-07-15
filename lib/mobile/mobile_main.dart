import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/app.dart';
import 'package:streamkeys/mobile/features/api_connection/bloc/api_connection_bloc.dart';
import 'package:streamkeys/mobile/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:streamkeys/service_locator.dart';

void mobileMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();

  final secureStorage = sl<FlutterSecureStorage>();
  await secureStorage.deleteAll();

  final apiConnectionBloc = ApiConnectionBloc(
    ApiConnectionRepository(
      sl<ApiSecureStorage>(),
    ),
  );

  apiConnectionBloc.add(ApiConnectionLoad());

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => apiConnectionBloc,
      ),
    ],
    child: const App(home: DashboardScreen()),
  ));
}
