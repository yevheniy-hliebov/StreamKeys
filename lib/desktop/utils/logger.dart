import 'package:flutter/foundation.dart';

// ignore: one_member_abstracts
abstract class ILogger {
  void call({String service = '', required String msg});
}

class Logger implements ILogger {
  Logger._internal();

  static final Logger _instance = Logger._internal();

  factory Logger() => _instance;

  @override
  void call({String service = '', required String msg}) {
    if (kDebugMode) {
      final serviceText = service.isEmpty ? '' : '$service: ';
      print('$serviceText$msg');
    }
  }
}
