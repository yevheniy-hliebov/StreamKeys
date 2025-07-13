import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/desktop/features/streamerbot/bloc/settings/streamerbot_settings_bloc.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/models/streamerbot_connection_data.dart';
import 'package:streamkeys/desktop/features/streamerbot/data/repositories/streamerbot_repository.dart';

import 'streamerbot_settings_bloc_test.mocks.dart';

@GenerateMocks([StreamerBotSettingsRepository])
void main() {
  late MockStreamerBotSettingsRepository mockRepository;
  late StreamerBotSettingsBloc bloc;

  const fakeData = StreamerBotConnectionData(
    ip: 'localhost',
    port: '8080',
    password: 'secure',
    autoReconnect: true,
  );

  setUp(() {
    mockRepository = MockStreamerBotSettingsRepository();
    bloc = StreamerBotSettingsBloc(mockRepository);
  });

  group('StreamerBotSettingsBloc', () {
    test('initial state is StreamerBotSettingsInitial', () {
      expect(bloc.state, isA<StreamerBotSettingsInitial>());
    });

    test(
        'emits StreamerBotSettingsLoaded with data when StreamerBotSettingsLoad is added',
        () async {
      when(mockRepository.loadConnectionData())
          .thenAnswer((_) async => fakeData);

      bloc.add(StreamerBotSettingsLoad());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<StreamerBotSettingsLoaded>()
              .having((state) => state.data, 'data', fakeData),
        ]),
      );
    });

    test(
        'emits StreamerBotSettingsLoaded with new data when StreamerBotSettingsSave is added',
        () async {
      when(mockRepository.saveConnectionData(fakeData))
          .thenAnswer((_) async {});

      bloc.add(const StreamerBotSettingsSave(fakeData));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<StreamerBotSettingsLoaded>()
              .having((state) => state.data, 'data', fakeData),
        ]),
      );

      verify(mockRepository.saveConnectionData(fakeData)).called(1);
    });
  });
}
