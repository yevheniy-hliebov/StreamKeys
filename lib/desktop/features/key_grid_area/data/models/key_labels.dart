class KeyLabels {
  final String topLeft;
  final String topRight;
  final String center;
  final String bottomLeft;
  final String bottomRight;

  const KeyLabels({
    required this.topLeft,
    required this.topRight,
    required this.center,
    required this.bottomLeft,
    required this.bottomRight,
  });

  factory KeyLabels.fromJson(Map<String, dynamic> json) {
    return KeyLabels(
      topLeft: json['top-left'] ?? '',
      topRight: json['top-right'] ?? '',
      center: json['center'] ?? '',
      bottomLeft: json['bottom-left'] ?? '',
      bottomRight: json['bottom-right'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'top-left': topLeft,
      'top-right': topRight,
      'center': center,
      'bottom-left': bottomLeft,
      'bottom-right': bottomRight,
    };
  }

  bool get isEmpty =>
      topLeft.isEmpty &&
      topRight.isEmpty &&
      center.isEmpty &&
      bottomLeft.isEmpty &&
      bottomRight.isEmpty;

  bool get isNotEmpty => !isEmpty;
}
