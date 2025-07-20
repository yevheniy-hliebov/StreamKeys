class VersionInfo {
  final String version;
  final String changelog;
  final bool isPrerelease;
  final String downloadUrl;

  const VersionInfo({
    required this.version,
    required this.changelog,
    required this.isPrerelease,
    required this.downloadUrl,
  });

  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    final asset = (json['assets'] as List)
        .firstWhere((a) => (a['name'] as String).endsWith('.zip')) as Map;

    return VersionInfo(
      version: json['tag_name'] as String,
      changelog: json['body'] as String? ?? '',
      isPrerelease: json['prerelease'] as bool,
      downloadUrl: asset['browser_download_url'] as String,
    );
  }
}