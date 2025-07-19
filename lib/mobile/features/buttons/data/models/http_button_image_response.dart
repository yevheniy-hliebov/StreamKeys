import 'package:flutter/foundation.dart';

class HttpButtonImageResponse {
  final Uint8List bytes;
  final String contentType;

  const HttpButtonImageResponse({
    required this.bytes,
    required this.contentType,
  });
}