class DeviceInfo {
  final String ip;
  final String name;

  const DeviceInfo({
    required this.ip,
    required this.name,
  });

  String get nameAndHost => "$name - $ip";
}
