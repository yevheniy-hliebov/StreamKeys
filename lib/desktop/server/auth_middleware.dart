import 'package:shelf/shelf.dart';
import 'package:streamkeys/service_locator.dart';

Middleware authMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      final passwordService = sl<HttpServerPasswordService>();
      final password = await passwordService.loadOrCreatePassword();
      final headerPassword = request.headers['X-Api-Password'];

      if (headerPassword == null || headerPassword != password) {
        return Response.forbidden('Invalid password');
      }

      return innerHandler(request);
    };
  };
}
