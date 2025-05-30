import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';
import 'package:streamkeys/features/server/controllers/base_controller.dart';

class KeyboardDeckController extends BaseController {
  KeyboardDeckController();

  Future<Response> clickKey(
    Request request,
    String stringKeyCode,
  ) async {
    try {
      int keyCode = int.tryParse(stringKeyCode) ?? -1;
      final message = 'clicked $keyCode';
      if (kDebugMode) {
        print(message);
      }
      return Response.ok(message);
    } catch (e) {
      return BaseController.handleError(e);
    }
  }
}
