import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_service.dart';
import 'package:streamkeys/desktop/utils/process_runner.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_service.dart';

final GetIt sl = GetIt.instance;

/// Initializes the service locator with all necessary dependencies for the app.
///
/// This includes shared services such as [SharedPreferences], repositories,
/// blocs, and any other singleton services used across the app.
///
/// Should be called before running the application, typically in `main()`.
Future<void> initServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final hidmacros = HidMacrosService(RealProcessRunner());

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<HidMacrosService>(() => hidmacros);
}
