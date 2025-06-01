part of 'keyboard_map_bloc.dart';

sealed class KeyboardMapState extends Equatable {
  const KeyboardMapState();

  @override
  List<Object?> get props => [];
}

final class KeyboardMapInitial extends KeyboardMapState {}

final class KeyboardMapLoading extends KeyboardMapState {}

class KeyboardMapLoaded extends KeyboardMapState with EquatableMixin {
  final KeyboardKey? selectedKey;
  final String? pageName;
  final Map<String, KeyboardKeyData> keyDataMap;

  KeyboardMapLoaded({
    required this.selectedKey,
    required this.keyDataMap,
    this.pageName,
  });

  @override
  List<Object?> get props => [selectedKey, keyDataMap, pageName];
}
