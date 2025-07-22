import 'dart:io';
import 'package:path/path.dart' as p;

void main() async {
  final exeDir = Directory.current.path;

  final appDirs = Directory(exeDir)
      .listSync()
      .whereType<Directory>()
      .where((d) => p.basename(d.path).startsWith('app-'))
      .toList();

  if (appDirs.isEmpty) {
    stderr.writeln('No app-* folders found next to the launcher.');
    exit(1);
  }

  // Function to compare versions like "3.0.0"
  int compareVersions(String v1, String v2) {
    List<int> parseVersion(String v) => v.split('.').map(int.parse).toList();

    final p1 = parseVersion(v1);
    final p2 = parseVersion(v2);
    for (int i = 0; i < p1.length && i < p2.length; i++) {
      if (p1[i] > p2[i]) return 1;
      if (p1[i] < p2[i]) return -1;
    }
    return p1.length.compareTo(p2.length);
  }

  // Find the folder with the highest version
  appDirs.sort((a, b) {
    final va = p.basename(a.path).substring(4); // trim 'app-'
    final vb = p.basename(b.path).substring(4);
    return compareVersions(vb, va); // sort descending
  });

  final latestDir = appDirs.first;
  final exePath = p.join(latestDir.path, 'streamkeys.exe');

  if (!File(exePath).existsSync()) {
    stderr.writeln('streamkeys.exe file not found in ${latestDir.path}');
    exit(1);
  }

  // Launch streamkeys.exe and exit
  await Process.start(exePath, [], mode: ProcessStartMode.detached);
  stdout.writeln('Launched: $exePath');
}
