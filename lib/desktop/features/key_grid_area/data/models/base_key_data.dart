import 'package:equatable/equatable.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_type.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/grid_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';

abstract class BaseKeyData extends Equatable {
  final int keyCode;
  final String name;

  const BaseKeyData({required this.keyCode, required this.name});

  BaseKeyData parseKeyData(Map<String, dynamic> json, DeckType deckType) {
    if (deckType.isKeyboard) {
      return KeyboardKeyData.fromJson(json);
    } else {
      return GridKeyData.fromJson(json);
    }
  }

  @override
  List<Object?> get props => [keyCode];
}
