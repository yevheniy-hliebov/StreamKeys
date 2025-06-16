import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

/// Initializes the service locator with all necessary dependencies for the app.
///
/// This includes shared services such as [SharedPreferences], repositories,
/// blocs, and any other singleton services used across the app.
///
/// Should be called before running the application, typically in `main()`.
Future<void> initServiceLocator() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}
