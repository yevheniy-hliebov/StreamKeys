import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key_data.dart';

part 'keyboard_map_event.dart';
part 'keyboard_map_state.dart';

class KeyboardMapBloc extends Bloc<KeyboardMapEvent, KeyboardMapState> {
  KeyboardKey? selectedKey;
  String? pageName;
  Map<String, Map<String, KeyboardKeyData>> mapPages = {
    'Default page': {},
  };

  Map<String, KeyboardKeyData> get keyDataMap {
    return Map<String, KeyboardKeyData>.from(mapPages[pageName] ?? {});
  }

  KeyboardMapBloc() : super(KeyboardMapInitial()) {
    on<KeyboardMapLoad>((event, emit) {
      emit(KeyboardMapLoading());

      _loaded(emit);
    });
    on<KeyboardMapSelectKey>((event, emit) {
      selectedKey = event.keyboardKey;

      _loaded(emit);
    });
    on<KeyboardMapSelectPage>((event, emit) {
      if (pageName != event.pageName) {
        selectedKey = null;
      }

      pageName = event.pageName;

      _loaded(emit);
    });
    on<KeyboardMapUpdateKeyData>((event, emit) {
      if (mapPages.containsKey(pageName)) {
        mapPages[pageName]![event.keyData.code.toString()] =
            event.keyData.copy();
        print(
            mapPages[pageName]![event.keyData.code.toString()]?.actions.length);
      }

      _loaded(emit);
    });
  }

  void _loaded(Emitter<KeyboardMapState> emit) {
    emit(KeyboardMapLoaded(
      selectedKey: selectedKey,
      keyDataMap: keyDataMap,
      pageName: pageName,
    ));
  }
}
