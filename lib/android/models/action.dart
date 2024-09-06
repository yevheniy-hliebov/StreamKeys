class ButtonAction {
  final int id;
  final String name;
  final bool hasImage;
  final bool disabled;

  const ButtonAction({
    required this.id,
    required this.name,
    required this.hasImage,
    required this.disabled,
  });

  static ButtonAction fromJson(Map<String, dynamic> json) {
    return ButtonAction(
      id: json['id'],
      name: json['name'],
      hasImage: json['hasImage'],
      disabled: json['disabled'],
    );
  }

  static List<ButtonAction> fromArrayJson(List<dynamic> list) {
    return list.map((action) {
      return fromJson(action);
    },).toList();
  }
}
