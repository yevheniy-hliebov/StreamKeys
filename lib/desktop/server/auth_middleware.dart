import 'package:shelf/shelf.dart';

Middleware authMiddleware(String Function() getPassword) {
  return (Handler innerHandler) {
    return (Request request) async {
      final password = request.url.queryParameters['password'];

      if (password != getPassword()) {
        return Response.forbidden('Invalid password');
      }

      return innerHandler(request);
    };
  };
}
