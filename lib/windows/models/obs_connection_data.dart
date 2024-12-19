import 'package:streamkeys/windows/models/typedefs.dart';

class OBSConnectionData {
  String url;
  String password;

  OBSConnectionData({
    required this.url,
    required this.password,
  });

  factory OBSConnectionData.fromJson(Json json) {
    return OBSConnectionData(
      url: json['url'],
      password: json['password'],
    );
  }

  Json toJson() {
    return {
      'url': url,
      'password': password,
    };
  }
}
