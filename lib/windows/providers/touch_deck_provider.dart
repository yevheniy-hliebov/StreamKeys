import 'package:streamkeys/windows/models/action_touch_button_info.dart';
import 'package:streamkeys/windows/models/base_action.dart';
import 'package:streamkeys/windows/models/page_touch_data.dart';
import 'package:streamkeys/windows/models/grid_template.dart';
import 'package:streamkeys/windows/services/touch_deck_service.dart';

class TouchDeckProvider extends ChangeNotifier {
  final TouchDeckService _service = TouchDeckService();

  List<String> orderPages = [];
  List<PageTouchData> pages = [];
  String? currentPage;
  GridTemplate currentGrid = GridTemplate(3, 2);
  List<GridTemplate> grids = GridTemplate.gridTemplates;

  ActionTouchButtonInfo? selectedButtonInfo;
  int? selectedButtonInfoIndex;

  TouchDeckProvider() {
    getData();
  }

  bool isCurrentPage(int index) {
    final pageName = orderPages[index];
    return currentPage == pageName;
  }

  List<ActionTouchButtonInfo> get buttonInfos {
    final pageTouchData = _getCurrentPageTouchData();
    return pageTouchData.actionButtonInfos;
  }

  ActionTouchButtonInfo? getButonInfo(int index) {
    try {
      return buttonInfos[index];
    } catch (e) {
      return null;
    }
  }

  FutureVoid setAction(int index, BaseAction action) async {
    final buttonInfo = buttonInfos[index];
    if (!buttonInfo.isHaveAction) {
      buttonInfo.action = action;
      buttonInfos[index] = buttonInfo;

      _savePageData();
      notifyListeners();
    }
  }

  bool isSelectedTouchButton(int index) {
    return selectedButtonInfoIndex == index;
  }

  void selectButton(int index) {
    final pageTouchData = _getCurrentPageTouchData();
    selectedButtonInfo = pageTouchData.actionButtonInfos[index];
    selectedButtonInfoIndex = index;
    notifyListeners();
  }

  void updateSelectedButtonInfo(ActionTouchButtonInfo buttonInfo) async {
    if (selectedButtonInfo != buttonInfo && selectedButtonInfoIndex != null) {
      final pageTouchData = _getCurrentPageTouchData();
      pageTouchData.actionButtonInfos[selectedButtonInfoIndex!] = buttonInfo;

      await _savePageData();
      notifyListeners();
    }
  }

  FutureVoid getData() async {
    final decodedJson = await _service.getData();
    pages = _service.parseMapPages(decodedJson['map_pages']);
    orderPages = pages.map((page) => page.pageName).toList();
    currentPage = decodedJson['current_page'];
    currentGrid = GridTemplate.fromJson(decodedJson['selected_grid']);
    notifyListeners();
  }

  FutureVoid reorderPage(int oldIndex, int newIndex) async {
    _reorderList(orderPages, oldIndex, newIndex);
    await _updatePageOrder();
  }

  FutureVoid reorderButton(int oldIndex, int newIndex) async {
    final pageTouchData = _getCurrentPageTouchData();
    _reorderList(pageTouchData.actionButtonInfos, oldIndex, newIndex);
    await _savePageData();
  }

  FutureVoid addPage() async {
    final decodedJson = await _service.getData();
    final uniquePageName = await _service.addPage(
      decodedJson,
      pages,
      'Page',
      currentGrid,
    );
    orderPages.add(uniquePageName);
    notifyListeners();
  }

  FutureVoid deletePage(int index) async {
    final pageName = orderPages[index];
    final decodedJson = await _service.getData();
    await _service.deletePage(
      decodedJson,
      pageName,
      pages,
      orderPages,
      currentPage,
    );
    notifyListeners();
  }

  FutureVoid selectPage(int index) async {
    _unSelectButtonInfo();

    final pageName = orderPages[index];

    if (!orderPages.contains(pageName)) {
      return;
    }

    final decodedJson = await _service.getData();

    final currentPageData = decodedJson['map_pages'][pageName];
    if (currentPageData != null) {
      final int currentButtons = currentPageData.length;
      final int newTotalButtons =
          currentGrid.numberOfColumns * currentGrid.numberOfRows;

      if (currentButtons < newTotalButtons) {
        _service.regenerateButtonsForPage(currentPageData, currentGrid);
        await _service.saveData(decodedJson);
      }
    }

    await _service.selectPage(decodedJson, pageName);
    currentPage = pageName;

    notifyListeners();
  }

  FutureVoid updateGrid(GridTemplate newGrid) async {
    _unSelectButtonInfo();

    final decodedJson = await _service.getData();
    currentGrid = newGrid;

    await _service.updateGridSize(decodedJson, newGrid, currentPage);
    notifyListeners();
  }

  FutureVoid regeneratePageButtons() async {
    if (currentPage == null) return;

    final decodedJson = await _service.getData();
    final pageJson = decodedJson['map_pages'][currentPage];

    if (pageJson != null) {
      final int currentButtons = pageJson['actionButtonInfo'].length;
      final int newTotalButtons =
          currentGrid.numberOfColumns * currentGrid.numberOfRows;

      if (currentButtons < newTotalButtons) {
        _service.regenerateButtonsForPage(pageJson, currentGrid);
        await _service.saveData(decodedJson);
        notifyListeners();
      }
    }
  }

  PageTouchData _getCurrentPageTouchData() {
    return pages.firstWhere(
      (page) => page.pageName == currentPage,
    );
  }

  FutureVoid _savePageData() async {
    final decodedJson = await _service.getData();
    final pageTouchData = pages.firstWhere(
      (page) => page.pageName == currentPage,
    );
    decodedJson['map_pages'][currentPage] = pageTouchData.toJson();
    await _service.saveData(decodedJson);
  }

  void _reorderList(List<dynamic> list, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final movedItem = list.removeAt(oldIndex);
    list.insert(newIndex, movedItem);
  }

  FutureVoid _updatePageOrder() async {
    final decodedJson = await _service.getData();
    decodedJson['page_order'] = orderPages;
    await _service.saveData(decodedJson);
  }

  void _unSelectButtonInfo() {
    selectedButtonInfo = null;
    selectedButtonInfoIndex = null;
    notifyListeners();
  }
}
