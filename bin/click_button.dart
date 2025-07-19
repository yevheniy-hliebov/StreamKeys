import 'dart:io';
import 'package:http/http.dart' as http;

void main(List<String> arguments) async {
  if (arguments.length < 3) {
    stderr.writeln('Usage: click_button.exe <keyCode> <password> <port>');
    exit(1);
  }

  final keyCode = arguments[0];
  final password = arguments[1];
  final port = arguments[2];
  final url = 'http://localhost:$port/api/keyboard';

  final response = await http.post(
    Uri.parse('$url/$keyCode'),
    headers: {
      'X-Api-Password': password,
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    stderr.writeln('Error: ${response.statusCode} - ${response.body}');
    exit(1);
  }
}
