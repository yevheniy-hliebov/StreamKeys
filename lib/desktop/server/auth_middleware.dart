import 'package:shelf/shelf.dart';
import 'package:streamkeys/desktop/features/settings/data/services/http_server_password_service.dart';

Middleware authMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      final passwordService = HttpServerPasswordService();
      final password = await passwordService.loadOrCreatePassword();
      final headerPassword = request.headers['X-Api-Password'];

      if (headerPassword == null || headerPassword != password) {
        return Response.forbidden('Invalid password');
      }

      return innerHandler(request);
    };
  };
}
