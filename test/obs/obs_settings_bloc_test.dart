import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/desktop/features/obs/bloc/settings/obs_settings_bloc.dart';
import 'package:streamkeys/desktop/features/obs/data/models/obs_connection_data.dart';
import 'package:streamkeys/desktop/features/obs/data/repositories/obs_repository.dart';

import 'obs_settings_bloc_test.mocks.dart';

@GenerateMocks([ObsSettingsRepository])
void main() {
  late MockObsSettingsRepository mockRepository;
  late ObsSettingsBloc bloc;

  const fakeData = ObsConnectionData(
    ip: '127.0.0.1',
    port: '4455',
    password: 'pass',
    autoReconnect: true,
  );

  setUp(() {
    mockRepository = MockObsSettingsRepository();
    bloc = ObsSettingsBloc(mockRepository);
  });

  group('ObsSettingsBloc', () {
    test('initial state is ObsSettingsInitial', () {
      expect(bloc.state, isA<ObsSettingsInitial>());
    });

    test('emits ObsSettingsLoaded with data when ObsSettingsLoad is added',
        () async {
      when(mockRepository.loadConnectionData())
          .thenAnswer((_) async => fakeData);

      bloc.add(ObsSettingsLoad());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ObsSettingsLoaded>()
              .having((state) => state.data, 'data', fakeData),
        ]),
      );
    });

    test('emits ObsSettingsLoaded with new data when ObsSettingsSave is added',
        () async {
      when(mockRepository.saveConnectionData(fakeData))
          .thenAnswer((_) async {});

      bloc.add(const ObsSettingsSave(fakeData));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ObsSettingsLoaded>()
              .having((state) => state.data, 'data', fakeData),
        ]),
      );

      verify(mockRepository.saveConnectionData(fakeData)).called(1);
    });
  });
}
