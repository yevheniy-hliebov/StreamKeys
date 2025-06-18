import 'package:streamkeys/desktop/features/key_grid_area/data/models/base_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/key_labels.dart';

class KeyboardKeyData extends BaseKeyData {
  final KeyLabels labels;

  KeyboardKeyData({
    required super.keyCode,
    required super.name,
    required this.labels,
  });

  factory KeyboardKeyData.fromJson(Map<String, dynamic> json) {
    return KeyboardKeyData(
      keyCode: json['key_code'],
      name: json['key_name'],
      labels: KeyLabels.fromJson(json['labels'] ?? <String, dynamic>{}),
    );
  }
}

typedef KeyboardKeyBlock = List<List<KeyboardKeyData>>;