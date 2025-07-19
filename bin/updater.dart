import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:archive/archive_io.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('repo', abbr: 'r', defaultsTo: 'yevheniy-hliebov/StreamKeys')
    ..addOption('mode',
        abbr: 'm', allowed: ['stable', 'beta'], defaultsTo: 'stable')
    ..addOption('target',
        abbr: 't', help: 'Path to application folder', defaultsTo: '.');
  final result = parser.parse(args);

  final repo = result['repo'] as String;
  final mode = result['mode'] as String;
  final targetDir = result['target'] as String;

  final releaseZipPath = await downloadLatestRelease(repo, mode);
  final tempDir = p.dirname(releaseZipPath);
  final appFolder = await extractArchive(releaseZipPath, tempDir);

  final targetAppDir = Directory(p.join(targetDir, p.basename(appFolder.path)));
  stdout.writeln('Copying update to $targetDir...');
  await copyDirectory(appFolder, targetAppDir);

  await tryRestoreHidmacros(targetDir, targetAppDir, appFolder);

  await terminateStreamKeys();
  await launchStreamKeys(p.join(targetDir, 'StreamKeys.exe'));
}

Future<String> downloadLatestRelease(String repo, String mode) async {
  final response = await http.get(
    Uri.parse('https://api.github.com/repos/$repo/releases'),
    headers: {'Accept': 'application/vnd.github.v3+json'},
  );

  if (response.statusCode != 200) {
    stderr.writeln('Failed to fetch releases: HTTP ${response.statusCode}');
    exit(1);
  }

  final releases = json.decode(response.body) as List<dynamic>;
  final filtered = releases.where((r) {
    final prerelease = r['prerelease'] as bool;
    return mode == 'beta' ? prerelease : !prerelease;
  }).toList();

  if (filtered.isEmpty) {
    stdout.writeln('No releases found for mode "$mode".');
    exit(0);
  }

  filtered.sort(
      (a, b) => (b['tag_name'] as String).compareTo(a['tag_name'] as String));
  final latest = filtered.first as Map<String, dynamic>;
  final asset = (latest['assets'] as List)
          .firstWhere((a) => (a['name'] as String).endsWith('.zip'))
      as Map<String, dynamic>;

  final url = asset['browser_download_url'] as String;
  stdout.writeln('Downloading ${latest['tag_name']} from $url');

  final tempDir = await Directory.systemTemp.createTemp('update_');
  final zipPath = p.join(tempDir.path, 'update.zip');
  final zipFile = File(zipPath);
  await zipFile.writeAsBytes(await http.readBytes(Uri.parse(url)));

  return zipPath;
}

Future<Directory> extractArchive(String zipPath, String tempDirPath) async {
  stdout.writeln('Extracting archive...');
  final archive = ZipDecoder().decodeBytes(File(zipPath).readAsBytesSync());
  for (final file in archive) {
    final outPath = p.join(tempDirPath, file.name);
    if (file.isFile) {
      File(outPath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(file.content as List<int>);
    } else {
      Directory(outPath).createSync(recursive: true);
    }
  }

  final extracted = Directory(tempDirPath).listSync();
  stdout.writeln('Found files/folders:');
  for (final entity in extracted) {
    stdout.writeln(' - ${entity.path}');
  }

  return extracted
      .whereType<Directory>()
      .firstWhere((dir) => p.basename(dir.path).startsWith('app-'));
}

Future<void> tryRestoreHidmacros(
    String targetDir, Directory targetAppDir, Directory newAppFolder) async {
  final previousVersions = Directory(targetDir)
      .listSync()
      .whereType<Directory>()
      .where((dir) =>
          p.basename(dir.path).startsWith('app-') &&
          p.basename(dir.path) != p.basename(newAppFolder.path))
      .toList();

  if (previousVersions.isEmpty) {
    stdout.writeln('No previous versions found.');
    return;
  }

  previousVersions.sort((a, b) => b.path.compareTo(a.path));
  final previousApp = previousVersions.first;

  final prevHidmacrosPath = p.join(previousApp.path, 'data', 'flutter_assets',
      'assets', 'hidmacros', 'hidmacros.xml');
  final newHidmacrosPath = p.join(targetAppDir.path, 'data', 'flutter_assets',
      'assets', 'hidmacros', 'hidmacros.xml');

  final prevFile = File(prevHidmacrosPath);
  if (await prevFile.exists()) {
    await File(newHidmacrosPath).create(recursive: true);
    await prevFile.copy(newHidmacrosPath);
    stdout.writeln('Copied hidmacros.xml from the previous version.');
  } else {
    stdout.writeln('hidmacros.xml not found in the previous version.');
  }
}

Future<void> copyDirectory(Directory source, Directory destination) async {
  await for (final entity in source.list(recursive: true)) {
    final newPath = entity.path.replaceFirst(source.path, destination.path);
    if (entity is File) {
      await File(newPath).create(recursive: true);
      await entity.copy(newPath);
    } else if (entity is Directory) {
      await Directory(newPath).create(recursive: true);
    }
  }
}

Future<void> terminateStreamKeys() async {
  stdout.writeln('Terminating StreamKeys.exe...');
  try {
    final result =
        await Process.run('taskkill', ['/F', '/IM', 'StreamKeys.exe']);
    if ((result.stdout as String).contains('SUCCESS')) {
      stdout.writeln('StreamKeys.exe terminated.');
    } else {
      stdout.writeln('StreamKeys.exe was not running or already terminated.');
    }
  } catch (e) {
    stderr.writeln('Error while terminating StreamKeys.exe: $e');
  }
}

Future<void> launchStreamKeys(String exePath) async {
  stdout.writeln('Launching $exePath...');
  try {
    await Process.start(exePath, [], mode: ProcessStartMode.detached);
    stdout.writeln('StreamKeys.exe launched.');
  } catch (e) {
    stderr.writeln('Failed to launch StreamKeys.exe: $e');
  }
}
