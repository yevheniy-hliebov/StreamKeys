import 'package:equatable/equatable.dart';

class KeyboardDevice extends Equatable {
  final String name;
  final String systemId;

  const KeyboardDevice(this.name, this.systemId);
  
  @override
  List<Object?> get props => [name, systemId];
}