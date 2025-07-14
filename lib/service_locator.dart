import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/core/storage/generic_secure_storage.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_preferences.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_service.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_xml_service.dart';
import 'package:streamkeys/desktop/features/obs/data/models/obs_connection_data.dart';
import 'package:streamkeys/desktop/features/obs/data/services/obs_service.dart';
import 'package:streamkeys/desktop/features/settings/data/services/http_server_password_service.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/models/streamerbot_connection_data.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/services/streamerbot_service.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/services/streamerbot_web_socket.dart';
import 'package:streamkeys/desktop/utils/launch_file_or_app_service.dart';
import 'package:streamkeys/desktop/utils/process_runner.dart';

export 'package:shared_preferences/shared_preferences.dart';
export 'package:flutter_secure_storage/flutter_secure_storage.dart';
export 'package:streamkeys/core/storage/generic_secure_storage.dart';
export 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_service.dart';
export 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_xml_service.dart';
export 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_preferences.dart';
export 'package:streamkeys/desktop/features/settings/data/services/http_server_password_service.dart';
export 'package:streamkeys/desktop/utils/launch_file_or_app_service.dart';
export 'package:streamkeys/desktop/features/obs/data/services/obs_service.dart';
export 'package:streamkeys/desktop/features/streamerbot/data/services/streamerbot_service.dart';

final GetIt sl = GetIt.instance;

typedef ObsSecureStorage = GenericSecureStorage<ObsConnectionData>;
typedef StreamerBotSecureStorage = GenericSecureStorage<StreamerBotConnectionData>;

/// Initializes the service locator with all necessary dependencies for the app.
///
/// This includes shared services such as [SharedPreferences], repositories,
/// blocs, and any other singleton services used across the app.
///
/// Should be called before running the application, typically in `main()`.
Future<void> initServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);

  if (Platform.isWindows) {
    final hidmacros = HidMacrosService(RealProcessRunner());
    final hidmacrosXml = HidMacrosXmlService();
    final hidMacrosPreferences = HidMacrosPreferences(sharedPreferences);

    final apiPasswordService = HttpServerPasswordService(secureStorage);

    final launchFileOrAppService = LaunchFileOrAppService(RealProcessRunner());

    final obsSecureStorage = ObsSecureStorage(
      secureStorage: secureStorage,
      emptyInstance: () => const ObsConnectionData(),
      fromMap: ObsConnectionData.fromMap,
    );
    final obs = ObsService(
      secureStorage: obsSecureStorage,
    );

    final streamerBotSecureStorage = StreamerBotSecureStorage(
      secureStorage: secureStorage,
      emptyInstance: () => const StreamerBotConnectionData(),
      fromMap: StreamerBotConnectionData.fromMap,
    );
    final streamerBot = StreamerBotService(
      secureStorage: streamerBotSecureStorage,
      webSocket: StreamerBotWebSocket(),
    );

    sl.registerLazySingleton<HidMacrosService>(() => hidmacros);
    sl.registerLazySingleton<HidMacrosXmlService>(() => hidmacrosXml);
    sl.registerLazySingleton<HidMacrosPreferences>(() => hidMacrosPreferences);

    sl.registerLazySingleton<HttpServerPasswordService>(
        () => apiPasswordService);

    sl.registerLazySingleton<LaunchFileOrAppService>(
      () => launchFileOrAppService,
    );

    sl.registerLazySingleton<ObsSecureStorage>(
      () => obsSecureStorage,
    );
    sl.registerLazySingleton<ObsService>(() => obs);

    sl.registerLazySingleton<StreamerBotSecureStorage>(
      () => streamerBotSecureStorage,
    );
    sl.registerLazySingleton<StreamerBotService>(() => streamerBot);
  }
}
