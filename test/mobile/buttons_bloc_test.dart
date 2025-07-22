import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/grid_template.dart';
import 'package:streamkeys/mobile/features/buttons/bloc/buttons_bloc.dart';
import 'package:streamkeys/mobile/features/buttons/data/models/http_buttons_response.dart';
import 'package:streamkeys/mobile/features/buttons/data/repositories/buttons_repository.dart';

import 'buttons_bloc_test.mocks.dart';

@GenerateMocks([ButtonsRepository])
void main() {
  late MockButtonsRepository mockRepository;
  late ButtonsBloc bloc;

  final fakeButtonsResponse = HttpButtonsResponse(
    gridTemplate: GridTemplate.gridTemplates[0],
    currentPageId: 'current-id',
    pageMap: {},
  );

  setUp(() {
    mockRepository = MockButtonsRepository();
    bloc = ButtonsBloc(mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('ButtonsBloc', () {
    blocTest<ButtonsBloc, ButtonsState>(
      'emits [ButtonsLoading, ButtonsLoaded] when fetchButtons succeeds',
      build: () {
        when(mockRepository.fetchButtons()).thenAnswer((_) async => fakeButtonsResponse);
        return bloc;
      },
      act: (bloc) => bloc.add(ButtonsLoad()),
      expect: () => [
        ButtonsLoading(),
        ButtonsLoaded(fakeButtonsResponse),
      ],
      verify: (_) {
        verify(mockRepository.fetchButtons()).called(1);
      },
    );

    blocTest<ButtonsBloc, ButtonsState>(
      'emits [ButtonsLoading, ButtonsError] when fetchButtons throws',
      build: () {
        when(mockRepository.fetchButtons()).thenThrow(Exception('fail'));
        return bloc;
      },
      act: (bloc) => bloc.add(ButtonsLoad()),
      expect: () => [
        ButtonsLoading(),
        isA<ButtonsError>(),
      ],
      verify: (_) {
        verify(mockRepository.fetchButtons()).called(1);
      },
    );

    blocTest<ButtonsBloc, ButtonsState>(
      'emits [ButtonsLoading, ButtonsLoaded] when ButtonsRefresh is added',
      build: () {
        when(mockRepository.fetchButtons()).thenAnswer((_) async => fakeButtonsResponse);
        return bloc;
      },
      act: (bloc) => bloc.add(ButtonsRefresh()),
      expect: () => [
        ButtonsLoading(),
        ButtonsLoaded(fakeButtonsResponse),
      ],
      verify: (_) {
        verify(mockRepository.fetchButtons()).called(1);
      },
    );
  });
}
