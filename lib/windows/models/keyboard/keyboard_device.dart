// ignore_for_file: deprecated_member_use

import 'package:streamkeys/windows/models/typedefs.dart';

class KeyboardDevice {
  final String name;
  final String systemId;

  KeyboardDevice(
    this.name,
    this.systemId,
  );

  Json toJson() {
    return {
      'name': name,
      'system_id': systemId,
    };
  }

  @override
  String toString() {
    return 'Name: $name, SystemID: $systemId';
  }

  factory KeyboardDevice.fromJson(Json json) {
    return KeyboardDevice(
      json['name'],
      json['system_id'],
    );
  }
}
