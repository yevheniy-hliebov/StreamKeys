enum KeyboardType { full, compact, numpad }

extension KeyboardTypeExtension on KeyboardType {
  bool get isFull => this == KeyboardType.full;
  bool get isCompact => this == KeyboardType.compact;
  bool get isNumpad => this == KeyboardType.numpad;
}
