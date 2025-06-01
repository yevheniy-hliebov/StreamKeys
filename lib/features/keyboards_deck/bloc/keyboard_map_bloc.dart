import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key_data.dart';
import 'package:streamkeys/features/keyboards_deck/data/repositories/keyboard_map_repository.dart';

part 'keyboard_map_event.dart';
part 'keyboard_map_state.dart';

class KeyboardMapBloc extends Bloc<KeyboardMapEvent, KeyboardMapState> {
  KeyboardMapRepository repo = KeyboardMapRepository();

  KeyboardKey? selectedKey;
  String? pageName;

  Map<String, KeyboardKeyData> keyDataMap = {};

  KeyboardMapBloc() : super(KeyboardMapInitial()) {
    on<KeyboardMapLoad>((event, emit) async {
      emit(KeyboardMapLoading());


      _loaded(emit);
    });
    on<KeyboardMapSelectKey>((event, emit) {
      selectedKey = event.keyboardKey;

      _loaded(emit);
    });
    on<KeyboardMapSelectPage>((event, emit) async {
      if (pageName != event.pageName) {
        selectedKey = null;
      }

      pageName = event.pageName;
      final loadedKeyDataMap = await repo.getKeyMapByPageName(pageName ?? '');
      keyDataMap = loadedKeyDataMap;

      print(keyDataMap['97']?.actions.length);

      _loaded(emit);
    });
    on<KeyboardMapUpdateKeyData>((event, emit) async {
      if (pageName != null) {
        final updatedMap = Map<String, KeyboardKeyData>.from(keyDataMap);
        updatedMap[event.keyData.code.toString()] = event.keyData.copy();

        keyDataMap = updatedMap;

        await repo.saveKeyDataToPage(pageName!, event.keyData);
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
