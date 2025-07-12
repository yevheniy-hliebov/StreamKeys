import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';

import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/action_state_enum.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/record_or_stream_action.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:obs_websocket/obs_websocket.dart' as obs;
import 'package:obs_websocket/src/request/record.dart' as record;
import 'package:obs_websocket/src/request/stream.dart' as stream;

import 'record_or_stream_action_test.mocks.dart';

@GenerateMocks([ObsService, obs.ObsWebSocket, record.Record, stream.Stream])
void main() {
  late MockObsService mockObsService;
  late MockObsWebSocket mockObs;
  late MockRecord mockRecord;
  late MockStream mockStream;

  setUp(() {
    mockObsService = MockObsService();
    mockObs = MockObsWebSocket();
    mockRecord = MockRecord();
    mockStream = MockStream();

    when(mockObsService.obs).thenReturn(mockObs);
    when(mockObs.record).thenReturn(mockRecord);
    when(mockObs.stream).thenReturn(mockStream);
    sl.reset();
  });



  group('RecordOrStreamAction', () {
    test('label returns correct string for record start', () {
      final action = RecordOrStreamAction(
        type: ActionTypes.obsRecord,
        state: ProcessState.start,
      );
      expect(action.label, 'OBS | Start Record');
    });

    test('label returns correct string for stream stop', () {
      final action = RecordOrStreamAction(
        type: ActionTypes.obsStream,
        state: ProcessState.stop,
      );
      expect(action.label, 'OBS | Stop Stream');
    });

    test('copy returns new instance with same values', () {
      final action = RecordOrStreamAction(
        type: ActionTypes.obsRecord,
        state: ProcessState.toggle,
      );
      final copy = action.copy() as RecordOrStreamAction;

      expect(copy.type, action.type);
      expect(copy.state, action.state);
      expect(copy.name, action.name);
      expect(copy, isNot(same(action)));
    });

    test('fromJson and toJson consistency', () {
      final original = RecordOrStreamAction(
        type: ActionTypes.obsRecord,
        state: ProcessState.stop,
      );
      final json = original.toJson();
      final fromJson = RecordOrStreamAction.fromJson(json);

      expect(fromJson.type, original.type);
      expect(fromJson.state, original.state);
    });

    test('execute calls startRecord on obs.record', () async {
      final action = RecordOrStreamAction(
        type: ActionTypes.obsRecord,
        state: ProcessState.start,
      );

      sl.registerSingleton<ObsService>(mockObsService);

      await action.execute();

      verify(mockRecord.startRecord()).called(1);
      verifyNever(mockRecord.stopRecord());
      verifyNever(mockRecord.toggleRecord());
      verifyNever(mockStream.startStream());
    });

    test('execute calls stopStream on obs.stream', () async {
      final action = RecordOrStreamAction(
        type: ActionTypes.obsStream,
        state: ProcessState.stop,
      );

      sl.registerSingleton<ObsService>(mockObsService);

      await action.execute();

      verify(mockStream.stopStream()).called(1);
      verifyNever(mockStream.startStream());
      verifyNever(mockStream.toggleStream());
      verifyNever(mockRecord.stopRecord());
    });

    test('execute calls toggleRecord on obs.record', () async {
      final action = RecordOrStreamAction(
        type: ActionTypes.obsRecord,
        state: ProcessState.toggle,
      );

      sl.registerSingleton<ObsService>(mockObsService);

      await action.execute();

      verify(mockRecord.toggleRecord()).called(1);
      verifyNever(mockRecord.startRecord());
      verifyNever(mockRecord.stopRecord());
      verifyNever(mockStream.toggleStream());
    });

    test('execute does nothing if obs is null', () async {
      when(mockObsService.obs).thenReturn(null);

      final action = RecordOrStreamAction(
        type: ActionTypes.obsRecord,
        state: ProcessState.start,
      );

      sl.registerSingleton<ObsService>(mockObsService);

      await action.execute();

      verify(mockObsService.obs).called(1);
      verifyNever(mockRecord.startRecord());
    });
  });
}
