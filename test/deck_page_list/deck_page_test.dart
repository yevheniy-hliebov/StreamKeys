import 'package:flutter_test/flutter_test.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_json_keys.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_page.dart';

void main() {
  group('DeckPage', () {
    test('create() assigns given name and generates id if null', () {
      final page = DeckPage.create(name: 'Test');
      expect(page.name, 'Test');
      expect(page.id, isNotEmpty);

      const customId = 'custom-id';
      final pageWithId = DeckPage.create(id: customId, name: 'Test2');
      expect(pageWithId.id, customId);
      expect(pageWithId.name, 'Test2');
    });

    test('createWithUniqueName() generates unique name', () {
      final pages = [
        DeckPage(id: '1', name: 'Page'),
        DeckPage(id: '2', name: 'Page 1'),
      ];
      final page = DeckPage.createWithUniqueName(pages: pages);
      expect(page.name, 'Page 2');
      expect(page.id, isNotEmpty);
    });

    test('== compares by id', () {
      final page1 = DeckPage(id: 'id1', name: 'Name1');
      final page2 = DeckPage(id: 'id1', name: 'Name2');
      final page3 = DeckPage(id: 'id3', name: 'Name1');

      expect(page1, equals(page2));
      expect(page1 == page3, isFalse);
    });

    test('toJson() serializes correctly', () {
      final page = DeckPage(id: 'id', name: 'name');
      final json = page.toJson();
      expect(json[DeckJsonKeys.pageId], 'id');
      expect(json[DeckJsonKeys.pageName], 'name');
    });

    test('fromJson() deserializes correctly', () {
      final json = {DeckJsonKeys.pageId: 'id', DeckJsonKeys.pageName: 'name'};
      final page = DeckPage.fromJson(json);
      expect(page.id, 'id');
      expect(page.name, 'name');
    });

    test('fromJsonList() deserializes list correctly', () {
      final list = [
        {DeckJsonKeys.pageId: 'id1', DeckJsonKeys.pageName: 'name1'},
        {DeckJsonKeys.pageId: 'id2', DeckJsonKeys.pageName: 'name2'},
      ];
      final pages = DeckPage.fromJsonList(list);
      expect(pages.length, 2);
      expect(pages[0].id, 'id1');
      expect(pages[1].name, 'name2');
    });
  });
}
