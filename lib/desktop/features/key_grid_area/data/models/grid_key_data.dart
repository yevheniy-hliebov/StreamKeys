import 'package:streamkeys/desktop/features/key_grid_area/data/models/base_key_data.dart';

class GridKeyData extends BaseKeyData {
  GridKeyData({
    required super.keyCode,
    required super.name,
  });

  factory GridKeyData.fromJson(Map<String, dynamic> json) {
    return GridKeyData(
      keyCode: json['key_code'],
      name: json['key_name'],
    );
  }
}
