import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';

abstract class BaseController {
  Response handleError(Object error) {
    if (kDebugMode) {
      print('Error: $error');
    }
    return Response.internalServerError(
      body: 'An error occurred: ${error.toString()}',
    );
  }
}
