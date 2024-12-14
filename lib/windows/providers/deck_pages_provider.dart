import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/typedefs.dart';
import 'package:streamkeys/windows/services/deck_pages_service.dart';

class DeckPagesProvider extends ChangeNotifier {
  final String deckType;
  late DeckPagesService service;

  List<String> orderPages = [];
  String? currentPage;

  DeckPagesProvider(this.deckType) {
    init();
  }

  FutureVoid init() async {
    service = DeckPagesService(deckType);
    await service.init();
    await getData();

    notifyListeners();
  }

  FutureVoid getData() async {
    final data = service.jsonData;
    orderPages = List<String>.from(data['page_order']);
    currentPage = data['current_page'];

    notifyListeners();
  }

  FutureVoid addPage() async {
    final uniquePageName = await service.addPage(
      'Page',
    );
    orderPages.add(uniquePageName);
    notifyListeners();
  }

  FutureVoid deletePage(int index) async {
    final pageName = orderPages[index];
    await service.deletePage(
      pageName,
      orderPages,
      currentPage,
    );
    notifyListeners();
  }

  bool isCurrentPage(int index) {
    final pageName = orderPages[index];
    return currentPage == pageName;
  }

  FutureVoid selectPage(int index) async {
    final pageName = orderPages[index];

    if (!orderPages.contains(pageName)) {
      return;
    }

    await service.selectPage(pageName);
    currentPage = pageName;

    notifyListeners();
  }

  FutureVoid reorderPage(int oldIndex, int newIndex) async {
    _reorderList(orderPages, oldIndex, newIndex);
    await _updatePageOrder();
  }

  void _reorderList(List<dynamic> list, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    if (newIndex < 0) {
      newIndex = 0;
    } else if (newIndex > list.length) {
      newIndex = list.length;
    }

    final movedItem = list.removeAt(oldIndex);
    list.insert(newIndex, movedItem);
  }

  FutureVoid _updatePageOrder() async {
    service.jsonData['page_order'] = orderPages;
    await service.saveData();
  }
}
