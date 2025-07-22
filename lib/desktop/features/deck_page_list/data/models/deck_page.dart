import 'package:streamkeys/common/models/typedef.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_json_keys.dart';
import 'package:uuid/uuid.dart';

class DeckPage {
  final String id;
  final String name;

  DeckPage({required this.id, required this.name});

  factory DeckPage.create({String? id, required String name}) {
    return DeckPage(id: id ?? const Uuid().v4(), name: name);
  }

  factory DeckPage.createWithUniqueName({
    String? id,
    required List<DeckPage> pages,
  }) {
    return DeckPage(
      id: id ?? const Uuid().v4(),
      name: _generateUniqueName(pages),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckPage && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Json toJson() {
    return {DeckJsonKeys.pageId: id, DeckJsonKeys.pageName: name};
  }

  factory DeckPage.fromJson(Json json) {
    return DeckPage(
      id: json[DeckJsonKeys.pageId],
      name: json[DeckJsonKeys.pageName],
    );
  }

  static List<DeckPage> fromJsonList(List<Json> list) {
    return list.map((json) {
      return DeckPage.fromJson(json);
    }).toList();
  }

  static String _generateUniqueName(List<DeckPage> pages) {
    const String baseName = 'Page';
    String name = baseName;
    int counter = 1;

    final existingNames = pages.map((page) => page.name).toSet();

    while (existingNames.contains(name)) {
      name = '$baseName $counter';
      counter++;
    }

    return name;
  }
}
