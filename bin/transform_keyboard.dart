import 'dart:convert';
import 'dart:io';

void main() async {
  final inputFile = File('assets/keyboard_map.json');
  final inputJson = jsonDecode(await inputFile.readAsString());

  // Function to transform a block
  List<int> transformBlock(block) {
    final result = <int>[];

    // block can be a list of lists
    for (var row in block) {
      for (var key in row) {
        if (key is Map && key.containsKey('key_code')) {
          result.add(key['key_code'] as int);
        }
      }
    }
    return result;
  }

  // Transform each block
  final outputJson = {
    'function_block': transformBlock(inputJson['function_block']),
    'main_block': transformBlock(inputJson['main_block']),
    'navigation_block': transformBlock(inputJson['navigation_block']),
    'numpad': transformBlock(inputJson['numpad_block']),
  };

  // Write to file
  final outputFile = File('assets/keyboard_key_codes.json');
  await outputFile.writeAsString(
    const JsonEncoder.withIndent(' ').convert(outputJson),
  );

  stderr.writeln(' ✅ Done! Saved to keyboard_key_codes.json');
}
