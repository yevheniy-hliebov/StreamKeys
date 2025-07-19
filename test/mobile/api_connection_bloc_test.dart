import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/mobile/features/api_connection/bloc/api_connection_bloc.dart';
import 'package:streamkeys/core/storage/connection_settings_repository.dart';
import 'package:streamkeys/mobile/features/api_connection/data/models/api_connection_data.dart';

import 'api_connection_bloc_test.mocks.dart';

@GenerateMocks([ConnectionSettingsRepository])
void main() {
  late MockConnectionSettingsRepository<ApiConnectionData> mockRepository;
  late ApiConnectionBloc bloc;

  const testData = ApiConnectionData(ip: '127.0.0.1', port: '8080', password: 'pass');

  setUp(() {
    mockRepository = MockConnectionSettingsRepository<ApiConnectionData>();
    bloc = ApiConnectionBloc(mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('ApiConnectionBloc', () {
    blocTest<ApiConnectionBloc, ApiConnectionState>(
      'emits [ApiConnectionLoaded] with data on ApiConnectionLoad',
      build: () {
        when(mockRepository.loadConnectionData()).thenAnswer((_) async => testData);
        return bloc;
      },
      act: (bloc) => bloc.add(ApiConnectionLoad()),
      expect: () => [const ApiConnectionLoaded(testData)],
      verify: (_) {
        verify(mockRepository.loadConnectionData()).called(1);
      },
    );

    blocTest<ApiConnectionBloc, ApiConnectionState>(
      'emits [ApiConnectionLoaded] with data on ApiConnectionSave',
      build: () {
        when(mockRepository.saveConnectionData(testData)).thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(const ApiConnectionSave(testData)),
      expect: () => [const ApiConnectionLoaded(testData)],
      verify: (_) {
        verify(mockRepository.saveConnectionData(testData)).called(1);
      },
    );
  });
}
