import 'dart:convert';

import 'package:streamkeys/core/constants/version.dart';
import 'package:streamkeys/desktop/features/app_update/data/models/version_info.dart';
import 'package:http/http.dart' as http;

class VersionChecker {
  final String repo;

  const VersionChecker({required this.repo});

  Future<VersionInfo?> fetchLatestVersionInfo({
    AppVersionMode mode = AppVersionMode.stable,
  }) async {
    final response = await http.get(
      Uri.parse('https://api.github.com/repos/$repo/releases'),
      headers: {'Accept': 'application/vnd.github.v3+json'},
    );

    if (response.statusCode != 200) return null;

    final releases = jsonDecode(response.body) as List<dynamic>;

    final filtered = releases.where((r) {
      final prerelease = r['prerelease'] as bool;
      return mode == AppVersionMode.beta ? prerelease : !prerelease;
    });

    if (filtered.isEmpty) return null;

    filtered.toList().sort((a, b) =>
        (b['tag_name'] as String).compareTo(a['tag_name'] as String));

    final latest = filtered.first as Map<String, dynamic>;
    return VersionInfo.fromJson(latest);
  }
}
