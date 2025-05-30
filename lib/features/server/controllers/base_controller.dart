import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';

abstract class BaseController {
  static Response handleError(dynamic error) {
    if (kDebugMode) {
      print('Error: $error');
    }
    return Response.internalServerError(
        body: 'An error occurred: ${error.toString()}');
  }
}
