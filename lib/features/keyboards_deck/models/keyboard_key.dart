import 'package:streamkeys/common/models/typedefs.dart';

class KeyboardKey {
  final int code;
  final String name;
  final KeyLabels labels;

  const KeyboardKey({
    required this.code,
    required this.name,
    required this.labels,
  });

  factory KeyboardKey.fromJson(Json json) {
    return KeyboardKey(
      code: json['key_code'],
      name: json['key_name'],
      labels: KeyLabels.fromJson(json['labels']),
    );
  }
}

class KeyLabels {
  final String topLeft;
  final String topRight;
  final String center;
  final String bottomLeft;
  final String bottomRight;

  const KeyLabels({
    this.topLeft = '',
    this.topRight = '',
    this.center = '',
    this.bottomLeft = '',
    this.bottomRight = '',
  });

  factory KeyLabels.fromJson(Json json) {
    return KeyLabels(
      topLeft: json['top-left'] ?? '',
      topRight: json['top-right'] ?? '',
      center: json['center'] ?? '',
      bottomLeft: json['bottom-left'] ?? '',
      bottomRight: json['bottom-right'] ?? '',
    );
  }
}
